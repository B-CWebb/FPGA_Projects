module UARTStateTX(
    input wire CLOCK_50, button,
    output reg load, enable
);
reg [1:0] State, next_state;

integer count, Reset;
wire Rollover_868us;
Timer_868us DUT4 (.clk(CLOCK_50), .Rollover(Rollover_868us), .Reset(Reset));

//This module implements the state register and handles reset and enable.
always @(posedge CLOCK_50) begin
    State <= next_state;
end

//State transition logic
always @(*) begin
	case(State)
		2'b00 : begin 
            if (button == 1) begin
                next_state = 2'b01; 
            end
            else begin
                next_state = 2'b00;
            end
        end
        2'b01 : begin 
            next_state = 2'b10;
        end
        2'b11 : begin 
            if (count < (9)) begin
                next_state = 2'b10;
            end 
            else next_state = 2'b00;
        end
        2'b10 : begin 
            if (Rollover_868us == 1) begin 
            next_state = 2'b11;
            end
            else next_state = 2'b10;
        end
       
        default: next_state = 2'b00;
	endcase
end

//Update Count signals.
always @(posedge CLOCK_50) begin
    case(State)
        2'b00 : count = 0;
        2'b01 : Reset = 1;
        2'b10 : Reset = 0;
        2'b11 : begin count = count + 1; Reset = 0; end
	endcase
end

//Output decode logic
always @(*) begin
	case(State)
		2'b11 : begin load = 0; enable = 1; end
        2'b00 : begin load = 0; enable = 0; end
        2'b01 : begin load = 1; enable = 0; end
        2'b10 : begin load = 0; enable = 0; end
	endcase
end





endmodule