
module audio_equalizer (
    input logic clk,
    input logic reset,
    input logic signed [15:0] audio_in,
    input logic rx,
    output logic signed [15:0] audio_out
);
    logic [15:0] low_band, mid_band, high_band;
    logic [15:0] low_out, mid_out, high_out;
    logic baud_on;
    logic [7:0] gain[0:2];

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
        .gain(gain),
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

    baudgen u_baudgen (
        .clk(clk),
        .reset(reset),
        .baud_on(baud_on)
    );

    uart_reciever u_uart_reciever(
        .clk(clk),
        .reset(reset),
        .baud_on(baud_on),
        .rx(rx),
        .out_gain(gain)
    );

endmodule
