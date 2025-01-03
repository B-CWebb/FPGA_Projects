module PulseTrain(
    input wire CLOCK_50, 
    input wire [9:0] SW,
    output reg [9:0] LEDR
);

wire [2:0] Pulses, Sets;
assign Pulses = SW[4:2];
assign Sets = SW[7:5];


//initialize regs for 1-second timer. 
reg [2:0] State, next_state;
integer Pulse_Count, Set_Count;
reg Rollover;

initial begin
    Rollover = 0;
end

integer count = 0;
always @(posedge CLOCK_50) begin
    if (Rollover == 1) Rollover <= 0;
    if (SW[0] == 1) begin count <= 0; Rollover <= 1; end
    else if (count == 12499999) begin
        Rollover <= 1;
        count <= 0;
    end
    else count <= count + 1;
end

//This module implements the state register and handles reset and enable.
always @(posedge CLOCK_50) begin
	case ({SW[0], Rollover})
        2'b00 : State <= State;
        2'b01 : State <= next_state;
        2'b10 : State <= State;
        2'b11 : State <= 3'b000;
	endcase
end

//State transition logic
always @(*) begin
	case(State)
		3'b000 : begin 
            if (SW[9] == 1) begin
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
            if (Pulse_Count < (Pulses + 3'b001)) begin
                next_state = 3'b001;
            end 
            else next_state = 3'b011;
        end
        3'b011 : begin 
            next_state = 3'b100;
        end
        3'b100 : begin 
            if (Set_Count < (Sets + 3'b001)) begin
                next_state = 3'b001;
            end
            else next_state = 3'b000;
        end
        default: next_state = 3'b000;
	endcase
end


//Update Count signals.
always @(posedge CLOCK_50) begin
	if (Rollover == 1) begin
    case(State)
        3'b000 : begin Pulse_Count <= 0; Set_Count <= 0; end//Pulse High
        3'b001 : Pulse_Count <= Pulse_Count + 1; //Pulse Low
        3'b011 : begin Pulse_Count <= 0; Set_Count <= Set_Count + 1; end //Low 2
	endcase
    end
end

//Output decode logic
always @(*) begin
	case(State)
		3'b000, 3'b010, 3'b011, 3'b100 : LEDR[0] = 1'b0;
        3'b001 : LEDR[0] = 1'b1;
	endcase
end



endmodule