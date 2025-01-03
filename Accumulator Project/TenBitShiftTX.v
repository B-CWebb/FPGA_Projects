module TenBitShiftTX(
    input wire enable, load, clk,
    input wire [7:0] key,
    output reg out
);

reg a, b, c, d, e, f, g, h, i, j;
integer reset = 1;


always @(posedge clk) begin
    if (reset == 1) begin
        j <= 1;
        reset <= 0;
    end
    else if (load == 1) begin
        a <= 1;
        b <= key[7];
        c <= key[6];
        d <= key[5];
        e <= key[4];
        f <= key[3];
        g <= key[2];
        h <= key[1];
        i <= key[0];
        j <= 0;
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





endmodule