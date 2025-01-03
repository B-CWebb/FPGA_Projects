module MemoryCounter(
    input wire clk, Reset, Enable,
    output reg [4:0] Q
);

initial begin
    Q = 5'b00000;
end

always @(posedge Enable) begin
        if ((Q == 5'b11111) | (Reset == 1)) begin
        Q <= 5'b00000;
        end 
        else begin
            Q <= Q + 5'b00001;
        end
end

endmodule