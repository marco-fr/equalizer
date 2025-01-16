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
    parameter BAND_NUMBER = 3;

    logic signed [AUDIO_DEPTH - 1:0] COEFF[0:2][0:FILTER_SIZE];

    filter_coefficients filters(
        .coeff(COEFF)
    );

    logic signed [AUDIO_DEPTH - 1:0] delay_line[0:FILTER_SIZE];
    logic signed [AUDIO_DEPTH - 1: 0] out_band[0:2];

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            delay_line <= '{default: 16'd0};
        end else begin
            delay_line <= '{audio_in >>> 5, delay_line[0:FILTER_SIZE - 1]};
        end
    end
    
    always_comb begin
        for(int j = 0; j < BAND_NUMBER; j++) begin
            out_band[j] = 0;
            for (int i = 0; i < FILTER_SIZE + 1; i++) begin
                out_band[j] += (COEFF[j][FILTER_SIZE - i] * delay_line[i])/FILTER_PRECISION;
            end
        end
    end

    assign low_band = out_band[0];
    assign mid_band = out_band[1];
    assign high_band = out_band[2];

endmodule
