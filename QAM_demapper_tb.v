/* QAM_demapper_tb.v
 * EE417 Final Project
 * Zach Martin & Saunders Riley
 * This file contains a test bench for the QAM_demapper.v source file.
 * version 1 4/19/2022
 */
 
 
// Test top level module
/* Testing scheme: 
 Enter a series of inputs to the system and checking that the system outputs the expected values*/

module QAM_demapper_tb();
	/*
	reg signed [7:0] I_in, Q_in;
	reg sclk, dclk, rst, en, cal;
	reg [7:0] data_out;
	
	reg [15:0] test_input [0:16]; // two test input words I_data_Q_data
	
	//QAM_demampper UUT(I_in, Q_in, sclk, dclk, rst, en, cal, data_out);
	
	initial begin
		$readmemb("demapper_test_input.txt", test_input); // TODO: populate input data with correct values
		rst <= 1;
		I_in <= 0;
		Q_in <= 0;
		sclk <= 0;
		dclk <= 0;
		en <= 1; 
		cal <= 0;
		#10 begin 
				rst <= 0;
				cal <= 1;
			end
		#10 I_in = 
		
	end
	*/
endmodule


// I_in, Q_in, sclk, dclk, rst, en, cal, data_out); 
