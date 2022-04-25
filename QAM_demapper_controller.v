/* controller module. Controls hard decision demapper */
module QAM_demapper_controller(rst, dclk, calibrate, enable, sclk, latch_offset, latch_reg, shift);
	input rst, dclk, sclk, calibrate, enable;
	output latch_offset, latch_reg, shift;

	// TODO: FSM diagram, logic

endmodule