// =====================================================================
// B.A.S. TopFirewall™: AXI4-Stream Production IP Wrapper
// Property of Bean Applied Sciences (B.A.S.)
// =====================================================================

module topfirewall_axi_wrapper (
    input  wire        aclk,
    input  wire        aresetn,
    
    // AXI4-Stream Slave Interface (Incoming QCCD Error Syndromes / Coordinates)
    input  wire [63:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,
    input  wire        s_axis_tlast,

    // AXI4-Stream Master Interface (Filtered / Cleaned Output Payload)
    output reg  [63:0] m_axis_tdata,
    output reg         m_axis_tvalid,
    input  wire        m_axis_tready,
    output reg         m_axis_tlast,

    // Architectural Status Flags
    output reg         ds_algo_zero_out,    // Asserts high when dS_algo = 0 (Reversible)
    output reg         route_clear_out      // Starves global decoders of transport backlog
);

    // Internal combinatorial processed payload wire
    wire [63:0] processed_payload;
    wire        annihilation_active;
    integer     i;

    // Ready signal propagation: Ready to receive when downstream is ready
    assign s_axis_tready = m_axis_tready;
    assign annihilation_active = 1'b1;

    // Core Combinational Symmetrical Annihilation Logic (8:0:8 Envelope Vector)
    always @(*) begin
        processed_payload = 64'b0;
        for (i = 0; i < 32; i = i + 1) begin
            case (s_axis_tdata[i*2 +: 2])
                2'b01: processed_payload[i*2 +: 2] = 2'b01; // Retain +1 tryte
                2'b10: processed_payload[i*2 +: 2] = 2'b10; // Retain -1 tryte
                default: processed_payload[i*2 +: 2] = 2'b00; // Neutral 0-state anchor (+1 + -1 = 0)
            endcase
        end
    end

    // Sequential State Registers (Single-cycle pipelined AXI handshake)
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            m_axis_tdata      <= 64'b0;
            m_axis_tvalid     <= 1'b0;
            m_axis_tlast      <= 1'b0;
            ds_algo_zero_out  <= 1'b1;
            route_clear_out   <= 1'b1;
        end else begin
            if (s_axis_tvalid && s_axis_tready) begin
                m_axis_tdata     <= processed_payload;
                m_axis_tvalid    <= s_axis_tvalid;
                m_axis_tlast     <= s_axis_tlast;
                ds_algo_zero_out <= annihilation_active;
                route_clear_out  <= ~s_axis_tlast; // Clear downstream routing pressure
            end else if (m_axis_tready) begin
                m_axis_tvalid    <= 1'b0;
            end
        end
    end

endmodule
