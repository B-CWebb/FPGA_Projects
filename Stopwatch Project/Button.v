module Button(
    input wire in, CLOCK_50,
    output reg out
);

//Synchronization chain
reg a, b, c, d;
always @(posedge CLOCK_50)begin
    a <= in;
    b <= a;
    c <= b;
end

//RisingEdgeDetector
always @(*)begin
    d = b & ~c;
end

//itialize key0 to set our T-flipflpo to have an initial value
reg key0;
initial begin
    key0 = 0;
end

//have our key0 value change from 0 to 1 after two clock cycles.
integer count = 0;
always @(posedge CLOCK_50)begin
    if (count < 2) begin
    count <= count + 1;
    end
    else begin
        key0 = 1;
    end
end

//T-flipflop
always @ (posedge CLOCK_50) begin
    if (!key0)
        out <= 0;
    else
        if (d)
            out <= ~out;
        else
            out <= out;
end

endmodule