module TenBitShiftRX(
    input wire enable, CLOCK_50, inBit,
    output reg [7:0] out
);

reg a, b, c, d, e, f, g, h, i, j;
integer reset = 1;

always @(posedge CLOCK_50) begin
    if (reset == 1) begin
        a <= 0;
        b <= 0;
        c <= 0;
        d <= 0;
        e <= 0;
        f <= 0;
        g <= 0;
        h <= 0;
        i <= 0;
        j <= 0;
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
end

endmodule