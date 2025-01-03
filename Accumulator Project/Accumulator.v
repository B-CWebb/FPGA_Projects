module Accumulator(
    input wire [7:0] D,
    input wire Reset, CLOCK_50, ASCIIEnable,
    output reg TXEnable,
    output reg [7:0] Q
);
integer haveReset = 0;
integer enable;
reg [7:0] a;

always @(posedge CLOCK_50) begin
    if (haveReset == 0)begin
    a <= 0; 
    haveReset <= 1;
    end
    else if (Reset == 1) begin a <= 0;
    end
    else if (ASCIIEnable == 1) begin 
        a <= a + D[3:0];
    end
    Q <= a;   
end


endmodule