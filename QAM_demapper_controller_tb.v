/*Testbench for QAM Demapper Controller*/

`timescale 1ps/1ps

//this declaration format is needed by the Intel Questa simulator
module QAM_demapper_controller_tb(enable, reset, sclk, dclk, read_enable, wfull, rdempty, wclk, rdclk, available, complete, state, nextstate);
	output reg enable, reset, sclk, dclk, read_enable, wfull, rdempty;
	output wire wclk, rdclk, available, complete;
	output wire[1:0] state, nextstate;
	
	QAM_demapper_controller DUT(enable, reset, sclk, dclk, read_enable, wfull, rdempty, wclk, rdclk, aclr, available, complete, state, nextstate);
	
	initial begin
		enable = 1;
		reset = 1;
		sclk = 0;
		dclk = 0;
		read_enable = 0;
		wfull = 0;
		rdempty = 0;
	end
	
	initial fork
		#15 reset = 0;
		#320 wfull = 1;
		#340 read_enable = 1;
		#360 wfull = 0;
		#500 rdempty = 1;
	join
	
	always begin
		#10 dclk = ~dclk;
	end
	
	always begin
		#40 sclk = ~sclk;
	end
endmodule
//end of file