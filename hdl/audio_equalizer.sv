
module audio_equalizer (
    input logic clk,
    input logic reset,
    input logic signed [15:0] audio_in,
    input logic [7:0] gain_low,
    input logic [7:0] gain_mid,
    input logic [7:0] gain_high,
    output logic signed [15:0] audio_out
);
    logic [15:0] low_band, mid_band, high_band;
    logic [15:0] low_out, mid_out, high_out;

    filter_bank u_filter_bank (
        .clk(clk),
        .reset(reset),
        .audio_in(audio_in),
        .low_band(low_band),
        .mid_band(mid_band),
        .high_band(high_band)
    );

    gain_control u_gain_control (
        .clk(clk),
        .reset(reset),
        .low_band(low_band),
        .mid_band(mid_band),
        .high_band(high_band),
        .gain_low(gain_low),
        .gain_mid(gain_mid),
        .gain_high(gain_high),
        .low_out(low_out),
        .mid_out(mid_out),
        .high_out(high_out)
    );

    signal_adder u_signal_adder (
        .low_out(low_out),
        .mid_out(mid_out),
        .high_out(high_out),
        .audio_out(audio_out)
    );
    
endmodule
