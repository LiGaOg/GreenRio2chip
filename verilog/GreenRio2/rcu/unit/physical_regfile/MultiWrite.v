module MultiWrite#(
	parameter REG_ADDR_WIDTH = 3,
	parameter REG_DATA_WIDTH = 4
)
(
	input wr1_valid,
	input [REG_ADDR_WIDTH - 1 : 0] wr1_address,
	input [REG_DATA_WIDTH - 1 : 0] wr1_data,
	
	input wr2_valid,
	input [REG_ADDR_WIDTH - 1 : 0] wr2_address,
	input [REG_DATA_WIDTH - 1 : 0] wr2_data,
	
	input wr3_valid,
	input [REG_ADDR_WIDTH - 1 : 0] wr3_address,
	input [REG_DATA_WIDTH - 1 : 0] wr3_data,
	
	input wr4_valid,
	input [REG_ADDR_WIDTH - 1 : 0] wr4_address,
	input [REG_DATA_WIDTH - 1 : 0] wr4_data,
	
	input wr5_valid,
	input [REG_ADDR_WIDTH - 1 : 0] wr5_address,
	input [REG_DATA_WIDTH - 1 : 0] wr5_data,
	
	input wr6_valid,
	input [REG_ADDR_WIDTH - 1 : 0] wr6_address,
	input [REG_DATA_WIDTH - 1 : 0] wr6_data,
	

	output wr_first_valid,
	output [REG_ADDR_WIDTH - 1 : 0] wr_first_address,
	output [REG_DATA_WIDTH - 1 : 0] wr_first_data,

	output wr_second_valid,
	output [REG_ADDR_WIDTH - 1 : 0] wr_second_address,
	output [REG_DATA_WIDTH - 1 : 0] wr_second_data
	
);

reg [2:0] first_num;

always @ (*) begin
	if (wr1_valid) begin
		wr_first_valid = wr1_valid;
		wr_first_address = wr1_address;
		wr_first_data = wr1_data;
		first_num = 1;
	end
	else if (wr2_valid) begin
		wr_first_valid = wr2_valid;
		wr_first_address = wr2_address;
		wr_first_data = wr2_data;
		first_num = 2;
	end
	else if (wr3_valid) begin
		wr_first_valid = wr3_valid;
		wr_first_address = wr3_address;
		wr_first_data = wr3_data;
		first_num = 3;
	end
	else if (wr4_valid) begin
		wr_first_valid = wr4_valid;
		wr_first_address = wr4_address;
		wr_first_data = wr4_data;
		first_num = 4;
	end
	else if (wr5_valid) begin
		wr_first_valid = wr5_valid;
		wr_first_address = wr5_address;
		wr_first_data = wr5_data;
		first_num = 5;
	end
	else if (wr6_valid) begin
		wr_first_valid = wr6_valid;
		wr_first_address = wr6_address;
		wr_first_data = wr6_data;
		first_num = 6;
	end
	else begin
		wr_first_valid = 0;
		wr_first_address = 0;
		wr_first_data = 0;
		first_num = 0;
	end
end


always @ (*) begin
	if (wr1_valid && first_num != 1) begin
		wr_first_valid = wr1_valid;
		wr_first_address = wr1_address;
		wr_first_data = wr1_data;
		first_num = 1;
	end
	else if (wr2_valid && first_num != 2) begin
		wr_first_valid = wr2_valid;
		wr_first_address = wr2_address;
		wr_first_data = wr2_data;
		first_num = 2;
	end
	else if (wr3_valid && first_num != 3) begin
		wr_first_valid = wr3_valid;
		wr_first_address = wr3_address;
		wr_first_data = wr3_data;
		first_num = 3;
	end
	else if (wr4_valid && first_num != 4) begin
		wr_first_valid = wr4_valid;
		wr_first_address = wr4_address;
		wr_first_data = wr4_data;
		first_num = 4;
	end
	else if (wr5_valid && first_num != 5) begin
		wr_first_valid = wr5_valid;
		wr_first_address = wr5_address;
		wr_first_data = wr5_data;
		first_num = 5;
	end
	else if (wr6_valid && first_num != 6) begin
		wr_first_valid = wr6_valid;
		wr_first_address = wr6_address;
		wr_first_data = wr6_data;
		first_num = 6;
	end
	else begin
		wr_first_valid = 0;
		wr_first_address = 0;
		wr_first_data = 0;
		first_num = 0;
	end
end
endmodule
