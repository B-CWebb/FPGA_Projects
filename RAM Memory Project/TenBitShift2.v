module TenBitShift2(
    input wire enable, CLOCK_50, inBit,
    output reg [7:0] out
    //output reg writeEnable
);

reg a, b, c, d, e, f, g, h, i, j;
integer reset = 1;

always @(posedge CLOCK_50) begin
    if (reset == 1) begin
        a <= 1;
        b <= 1;
        c <= 1;
        d <= 1;
        e <= 1;
        f <= 1;
        g <= 1;
        h <= 1;
        i <= 1;
        j <= 1;
        reset <= 0;
    end
    else if (enable == 1) begin
        a <= inBit;
        b <= a;
        c <= b;
        d <= c;
        e <= d;
        f <= e;
        g <= f;
        h <= g;
        i <= h;
        j <= i;
    end
    reset <= 0;
    out[0] <= i;
    out[1] <= h;
    out[2] <= g;
    out[3] <= f;
    out[4] <= e;
    out[5] <= d;
    out[6] <= c;
    out[7] <= b;

   // if (a != j) writeEnable = 1;
   // else writeEnable = 0;

end

endmodule