/* QAM_demapper_tb.v
 * EE417 Final Project
 * Zach Martin & Saunders Riley
 * This file contains a test bench for the QAM_demapper.v source file.
 * version 1 4/19/2022 ZM
 */
 
 
module QAM_demapper_tb();
endmodule

module QAM_demapper_datapath_tb();
	reg signed [7:0] I_in, Q_in;
	reg sclk, dclk, rst, en, cal;
	
	wire [3:0] data_out;
	integer i;
	wire signed[7:0] i_internal;
	wire signed [7:0] q_internal;
	
	reg [23:0] test_input [0:15]; // two test input words I_data_Q_data
	reg [7:0] expected_dout;
	QAM_demapper_datapath UUT(.symbol_clock(sclk), .rst(rst), .I_in(I_in), .Q_in(Q_in));
	
	assign data_out = UUT.val;
	assign i_internal = UUT.I;
	assign q_internal = UUT.Q;
	
	initial begin
		rst <= 1;
		I_in <= 0;
		Q_in <= 0;
		sclk <= 0;
		dclk <= 0;
		en <= 1; 
		cal <= 0;
		#10 begin 
			rst <= 0;
			//cal <= 1;
		end
	end
	
	// Create symbol clock reference
	always
		#10 sclk = ~sclk;
	
	initial begin
		$readmemh("S:\\projects\\QAM_demapper\\demapper_test_input.txt", test_input);

		for (i=0; i<16; i=i+1)begin
			{I_in, Q_in, expected_dout} = test_input[i];
			$display("I = %d  Q = %d i_internal = %d q_internal = %d  expected = %H  out = %H", I_in, Q_in, i_internal, q_internal, expected_dout, data_out);
			#20;
		end	
	end
	
endmodule


// I_in, Q_in, sclk, dclk, rst, en, cal, data_out); 
