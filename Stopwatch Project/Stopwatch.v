module Stopwatch(
    input wire CLOCK_50,
    input wire [1:0] KEY,
    output reg [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
    
);

wire buttonOut;
Button DUTButton1 (.in(~KEY[1]), .out(buttonOut), .CLOCK_50(CLOCK_50));

//HexToSevenSeg module implementation
wire [7:0] hexOut10m, hexOut1m, hexOut10s, hexOut1s, hexOut10ms, hexOut100ms;
wire [3:0] hexIn10m, hexIn1m, hexIn10s, hexIn1s, hexIn100ms, hexIn10ms;
wire Rollover10m, Rollover1m, Rollover10s, Rollover1s, Rollover100ms, Rollover10ms, RolloverTimer;
//HEX0
Timer_10ms DUT10ms1 (.Reset(~KEY[0]), .clk(CLOCK_50), .Rollover(RolloverTimer));
Counter_4bit DUT10ms2 (.Reset(~KEY[0]), .clk(CLOCK_50), .Enable(buttonOut & RolloverTimer), .Rollover(Rollover10ms), .Q(hexIn10ms));
HexToSevenSeg DUT10ms3 (.hex(hexIn10ms), .out(hexOut10ms));
//HEX1
Counter_4bit DUT100ms2 (.Reset(~KEY[0]), .clk(CLOCK_50), .Enable(Rollover10ms), .Rollover(Rollover100ms), .Q(hexIn100ms));
HexToSevenSeg DUT100ms3 (.hex(hexIn100ms), .out(hexOut100ms));
//HEX2
Counter_4bit DUT1s2 (.Reset(~KEY[0]), .clk(CLOCK_50), .Enable(Rollover100ms), .Rollover(Rollover1s), .Q(hexIn1s));
HexToSevenSeg DUT1s3 (.hex(hexIn1s), .out(hexOut1s));
//HEX3
Counter_3bit DUT10s2 (.Reset(~KEY[0]), .clk(CLOCK_50), .Enable(Rollover1s), .Rollover(Rollover10s), .Q(hexIn10s));
HexToSevenSeg DUT10s3 (.hex(hexIn10s), .out(hexOut10s));
//HEX4
Counter_4bit DUT1m2 (.Reset(~KEY[0]), .clk(CLOCK_50), .Enable(Rollover10s), .Rollover(Rollover1m), .Q(hexIn1m));
HexToSevenSeg DUT1m3 (.hex(hexIn1m), .out(hexOut1m));
//HEX5
Counter_3bit DUT10m2 (.Reset(~KEY[0]), .clk(CLOCK_50), .Enable(Rollover1m), .Q(hexIn10m));
HexToSevenSeg DUT10m3 (.hex(hexIn10m), .out(hexOut10m));

always @(posedge CLOCK_50) begin
    HEX5 [7:0] <= hexOut10m;
    HEX4 [7:0] <= hexOut1m;
    HEX3 [7:0] <= hexOut10s;
    HEX2 [7:0] <= hexOut1s;
    HEX1 [7:0] <= hexOut100ms;
    HEX0 [7:0] <= hexOut10ms;
	end

endmodule