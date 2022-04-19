/* QAM_demapper.v
 * EE417 Final Project
 * Zach Martin & Saunders Riley
 * This file contains datapath-controller
 * design structure for a hard-decision 16QAM demapper aka demodulator.
 * version 1 4/19/2022
 */
 
 
/* Top-level module. Combines the datapath and controller */
module QAM_demapper(I_in, Q_in, sclk, dclk, rst, data_out); 
	// TODO: should this be unsigned? Maybe discuss w dr E
	input signed [7:0] I_in, Q_in;	// Input I/Q signals, signed 8 bit number
	input sclk, dclk, rst;	// Signal clk, output data clk, rst
	output data_out; 			// Serial data out

	wire latch_offset; 	// Used to normalize the datapath origin at no input
	wire latch_reg; 		// Tell output SR to store demapped QAM value
	wire shift;				// Tell the output SR to shift out contents


	// Instantiate controller module
	QAM_demapper_controller U1(/*.enable(enable), .calibrate(calibrate),*/ .rst(rst), .dclk(dclk), .sclk(sclk),
									.latch_offset(latch_offset), .latch_reg(latch_reg), .shift(shift));
	// Instantiate demapper
	QAM_demapper_datapath U2(.latch_offset(latch_offset), .latch_reg(latch_reg), .shift(shift), .rst(rst), 
									.data_out(data_out), .dclk(dclk), .I_in(I_in), .Q_in(Q_in));


endmodule
 
 
/* controller module. Controls hard decision demapper */
module QAM_demapper_controller(rst, dclk, sclk, latch_offset, latch_reg, shift);
	input rst, dclk, sclk;
	output latch_offset, latch_reg, shift;

	// TODO: FSM diagram, logic


endmodule
 
 
/*datapath module, hard decision demapper */
module QAM_demapper_datapath(latch_offset, latch_reg, shift, rst, dclk, data_out, I_in, Q_in);
	input latch_offset, latch_reg, shift, rst, dclk;
	input signed [7:0] I_in, Q_in;	// Input I/Q signals, signed 8 bit number
	output data_out;
	
	// TODO: create Shift register, instantiate primitive, use primitive, setup offsets
endmodule
 
 