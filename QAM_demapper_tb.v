/* QAM_demapper_tb.v
 * EE417 Final Project
 * Zach Martin & Saunders Riley
 * This file contains a test bench for the QAM_demapper.v source file.
 * version 1 4/19/2022 ZM
 */
 
/* Test top level module of the design */
module QAM_demapper_tb();	// Test top level module
	
	// Declare I/O to be used in top level module
	reg signed [7:0] I_in, Q_in;
	reg [3:0] expected_dout;
	reg sclk, dclk, enable, read, reset;
	wire [3:0] data_out;
	wire available, complete;
	integer i;						// Loop index for accessing Matlab generated file
	reg [23:0] test_input [0:99]; 	// two test input words I_data_Q_data
	wire rst_internal; 				// View internal wire 
	wire [1:0] state_internal;
	
	QAM_demapper UUT1(I_in, Q_in, sclk, dclk, enable, read, data_out, available, complete, reset);
	
	assign rst_internal = UUT1.reset;
	assign state_internal = UUT1.U1.state;
	
	initial begin	// Set all registers at start
		I_in = 0;
		Q_in = 0;
		sclk = 1;
		dclk = 1;
		enable = 1; 
		read = 0;
		reset = 1;
		#10 reset = 0;
		#200 read = 1;
	end
	
	// Begin clock. dclk is 4x sclk. 
	always 
		#5 sclk = ~sclk;
	
	always 
		#20 dclk = ~dclk;
	
	initial begin
		$readmemh("S:\\projects\\QAM_demapper\\matlab_test_data.txt", test_input);
		#10;
		for (i=0; i<100; i=i+1)begin
			{I_in, Q_in, expected_dout} = test_input[i];			
			
			#20 begin //$display("I = %d  Q = %d i_internal = %d q_internal = %d  expected = %H  out = %H", I_in, Q_in, i_internal, q_internal, expected_dout, data_out);
			if(data_out != expected_dout)
				$display("ERROR detected at i = %d, q = %d, expected = %H, output = %H", I_in, Q_in, expected_dout, data_out);
			end
		end	
	end
	
endmodule


/* datapath test bench */
module QAM_demapper_datapath_tb();
	reg signed [7:0] I_in, Q_in;
	reg sclk,rst;
	
	wire [3:0] data_out;
	integer i;
	wire signed[7:0] i_internal;
	wire signed [7:0] q_internal;
	
	reg [23:0] test_input [0:99]; // two test input words I_data_Q_data
	reg [7:0] expected_dout;
	QAM_demapper_datapath UUT(.symbol_clock(sclk), .rst(rst), .I_in(I_in), .Q_in(Q_in), .data_out(data_out));
	
	assign i_internal = UUT.I;
	assign q_internal = UUT.Q;
	
	initial begin
		rst <= 1;
		I_in <= 0;
		Q_in <= 0;
		sclk <= 1;
		#10 begin 
			rst <= 0;
		end
	end
	
	// Create symbol clock reference
	always
		#10 sclk = ~sclk;
	
	initial begin
		$readmemh("S:\\projects\\QAM_demapper\\matlab_test_data.txt", test_input);
		#20;
		for (i=0; i<100; i=i+1)begin
			{I_in, Q_in, expected_dout} = test_input[i];
			
			#20 begin //$display("I = %d  Q = %d i_internal = %d q_internal = %d  expected = %H  out = %H", I_in, Q_in, i_internal, q_internal, expected_dout, data_out);
			if(data_out != expected_dout)
				$display("ERROR detected at i = %d, q = %d, expected = %H, output = %H", I_in, Q_in, expected_dout, data_out);
			end
		end	
	end
	
endmodule