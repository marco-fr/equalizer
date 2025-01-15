module filter_bank (
    input logic clk,
    input logic reset,
    input logic signed [15:0] audio_in, // 16-bit audio sample
    output logic signed [15:0] low_band,
    output logic signed [15:0] mid_band,
    output logic signed [15:0] high_band
);
    parameter FILTER_SIZE = 100;
    parameter AUDIO_DEPTH = 16;
    parameter FILTER_PRECISION = 512;

    logic signed [AUDIO_DEPTH - 1:0] COEFF_LOW[0:FILTER_SIZE];
    logic signed [AUDIO_DEPTH - 1:0] COEFF_MID[0:FILTER_SIZE];
    logic signed [AUDIO_DEPTH - 1:0] COEFF_HIGH[0:FILTER_SIZE];

    filter_coefficients filters(
        .low_pass(COEFF_LOW),
        .mid_pass(COEFF_MID),
        .high_pass(COEFF_HIGH)
    );

    logic signed [AUDIO_DEPTH - 1:0] delay_line[0:FILTER_SIZE];

    logic signed [AUDIO_DEPTH - 1: 0] low;
    logic signed [AUDIO_DEPTH - 1: 0] mid;
    logic signed [AUDIO_DEPTH - 1: 0] high;

    integer i;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            delay_line <= '{default: 16'd0};
        end else begin
            delay_line <= '{audio_in >>> 5, delay_line[0:FILTER_SIZE - 1]};
        end
    end
    
    always_comb begin
        low = 0;
        mid = 0;
        high = 0;
        for (int i = 0; i < FILTER_SIZE + 1; i++) begin
            low += (COEFF_LOW[FILTER_SIZE - i] * delay_line[i])/FILTER_PRECISION;
            mid += (COEFF_MID[FILTER_SIZE - i] * delay_line[i])/FILTER_PRECISION;
            high += (COEFF_HIGH[FILTER_SIZE - i] * delay_line[i])/FILTER_PRECISION;
        end
    end

    assign low_band = low;
    assign mid_band = mid;
    assign high_band = high;

endmodule
