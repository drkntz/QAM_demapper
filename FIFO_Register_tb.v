module FIFO_tb();
	reg dclk, sclk, read_enable, write_enable, reset;
	reg[3:0] data_in;
	wire[3:0] data_out;
	wire rdempty, wrfull;
	
	FIFO_Register   DUT (.aclr(reset), .rdreq(read_enable), .wrreq(write_enable),
							.data(data_in), .q(data_out), .rdclk(dclk), .wrclk(sclk), 
							.rdempty(rdempty), .wrfull(wrfull));
							
	initial begin
		dclk = 0;
		sclk = 0;
		read_enable = 1;
		write_enable = 1;
		reset = 1;
		data_in = 4'd0;
	end
	
	initial fork
		#15 reset = ~reset;
	join
	
	always begin
		#10 dclk = ~dclk;
	end
	
	always begin
		#20 sclk = ~sclk;
	end
	
	always begin
		#20 data_in = data_in + 1;
	end
	
endmodule
//end of file