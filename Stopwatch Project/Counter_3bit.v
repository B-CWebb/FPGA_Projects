module Counter_3bit(
    input wire clk, Enable, Reset, 
    output reg Rollover,
    output reg [3:0] Q


);

initial begin
    Q = 4'b0000;
end

always @(posedge clk) begin
    if (Reset == 1) Q <= 4'b0000;
    else if (Enable == 1) begin
        if (Q == 4'b0101) begin
        Q <= 4'b0000;
        Rollover <= 1;
        end 
        
        else begin
            Q <= Q + 4'b0001;
            Rollover <= 0;
        end
    end
    else begin
     Rollover <= 0;
    end
end

endmodule