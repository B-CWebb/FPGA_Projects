module UART(
    input wire CLOCK_50, 
    input wire [1:0] KEY,
    input [9:0] SW,
    inout wire [35:0] GPIO
    output reg LEDR
    //output reg out
);

wire load, enable, out1, RShift;
wire [7:0] LEDOut;
assign GPIO[1] = out1;

wire trigger;

reg a, b, c;
always @(posedge CLOCK_50) begin
    a <= ~KEY[1];
    b <= a;
    c <= b;
end

assign trigger = c & (!b);

UARTState DUT1 (.CLOCK_50(CLOCK_50), .button(trigger), .enable(enable), .load(load));
TenBitShift DUT2 (.clk(CLOCK_50), .key(SW[7:0]), .enable(enable), .load(load), .out(out1));
UARTState2 DUT3 (.CLOCK_50(CLOCK_50), .RShift(RShift));
TenBitShift2 DUT4 (.enable(RShift), .CLOCK_50(.CLOCK_50), .out(LEDOut));

always@(*)begin
  LEDR[7:0] = LEDOut[7:0];
end

endmodule