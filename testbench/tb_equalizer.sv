
module tb_equalizer;

    localparam CLK_PERIOD = 10; 

    logic clk;
    logic reset;
    
    logic signed [15:0] audio_in;
    logic signed [7:0] gain_low;
    logic signed [7:0] gain_mid;
    logic signed [7:0] gain_high;
    logic signed [15:0] audio_out;

    integer input_file;
    integer output_file;

    audio_equalizer uut (
        .clk(clk),
        .reset(reset),
        .audio_in(audio_in),
        .gain_low(gain_low),
        .gain_mid(gain_mid),
        .gain_high(gain_high),
        .audio_out(audio_out)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        reset = 1;
        #(3 * CLK_PERIOD);
        reset = 0;
    end

    reg [15:0] sine [0:29];
    integer i;  

    initial begin
        i = 1;
        sine[0] = 0;
        sine[1] = 16;
        sine[2] = 31;
        sine[3] = 45;
        sine[4] = 58;
        sine[5] = 67;
        sine[6] = 74;
        sine[7] = 77;
        sine[8] = 77;
        sine[9] = 74;
        sine[10] = 67;
        sine[11] = 58;
        sine[12] = 45;
        sine[13] = 31;
        sine[14] = 16;
        sine[15] = 0;
        sine[16] = -16;
        sine[17] = -31;
        sine[18] = -45;
        sine[19] = -58;
        sine[20] = -67;
        sine[21] = -74;
        sine[22] = -77;
        sine[23] = -77;
        sine[24] = -74;
        sine[25] = -67;
        sine[26] = -58;
        sine[27] = -45;
        sine[28] = -31;
        sine[29] = -16;
    end

    initial begin
        input_file = $fopen("input_audio.txt", "w");
        output_file = $fopen("output_audio.txt", "w");

        audio_in = 16'd0;

        gain_low = 8'd2;
        gain_mid = 8'd16;
        gain_high = 8'd64;

        @(negedge reset);

        @(posedge clk);
        repeat (100) begin
            @(posedge clk);
            audio_in = sine[i] + 16'd100;
            repeat (1) @(posedge clk);
            i += 4;
            if(i == 29) begin
                i = 1;
            end
        end

        @(posedge clk);
        audio_in = 16'd0;
        repeat (100) @(posedge clk);

        $fclose(input_file);
        $fclose(output_file);
        $finish;
    end

    always @(posedge clk) begin
        if (!reset) begin
            $fdisplay(input_file, "%d", audio_in);
            $fdisplay(output_file, "%d", audio_out);
        end
    end

endmodule
