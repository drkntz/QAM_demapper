/* controller module. Controls hard decision demapper */
module QAM_demapper_controller(enable, reset, dclk, read, read_enable, write_enable, wfull, rdempty, available, complete, state, nextstate);
	/*	I/O Schema:
	*	*	INPUTS:
	*	*	*	enable = enables the module
	*	*	*	reset = resets the FSM and clears the FIFO
	*	*	*	dclk = digital clock (input clock from host device)
	*	*	*	read = host read signal
	*	*	*	wfull = FIFO register full flag
	*	*	*	rdempty = FIFO register empty flag
	*	*
	*	*	OUTPUTS:
	*	*	*	read_enable = enables reading from the FIFO register
	*	*	*	write_enable = enables writing to the FIFO register
	*	*	*	wclk = FIFO register write clock
	*	*	*	available = host device data available flag
	*	*	*	complete = host device complete flag
	*	State Schema:
	*	*	State 0 (2'b00): Idle - no data being written to FIFO
	*	*	State 1 (2'b01): Receive - writing data to FIFO
	*	*	State 2 (2'b10): Data Ready - FIFO is full, additional data discarded
	*	*	State 3 (2'b11): Read Out - reading data out of FIFO
	*/
	
	input enable, reset, dclk, read, wfull, rdempty;
	output reg read_enable, write_enable, available, complete;
	
	output reg[1:0] state, nextstate;
	
	initial begin
		state = 2'b00;
		nextstate = 2'b00;
	end
	
	always @ (posedge dclk) begin //Mealy Machine operates off the dclk
		state <= nextstate;
	end
	
	always @* begin //combinational logic
		case(state)
			2'b00: begin //idle state
				write_enable = 0;
				available = 0;
				complete = 1;
				
				if(enable == 1 && reset == 0) nextstate = 2'b01; //if enable goes high, transition to receive state
				else nextstate = 2'b00;
			end
			2'b01: begin //receive state
				write_enable = 1;
				read_enable = 0;
				if(enable == 0 || reset == 1) nextstate = 2'b00; //if enable goes low or reset goes high, transition to idle state
				else if(wfull == 1) begin
					nextstate = 2'b10; //if the FIFO is full, transition to data ready state
					available = 1; //raise the data available flag to the host device
					complete = 0;
				end
				else begin
					nextstate = 2'b01;
					available = 0;
					complete = 1;
				end
			end
			2'b10: begin //data ready state
				write_enable = 0; //drops data received in this state!
				read_enable = 0;
				available = 1;
				complete = 0;
				if(enable == 0 || reset == 1) nextstate = 2'b00; //if enable goes low or reset goes high, transition to idle state
				else if(read == 1) nextstate = 2'b11;
				else nextstate = 2'b10;
			end
			2'b11: begin //read out state
				write_enable = 0;
				read_enable = 1;
				if(enable == 0 || reset == 1) nextstate = 2'b00; //if enable goes low or reset goes high, transition to idle state
				else if(rdempty == 1) begin
					available = 0;
					complete = 1; //raise the transmission complete flag to the host device
					nextstate = 2'b01; //return to the receive state
				end
				else begin
					available = 1;
					complete = 0;
					nextstate = 2'b11;
				end
			end
		endcase
	end
	
endmodule
//end of file
