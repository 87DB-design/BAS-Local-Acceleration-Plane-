// ============================================================================
// Module: envelope_808_reg
// Description: 128-bit byte-aligned tryte container register for the 8:0:8 bridge.
// ============================================================================
`timescale 1ns / 1ps

module envelope_808_reg (
    input  logic         clk,
    input  logic         rst_n,
    input  logic         we,
    input  logic [127:0] din,
    output logic [127:0] dout
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= 128'h0;
        end else if (we) begin
            dout <= din;
        end
    end

endmodule
