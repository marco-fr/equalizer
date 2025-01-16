module uart_reciever(
    input logic clk,
    input logic reset,
    input logic baud_on,
    input logic rx,
    output logic[7:0] out_gain[0:2]
);

logic started = 0;
logic[4:0] counter = 4'b0;
logic[10:0] data = 3'b0;
logic[7:0] gain[0:2] = '{8'd32, 8'd32, 8'd32};

always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        started <= 0;
        counter <= 4'b0;
        data <= 0;
    end else begin
        if(baud_on) begin
            if(!started) begin
                if(!rx) begin
                    started <= 1;
                end
            end else begin
                data <= {rx, data[10:1]};
                counter <= counter + 'b1;
                if(counter == 11) begin
                    gain[data[2:0]] = data[10:3];
                    started <= 0;
                    counter <= 0;
                end
            end
        end
    end
end

assign out_gain = gain;

endmodule