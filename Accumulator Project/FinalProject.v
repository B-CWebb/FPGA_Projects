module FinalProject(
    input wire CLOCK_50, 
    input wire [1:0] KEY,
    input [9:0] SW,
    inout wire [35:0] GPIO,
    output reg [9:0] LEDR,
    output reg [7:0] HEX0, HEX1, HEX5
);

wire load, enable, out1, RShift, TXEnable, trigger, accEnable;
wire [7:0] RXOut, accOut;
reg [3:0] ASCIIOut;
assign GPIO[1] = out1;
reg a, b, c, ASCIIEnable, enable2, prevEnable;

always @(posedge CLOCK_50) begin
    a <= ~KEY[1];
    b <= a;
    c <= b;
end

assign trigger = c & (!b);

UARTStateRX DUT3 (.CLOCK_50(CLOCK_50), .start(GPIO[0]), .RShift(RShift), .accEnable(accEnable));
TenBitShiftRX DUT4 (.enable(RShift), .CLOCK_50(CLOCK_50), .inBit(GPIO[0]), .out(RXOut));

always @(posedge CLOCK_50) begin
    if (((prevEnable == 1) && (accEnable == 0))) begin
        enable2 <= 1;
    end
    else enable2 <= 0;
    prevEnable <= accEnable;
end

always@(posedge CLOCK_50) begin 
    if ((RXOut[7:4] == 4'b0011) && (enable2 == 1)) begin
        ASCIIEnable <= 1;
        ASCIIOut <= RXOut[3:0];
    end
    else begin
        ASCIIEnable <= 0;
    end
end

Accumulator DUT5 (.CLOCK_50(CLOCK_50), .Reset(trigger), .D(ASCIIOut), .Q(accOut), .ASCIIEnable(ASCIIEnable), .TXEnable(TXEnable)); //Input from TenBitShiftRX, Output to TenBitShiftTX
UARTStateTX DUT1 (.CLOCK_50(CLOCK_50), .button(ASCIIEnable), .enable(enable), .load(load));
TenBitShiftTX DUT2 (.clk(CLOCK_50), .key(accOut), .enable(enable), .load(load), .out(out1));

always @(*) begin
    case(accOut[3:0])
        4'h0: HEX0 = 8'b11000000;
        4'h1: HEX0 = 8'b11111001;
        4'h2: HEX0 = 8'b10100100;
        4'h3: HEX0 = 8'b10110000;
        4'h4: HEX0 = 8'b10011001;
        4'h5: HEX0 = 8'b10010010;
        4'h6: HEX0 = 8'b10000010;
        4'h7: HEX0 = 8'b11111000;
        4'h8: HEX0 = 8'b10000000;
        4'h9: HEX0 = 8'b10011000;
        4'ha: HEX0 = 8'b10001000; //a
        4'hb: HEX0 = 8'b10000011; //b
        4'hc: HEX0 = 8'b11000110; //c
        4'hd: HEX0 = 8'b10100001; //d
        4'he: HEX0 = 8'b10000110; //e
        4'hf: HEX0 = 8'b10001110; //f
    endcase
    case(accOut[7:4])
        4'h0: HEX1 = 8'b11000000;
        4'h1: HEX1 = 8'b11111001;
        4'h2: HEX1 = 8'b10100100;
        4'h3: HEX1 = 8'b10110000;
        4'h4: HEX1 = 8'b10011001;
        4'h5: HEX1 = 8'b10010010;
        4'h6: HEX1 = 8'b10000010;
        4'h7: HEX1 = 8'b11111000;
        4'h8: HEX1 = 8'b10000000;
        4'h9: HEX1 = 8'b10011000;
        4'ha: HEX1 = 8'b10001000; //a
        4'hb: HEX1 = 8'b10000011; //b
        4'hc: HEX1 = 8'b11000110; //c
        4'hd: HEX1 = 8'b10100001; //d
        4'he: HEX1 = 8'b10000110; //e
        4'hf: HEX1 = 8'b10001110; //f
    endcase
    case(ASCIIOut[3:0])
        4'h0: HEX5 = 8'b11000000;
        4'h1: HEX5 = 8'b11111001;
        4'h2: HEX5 = 8'b10100100;
        4'h3: HEX5 = 8'b10110000;
        4'h4: HEX5 = 8'b10011001;
        4'h5: HEX5 = 8'b10010010;
        4'h6: HEX5 = 8'b10000010;
        4'h7: HEX5 = 8'b11111000;
        4'h8: HEX5 = 8'b10000000;
        4'h9: HEX5 = 8'b10011000;
        4'ha: HEX5 = 8'b10001000; //a
        4'hb: HEX5 = 8'b10000011; //b
        4'hc: HEX5 = 8'b11000110; //c
        4'hd: HEX5 = 8'b10100001; //d
        4'he: HEX5 = 8'b10000110; //e
        4'hf: HEX5 = 8'b10001110; //f
    endcase
end

//for debugging purposes, shows full 8 bit value of data received on RX to LEDR
always@(*)begin
  LEDR[7:0] = RXOut[7:0];
end

endmodule