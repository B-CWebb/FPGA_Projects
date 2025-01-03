module Memory(
    input wire CLOCK_50,
    input wire [1:0] KEY,
    input wire [9:0] SW,
    output reg [7:0] HEX0, HEX2, HEX3,
    inout wire [35:0] GPIO,
    output reg [9:0] LEDR
);
wire enableC;
reg [3:0] HEX0out;
integer enableWrite;
reg [4:0] readAD;
wire [4:0] counterOut;
wire [3:0] RAMout;
wire [7:0] UARTout;


reg a, b, c, d;
always @(posedge CLOCK_50)begin
    a <= ~KEY[0];
    b <= a;
    c <= b;
end

//RisingEdgeDetector
always @(*)begin
    d = b & ~c;
end
always @(*) begin
    if (SW[9] == 1)begin
        readAD = counterOut;
        enableWrite = 1;
        HEX0out = UARTout[3:0];
    end
    else if (SW[9] == 0) begin
        readAD = SW[4:0];
        enableWrite = 0;
        HEX0out = RAMout;
    end
end
UARTState2 DUT1 (.CLOCK_50(CLOCK_50), .start(GPIO[0]), .RShift(RShift), .enableCounter(enableC));//, .enableWrite(enableWrite));
TenBitShift2 DUT2 (.enable(RShift), .CLOCK_50(CLOCK_50), .inBit(GPIO[0]), .out(UARTout));
MemoryCounter DUT3 (.clk(CLOCK_50), .Q(counterOut), .Reset(d), .Enable(enableC));
RAM1 DUT4 (.clock(CLOCK_50), .rden(1), .wren(enableWrite), .rdaddress(readAD), .data(UARTout[4:1]), .wraddress(counterOut), .q(RAMout));
always @(*) begin
        case(HEX0out)
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
end

always @(*) begin
        case(readAD)
            5'b00000: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b11000000;//0
            end
            5'b00001: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b11111001;//1
            end
            5'b00010: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10100100;//2
            end
            5'b00011: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10110000;//3
            end
            5'b00100: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10011001;//4
            end
            5'b00101: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10010010;//5
            end
            5'b00110: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10000010;//6
            end
            5'b00111: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b11111000;//7
            end
            5'b01000: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10000000;//8
            end
            5'b01001: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10011000;//9
            end
            5'b01010: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10001000; //a
            end
            5'b01011: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10000011; //b
            end
            5'b01100: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b11000110; //c
            end
            5'b01101: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10100001; //d
            end
            5'b01110: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10110000; //e
            end
            5'b01111: begin
                HEX3 = 8'b11000000;//0
                HEX2 = 8'b10001110; //f
            end
            5'b10000: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b11000000;//0
            end
            5'b10001: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b11111001;//1
            end
            5'b10010: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10100100;//2
            end
            5'b10011: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10110000;//3
            end
            5'b10100: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10011001;//4
            end
            5'b10101: begin
            HEX3 = 8'b11111001;//1
                HEX2 = 8'b10010010;//5
            end
            5'b10110: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10000010;//6
            end
            5'b10111: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b11111000;//7
            end
            5'b11000: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10000000;//8
            end
            5'b11001: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10011000;//9
            end
            5'b11010: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10001000; //a
            end
            5'b11011: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10000011; //b
            end
            5'b11100: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b11000110; //c
            end
            5'b11101: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10100001; //d
            end
            5'b11110: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10110000; //e
            end
            5'b11111: begin
                HEX3 = 8'b11111001;//1
                HEX2 = 8'b10001110; //f
            end
        endcase
end

always@(*)begin
  LEDR[7:0] = UARTout[7:0];
end

endmodule