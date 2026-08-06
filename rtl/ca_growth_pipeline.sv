// ============================================================================
// Module: ca_growth_pipeline
// Description: Parallel lattice expansion pipeline for 2D surface and color codes.
// ============================================================================
`timescale 1ns / 1ps

module ca_growth_pipeline #(
    parameter GRID_SIZE = 16
)(
    input  logic         clk,
    input  logic         rst_n,
    input  logic         start,
    input  logic [1:0]   grid_in  [0:GRID_SIZE-1][0:GRID_SIZE-1],
    output logic [1:0]   grid_out [0:GRID_SIZE-1][0:GRID_SIZE-1],
    output logic         done
);

    logic [1:0] current_grid [0:GRID_SIZE-1][0:GRID_SIZE-1];
    logic       active_changes;

    genvar r, c;
    generate
        for (r = 0; r < GRID_SIZE; r = r + 1) begin : ROW_GEN
            for (c = 0; c < GRID_SIZE; c = c + 1) begin : COL_GEN
                // Toroidal wrap-around neighbor indexing
                wire [3:0] r_up   = (r == 0) ? GRID_SIZE-1 : r-1;
                wire [3:0] r_down = (r == GRID_SIZE-1) ? 0 : r+1;
                wire [3:0] c_left = (c == 0) ? GRID_SIZE-1 : c-1;
                wire [3:0] c_right= (c == GRID_SIZE-1) ? 0 : c+1;

                symmetrical_annihilator_alu alu_inst (
                    .state_self    (current_grid[r][c]),
                    .neighbor_p_e1 (current_grid[r_up][c]),
                    .neighbor_n_e1 (current_grid[r_down][c]),
                    .neighbor_p_e2 (current_grid[r][c_left]),
                    .neighbor_n_e2 (current_grid[r][c_right]),
                    .next_state    (grid_out[r][c]),
                    .annihilated_flag()
                );
            end
        end
    endgenerate

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b1;
        end else if (start) begin
            done <= 1'b0;
            current_grid <= grid_in;
        end else begin
            current_grid <= grid_out;
            done <= 1'b1;
        end
    end

endmodule
