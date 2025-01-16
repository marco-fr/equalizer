module baudgen(
    input logic reset,
    input logic clk,
    output logic baud_on
);

parameter CLOCK_SPEED = 9600;
parameter BAUD_RATE = 9600;
parameter TPB = CLOCK_SPEED / BAUD_RATE;

logic[15:0] counter = 16'b0;

always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        counter <= 0;
        baud_on <= 0;
    end else begin
        if({16'b0,counter} == TPB - 1) begin
            counter <= 'b0;
            baud_on <= 1;
        end else begin
            counter <= counter + 'b1;
            baud_on <= 0;
        end
    end
end

endmodule
