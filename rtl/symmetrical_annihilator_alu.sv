// ============================================================================
// Module: symmetrical_annihilator_alu
// Description: Single-cycle combinational core for balanced ternary 
//              Symmetrical Annihilation (+1 + -1 -> 00_2, dS_algo = 0).
// ============================================================================
`timescale 1ns / 1ps

module symmetrical_annihilator_alu (
    input  logic [1:0] state_self,
    input  logic [1:0] neighbor_p_e1,
    input  logic [1:0] neighbor_n_e1,
    input  logic [1:0] neighbor_p_e2,
    input  logic [1:0] neighbor_n_e2,
    output logic [1:0] next_state,
    output logic       annihilated_flag
);

    // Tryte encoding: 2'b00 = 0, 2'b01 = +1, 2'b10 = -1
    logic [3:0] positive_sum;
    logic [3:0] negative_sum;

    always_comb begin
        positive_sum = (state_self == 2'b01 ? 1 : 0) + 
                       (neighbor_p_e1 == 2'b01 ? 1 : 0) + 
                       (neighbor_p_e2 == 2'b01 ? 1 : 0);
                       
        negative_sum = (state_self == 2'b10 ? 1 : 0) + 
                       (neighbor_n_e1 == 2'b10 ? 1 : 0) + 
                       (neighbor_n_e2 == 2'b10 ? 1 : 0);

        if ((state_self == 2'b01 && negative_sum > 0) || 
            (state_self == 2'b10 && positive_sum > 0)) begin
            next_state       = 2'b00; // Neutral 0-state anchor
            annihilated_flag = 1'b1;
        end else begin
            next_state       = state_self;
            annihilated_flag = 1'b0;
        end
    end

endmodule
