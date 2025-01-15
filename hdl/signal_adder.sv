module signal_adder (
    input logic [15:0] low_out,
    input logic [15:0] mid_out,
    input logic [15:0] high_out,
    output logic [15:0] audio_out
);
    assign audio_out = (low_out + mid_out + high_out);
endmodule
