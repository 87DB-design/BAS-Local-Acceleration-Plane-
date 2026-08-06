// ============================================================================
// Module: singleshot_4d_sweep_alu
// Description: 8-neighbor SIMD loop contractor for 4D hypercubic lattices (Z^4, z=8).
// ============================================================================
`timescale 1ns / 1ps

module singleshot_4d_sweep_alu (
    input  logic [1:0] state_self,
    input  logic [1:0] neighbor_p_e1,
    input  logic [1:0] neighbor_n_e1,
    input  logic [1:0] neighbor_p_e2,
    input  logic [1:0] neighbor_n_e2,
    input  logic [1:0] neighbor_p_e3,
    input  logic [1:0] neighbor_n_e3,
    input  logic [1:0] neighbor_p_e4,
    input  logic [1:0] neighbor_n_e4,
    output logic [1:0] next_state,
    output logic       annihilated_flag
);

    logic [3:0] pos_count, neg_count;

    always_comb begin
        pos_count = (neighbor_p_e1 == 2'b01) + (neighbor_p_e2 == 2'b01) + 
                    (neighbor_p_e3 == 2'b01) + (neighbor_p_e4 == 2'b01);
        neg_count = (neighbor_n_e1 == 2'b10) + (neighbor_n_e2 == 2'b10) + 
                    (neighbor_n_e3 == 2'b10) + (neighbor_n_e4 == 2'b10);

        if ((state_self == 2'b01 && neg_count > 0) || (state_self == 2'b10 && pos_count > 0)) begin
            next_state       = 2'b00;
            annihilated_flag = 1'b1;
        end else begin
            next_state       = state_self;
            annihilated_flag = 1'b0;
        end
    end

endmodule
