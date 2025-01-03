module TenBitShift2(
    input wire enable, CLOCK_50,
    output reg [7:0] out
);

reg a, b, c, d, e, f, g, h, i, j;
integer reset = 1;

always @(posedge clk) begin
    if (reset == 1) begin
        j <= 1;
        reset <= 0;
    end
    else if (enable == 1) begin
        a <= enable;
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
    out <= j;
end

always @(*) begin
    out[0] = i;
    out[1] = h;
    out[2] = g;
    out[3] = f;
    out[4] = e;
    out[5] = d;
    out[6] = c;
    out[7] = b;
end


endmodule