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
	QAM_demapper_controller U1(.enable(en), .calibrate(cal), .rst(rst), .dclk(dclk), .sclk(sclk), 
							.latch_offset(latch_offset), .latch_reg(latch_reg), .shift(shift));
	// Instantiate demapper
	QAM_demapper_datapath U2(.latch_offset(latch_offset), .latch_reg(latch_reg), .shift(shift), 
							.rst(rst), .data_out(data_out), .dclk(dclk), .I_in(I_in), .Q_in(Q_in), 
							.symbol_clock(sclk));
	
	// FIFO IP. 4 bits wide, 8 bits deep
	//fifo U3(.data(data), .rdclk(dclk), .rdreq(rdreq), .wrclk(sclk), .wrreq(wrreq), .q(data_out), 
	//					.rdempty(rdempty), .wrfull(wrfull));
	
endmodule
 
 
/* controller module. Controls hard decision demapper */
module QAM_demapper_controller(rst, dclk, calibrate, enable, sclk, latch_offset, latch_reg, shift);
	input rst, dclk, sclk, calibrate, enable;
	output latch_offset, latch_reg, shift;

	// TODO: FSM diagram, logic

endmodule
 
 
/*datapath module, hard decision demapper */
module QAM_demapper_datapath(latch_offset, latch_reg, shift, rst, dclk, data_out, I_in, Q_in, symbol_clock);
	input latch_offset;				// Calibrate input to the origin
	input latch_reg;				// Store demapped symbol in shift register
	input shift;					// Shift out data
	input rst, dclk, symbol_clock;	// input signal is at a different clock rate than output dclk
	input signed [7:0] I_in, Q_in;	// Input I/Q signals, signed 8 bit number
	output reg data_out;			// Serial output
	
	reg signed [2:0] I, Q;			// Normalized I/Q Signals
	reg [3:0] output_register;		
	reg [3:0] input_register;	
	reg signed [7:0] I_offset, Q_offset;
	
	wire [3:0] val;

	// De-noise 8 bit signed value by applying symbol boundaries & normalize to +/- 1, 3 (see matlab).
	// Max Value of +127, -128, midrange approx 64
	always @(posedge symbol_clock) begin
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
		
	// Demap normalized input data to Grey encoding constellation (see matlab screenshot)
	assign val [0] = (Q == 1)||(Q == -1) ? 1 : 0;
	assign val [1] = (Q < 0)  ? 1 : 0;
	assign val [2] = (I == 1)||(I==-1) ? 1 : 0;
	assign val [3] = (I < 0)  ? 0 : 1;
	
	
	// output shift register using output data clock dclk
	always @(posedge dclk)
		if(rst) begin
			output_register <= 0;
			data_out <= 0;
		end 
		
		else if(shift) begin
			output_register <= output_register >> 1;
			data_out <= output_register[0];
		end
		
		else 
			output_register <= input_register;
	
	// Asynchronous latching of input via controller
	always @* 
		if(latch_reg)
			input_register <= val;


	// TODO: create Shift register, instantiate primitive, use primitive, setup offsets
endmodule














 