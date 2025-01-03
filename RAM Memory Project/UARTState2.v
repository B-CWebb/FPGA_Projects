module UARTState2 (
    input wire CLOCK_50, start,
    output reg RShift,
    output reg enableCounter//, enableWrite
);

reg [1:0] State, next_state;
reg prevStart, prevPrevStart;

integer count;
integer pastFirst = 0;
integer enable = 0;
wire Rollover_434us;
Timer_434us DUT4 (.clk(CLOCK_50), .Rollover(Rollover_434us), .Reset(0));

//This module implements the state register and handles reset and enable.
always @(posedge CLOCK_50) begin
    State <= next_state;
    prevStart = start;
    prevPrevStart = prevStart;
end

//State transition logic
always @(*) begin
	case(State)
        3'b000 : begin 
            if (((start == 0) & (prevStart == 1)) & (prevPrevStart == 1)) begin
                next_state = 3'b001; 
            end
            else begin
                next_state = 3'b000;
            end
        end
        3'b001 : begin 
            next_state = 3'b010;
        end
        3'b010 : begin 
            if (enable == 2) begin
                next_state = 3'b011;
            end
            else begin
                next_state = 3'b010;
            end
        end
        3'b011 : begin 
            if (count < (9)) begin
                next_state = 3'b010;    
            end 
            else next_state = 3'b100;
        end
        3'b100 : begin
            if (((start == 1) & (prevStart == 1)) & (prevPrevStart == 1)) begin
                next_state = 3'b101;
            end
            else begin
                next_state = 3'b100;
            end
        end
        3'b101 : next_state = 3'b110;
        3'b110 : next_state = 3'b000;
        default: next_state = 2'b00;
	endcase
end

//Update Count signals.
always @(posedge CLOCK_50) begin
    case(State)
        3'b000 : count <= 0; 
        3'b001 : begin enable <= 0;
            pastFirst = 1;
            if (Rollover_434us == 1) enable <= enable + 1;
        end
        3'b010 : begin if (Rollover_434us == 1) enable <= enable + 1; end
        3'b011 : begin count <= count + 1; enable <= 0;  end
	endcase
end

//Output decode logic
always @(*) begin
	case(State)
        3'b000 : begin
            RShift = 0; 
            if (pastFirst == 1) begin
            enableCounter = 1;
            end
            else enableCounter = 0;
            //enableWrite = 0;
        end
        3'b010 : begin
            RShift = 0; enableCounter = 0;  //enableWrite = 1;
        end
        3'b001, 3'b011 : RShift = 1;
	endcase
end

endmodule
