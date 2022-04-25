/*datapath module, hard decision demapper */
module QAM_demapper_datapath(rst, data_out, I_in, Q_in, symbol_clock);
	input rst, symbol_clock;
	output wire [3:0] data_out;
	input signed [7:0] I_in, Q_in;	// Input I/Q signals, signed 8 bit number
	
	reg signed [2:0] I, Q;
	
	
	// De-noise 8 bit signed value by applying symbol boundaries & normalize to +/- 1, 3 (see matlab).
	// Max Value of +127, -128, midrange approx 64
	always @(posedge symbol_clock) begin
		if(rst) begin
			I = 0;
			Q = 0;
		end
		
		else begin
			if(I_in > 64)
				I = 3;
			else if(I_in > 0)
				I = 1;
			else if(I_in > -64)
				I = -1;
			else 
				I = -3;
			
			if(Q_in > 64)
				Q = 3;
			else if(Q_in > 0)
				Q = 1;
			else if(Q_in > -64)
				Q = -1;
			else 
				Q = -3;
		end
	end 		
		
	// Demap normalized input data to Grey encoding constellation (see matlab screenshot)
	assign data_out [0] = (Q == 1)||(Q == -1) ? 1 : 0;
	assign data_out [1] = (Q < 0)  ? 1 : 0;
	assign data_out [2] = (I == 1)||(I==-1) ? 1 : 0;
	assign data_out [3] = (I < 0)  ? 0 : 1;
	
endmodule 