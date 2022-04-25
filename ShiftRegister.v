//4 bit shift register module
module shift_register(input[3:0] parallel_in, clock, shift_out, latch, clear, output serial_out);
	reg[3:0] int_reg;
	
	assign serial_out = int_reg[0];
	
	always @ (posedge latch, posedge clear) begin //async reset and latch
		if(clear == 1 & shift_out == 0) int_reg <= 4'd0; //if not shifting out, clear the data
		else if (shift_out == 0) int_reg <= parallel_in; //if not shifting out, latch the data
	end
	
	always @ (posedge clock) begin
		int_reg >> 1; //shift right one bit each clock cycle
	end
endmodule