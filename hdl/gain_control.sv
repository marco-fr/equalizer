module gain_control (
    input logic clk,
    input logic reset,
    input logic signed [15:0] low_band,
    input logic signed [15:0] mid_band,
    input logic signed [15:0] high_band,
    input logic signed [7:0] gain_low,
    input logic signed [7:0] gain_mid,
    input logic signed [7:0] gain_high,
    output logic signed [15:0] low_out,
    output logic signed [15:0] mid_out,
    output logic signed [15:0] high_out
);
    assign low_out  = (low_band  * gain_low);
    assign mid_out  = (mid_band  * gain_mid);
    assign high_out = (high_band * gain_high);
endmodule
