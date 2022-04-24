/* QAM_demapper_tb.v
 * EE417 Final Project
 * Zach Martin & Saunders Riley
 * This file contains a test bench for the QAM_demapper.v source file.
 * version 1 4/19/2022 ZM
 */
 
 
module QAM_demapper_tb();
endmodule


/* Test the hard decision demapper datapath */
module QAM_demapper_datapath_tb();
	reg signed [7:0] I_in, Q_in;	// Test input to the module
	reg [7:0] expected_dout;
	reg sclk, dclk, rst, en, cal;
	
	integer i;						// Loop index for accessing test words
	reg [23:0] test_input [0:15]; 	// two test input words I_data_Q_data
	
	QAM_demapper_datapath UUT(.symbol_clock(sclk), .rst(rst), .I_in(I_in), .Q_in(Q_in)); // instantiate module
	
	// Access internal wires
	wire [3:0] data_out;
	wire signed[7:0] i_internal;
	wire signed [7:0] q_internal;
	assign data_out = UUT.val;
	assign i_internal = UUT.I;
	assign q_internal = UUT.Q;

	
	initial begin
		rst <= 1;
		I_in <= 0;
		Q_in <= 0;
		sclk <= 1;
		dclk <= 1;
		en <= 1; 
		cal <= 0;
		#10 begin 
			rst <= 0;
			//cal <= 1;
		end
	end
	
	always
		#10 sclk = ~sclk;	// symbol clock. Would normally come from a PLL
	
	always 
		#5 dclk = ~dclk;	// internal data clock
	
	initial begin
		$readmemh("S:\\projects\\QAM_demapper\\demapper_test_input.txt", test_input);
		#20;	// Wait until reset sequence is done
		for (i=0; i<16; i=i+1)begin
			{I_in, Q_in, expected_dout} = test_input[i];
			#20 $display("I = %d  Q = %d i_internal = %d q_internal = %d  expected = %H  out = %H", I_in, Q_in, i_internal, q_internal, expected_dout, data_out);
		end	
	end
	
endmodule


// I_in, Q_in, sclk, dclk, rst, en, cal, data_out); 
