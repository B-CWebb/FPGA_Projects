module Timer_434us(
    input wire clk, Reset,
    output reg Rollover
);

initial begin
    Rollover = 0;
end
integer count = 0;
always @(posedge clk) begin
    if (Rollover == 1) Rollover <= 0;
    if (Reset == 1) count <= 0;
    else if (count == 210) begin
        Rollover <= 1;
        count <= 0;
    end
    else count <= count + 1;
end

endmodule