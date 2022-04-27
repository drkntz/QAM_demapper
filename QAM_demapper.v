/* QAM_demapper.v
 * EE417 Final Project
 * Zach Martin & Saunders Riley
 * This file contains datapath-controller
 * design structure for a hard-decision 16QAM demapper aka demodulator.
 * version 1 4/19/2022
 */
 
 
/* Top-level module. Combines the datapath and controller */
module QAM_demapper(I_in, Q_in, sclk, dclk, rst, en, cal, data_out); 
	// TODO: should this be unsigned? Maybe discuss w dr E
	input signed [7:0] I_in, Q_in;	// Input I/Q signals, signed 8 bit number
	input sclk, dclk, rst, en, cal; // Signal clk, output data clk, rst
	output data_out; 				// Serial data out

	wire latch_offset; 	// Used to normalize the datapath origin at no input
	wire latch_reg; 	// Tell output SR to store demapped QAM value
	wire shift;			// Tell the output SR to shift out contents

	// Instantiate controller module
	QAM_demapper_controller U1(.enable(en), .reset(rst), .dclk(dclk), .sclk(sclk), 
							.read_enable(shift));
	// Instantiate demapper
	QAM_demapper_datapath U2(.rst(rst), .data_out(data_out), .I_in(I_in), .Q_in(Q_in), .symbol_clock(sclk));

endmodule
//end of file