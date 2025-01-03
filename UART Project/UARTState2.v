module UARTState2 (
    input wire CLOCK_50,
    output reg RShift
);

reg [1:0] State, next_state;

integer count;
integer enable = 0;
wire Rollover_434us;
Timer_434us DUT4 (.clk(CLOCK_50), .Rollover(Rollover_434us), .Reset(0));

//This module implements the state register and handles reset and enable.
always @(posedge CLOCK_50) begin
    State <= next_state;
end

//State transition logic
always @(*) begin
	case(State)
		2'b00 : begin 
            if (Rollover_434us == 1) begin
                next_state = 2'b01; 
            end
            else begin
                next_state = 2'b00;
            end
        end
        2'b01 : begin 
            next_state = 2'b10;
        end
        2'b10 : begin 
            if (enable == 2) begin
                next_state = 2'b11;
            end
            else begin
                next_state = 2'b10;
            end
        end
        2'b11 : begin 
            if (count < (8)) begin
                next_state = 2'b10;
            end 
            else next_state = 2'b00;
        end
        default: next_state = 2'b00;
	endcase
end

//Update Count signals.
always @(posedge CLOCK_50) begin
    case(State)
        2'b00 : count <= 0; 
        2'b01 : begin enable <= 0; 
            if (Rollover_434us == 1) enable <= enable + 1;
        end
        2'b10 : begin if (Rollover_434us == 1) enable <= enable + 1; end
        2'b11 : begin count <= count + 1; enable <= 0; end
	endcase
end

//Output decode logic
always @(*) begin
	case(State)
        2'b00 , 2'b10 : RShift = 0;
        2'b01, 2'b11 : RShift = 1;
	endcase
end

endmodule
