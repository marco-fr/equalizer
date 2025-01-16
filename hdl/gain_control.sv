module gain_control (
    input logic clk,
    input logic reset,
    input logic signed [15:0] low_band,
    input logic signed [15:0] mid_band,
    input logic signed [15:0] high_band,
    input logic signed [7:0] gain [0:2],
    output logic signed [15:0] low_out,
    output logic signed [15:0] mid_out,
    output logic signed [15:0] high_out
);
    assign low_out  = (low_band  * gain[0]);
    assign mid_out  = (mid_band  * gain[1]);
    assign high_out = (high_band * gain[2]);
endmodule
