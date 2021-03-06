/* QAM_demapper.v
 * EE417 Final Project
 * Zach Martin & Saunders Riley
 * This file contains datapath-controller
 * design structure for a hard-decision 16QAM demapper aka demodulator.
 * version 1 4/19/2022
 */
 
 
/* Top-level module. Combines the datapath and controller */
module QAM_demapper(I_in, Q_in, sclk, dclk, enable, read, data_out, available, complete, reset);
	input signed [7:0] I_in, Q_in;	// Input I/Q signals, signed 8 bit number
	input sclk, dclk, enable, read, reset; 
	output [3:0]data_out; 				// parallel data out
	output available, complete;

	wire wfull, rdempty,  read_enable, write_enable;
	wire fifo_full, fifo_empty;
	wire [3:0] demapped_data;

	// Instantiate controller module
	QAM_demapper_controller U1(.enable(enable), .reset(reset), .dclk(dclk), .read(read),
							.read_enable(read_enable), .write_enable(write_enable), 
							.wfull(fifo_full), .rdempty(fifo_empty), .available(available), 
							.complete(complete));
	
	// Instantiate demapper
	QAM_demapper_datapath  U2(.rst(reset), .data_out(demapped_data), .I_in(I_in), .Q_in(Q_in), 
							.symbol_clock(sclk));
	
	// Fifo buffer
	FIFO_Register          U3 (.aclr(reset), .rdreq(read_enable), .wrreq(write_enable),
							.data(demapped_data), .q(data_out), .rdclk(dclk), .wrclk(sclk), 
							.rdempty(fifo_empty), .wrfull(fifo_full));

endmodule
//end of file
