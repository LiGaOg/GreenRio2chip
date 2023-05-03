`ifndef _RV_FDECODER_V_
`define _RV_FDECODER_V_
`ifndef SYNTHESIS
`include "../params.vh"
`endif

module rv_fdecoder(
	input [31 : 0] instruction_i,
	output reg is_float_instruction_o,
	output reg [4:0] single_float_instruction_number_o,
	output reg [2:0] roundingMode,
	output reg [1:0] float_format
);

wire [4:0] funct5;
wire [1:0] fmt;
wire [4:0] rs3;
wire [4:0] rs2;
wire [4:0] rs1;
wire [2:0] rm;
wire [4:0] rd;
wire [6:0] opcode;
wire [11:0] offset;
wire [2:0] width;
wire [6:0] offset_first_part;
wire [4:0] offset_second_part;

assign funct5 = instruction_i[31 : 27];
assign fmt = instruction_i[26 : 25];
assign rs3 = instruction_i[31 : 27];
assign rs2 = instruction_i[24 : 20];
assign rs1 = instruction_i[19 : 15];
assign rm = instruction_i[14 : 12];
assign rd = instruction_i[11 : 7];
assign opcode = instruction_i[6 : 0];
assign offset = instruction_i[31 : 20];
assign width = instruction_i[14 : 12];
assign offset_first_part = instruction_i[31 : 25];
assign offset_second_part = instruction_i[11 : 7];

always @ (*) begin
	roundingMode = rm;
end

wire is_fadds;
wire is_fsubs;
wire is_fmuls;
wire is_fmins;
wire is_fmaxs;
wire is_fmadds;
wire is_fnmadds;
wire is_fmsubs;
wire is_fnmsubs;
wire is_fcvtws;
wire is_fcvtwus;
wire is_fcvtls;
wire is_fcvtlus;
wire is_fcvtsw;
wire is_fcvtswu;
wire is_fcvtsl;
wire is_fcvtslu;
wire is_fsgnjs;
wire is_fsgnjns;
wire is_fsgnjxs;
wire is_feqs;
wire is_flts;
wire is_fles;
wire is_fclass;
wire is_fmvwx;
wire is_fmvxw;
wire is_fdivs;
wire is_fsqrts;
wire is_flw;
wire is_fsw;
wire is_fcvtsd;
wire is_fcvtds;

assign is_fadds = (funct5 == 5'b00000) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fsubs = (funct5 == 5'b00001) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fmuls = (funct5 == 5'b00010) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fmins = (funct5 == 5'b00101) && (opcode == 7'b1010011) && (rm == 3'b000) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fmaxs = (funct5 == 5'b00101) && (opcode == 7'b1010011) && (rm == 3'b001) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fmadds = (opcode == 7'b1000011);
assign is_fnmadds = (opcode == 7'b1001111);
assign is_fmsubs = (opcode == 7'b1000111);
assign is_fnmsubs = (opcode == 7'b1001011);
assign is_fcvtws = (funct5 == 5'b11000) && (rs2 == 5'b00000) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fcvtwus = (funct5 == 5'b11000) && (rs2 == 5'b00001) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fcvtls = (funct5 == 5'b11000) && (rs2 == 5'b00010) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fcvtlus = (funct5 == 5'b11000) && (rs2 == 5'b00011) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fcvtsw = (funct5 == 5'b11010) && (rs2 == 5'b00000) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fcvtswu = (funct5 == 5'b11010) && (rs2 == 5'b00001) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fcvtsl = (funct5 == 5'b11010) && (rs2 == 5'b00010) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fcvtslu = (funct5 == 5'b11010) && (rs2 == 5'b00011) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fsgnjs = (funct5 == 5'b00100) && (rm == 3'b000) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fsgnjns = (funct5 == 5'b00100) && (rm == 3'b001) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fsgnjxs = (funct5 == 5'b00100) && (rm == 3'b010) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_feqs = (funct5 == 5'b10100) && (rm == 3'b010) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_flts = (funct5 == 5'b10100) && (rm == 3'b001) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fles = (funct5 == 5'b10100) && (rm == 3'b000) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fclass = (funct5 == 5'b11100) && (rs2 == 5'b00000) && (rm == 3'b001) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fmvwx = (funct5 == 5'b11110) && (rs2 == 5'b00000) && (rm == 3'b000) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fmvxw = (funct5 == 5'b11100) && (rs2 == 5'b00000) && (rm == 3'b000) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fdivs = (funct5 == 5'b00011) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fsqrts = (funct5 == 5'b01011) && (rs2 == 5'b00000) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_flw = (width == 3'b010 | width == 3'b011) && (opcode == 7'b0000111);
assign is_fsw = (width == 3'b010 | width == 3'b011) && (opcode == 7'b0100111);
assign is_fcvtsd = (funct5 == 5'b01000) && (rs2 == 5'b00001) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);
assign is_fcvtds = (funct5 == 5'b01000) && (rs2 == 5'b00000) && (opcode == 7'b1010011) && (fmt == 2'b00 | fmt == 2'b01);

always @ (*) begin
	if (is_flw | is_fsw) begin
		float_format = { width[2], width[0] };
	end
	else begin
		float_format = fmt;
	end
end


always @ (*) begin
	is_float_instruction_o = is_fadds | is_fsubs | is_fmuls | is_fmins | is_fmaxs | is_fmadds | is_fmsubs | is_fnmadds | is_fnmsubs | is_fcvtws | is_fcvtwus | is_fcvtls | is_fcvtlus | is_fcvtsw | is_fcvtswu | is_fcvtsl | is_fcvtslu | is_fsgnjs | is_fsgnjns | is_fsgnjxs | is_feqs | is_flts | is_fles | is_fclass | is_fmvwx | is_fmvxw | is_fdivs | is_fsqrts | is_flw | is_fsw | is_fcvtsd | is_fcvtds;

end

always @ (*) begin
	if (is_fadds) begin
		single_float_instruction_number_o = FALU_FADDS;
	end
	else if (is_fsubs) begin
		single_float_instruction_number_o = FALU_FSUBS;
	end
	else if (is_fmuls) begin
		single_float_instruction_number_o = FALU_FMULS;
	end
	else if (is_fmins) begin
		single_float_instruction_number_o = FALU_FMINS;
	end
	else if (is_fmaxs) begin
		single_float_instruction_number_o = FALU_FMAXS;
	end
	else if (is_fmadds) begin
		single_float_instruction_number_o = FALU_FMADDS;
	end
	else if (is_fnmadds) begin
		single_float_instruction_number_o = FALU_FNMADDS;
	end
	else if (is_fmsubs) begin
		single_float_instruction_number_o = FALU_FMSUBS;
	end
	else if (is_fnmsubs) begin
		single_float_instruction_number_o = FALU_FNMSUBS;
	end
	else if (is_fcvtws) begin
		single_float_instruction_number_o = FALU_FCVTWS;
	end
	else if (is_fcvtwus) begin
		single_float_instruction_number_o = FALU_FCVTWUS;
	end
	else if (is_fcvtls) begin
		single_float_instruction_number_o = FALU_FCVTLS;
	end
	else if (is_fcvtlus) begin
		single_float_instruction_number_o = FALU_FCVTLUS;
	end
	else if (is_fcvtsw) begin
		single_float_instruction_number_o = FALU_FCVTSW;
	end
	else if (is_fcvtswu) begin
		single_float_instruction_number_o = FALU_FCVTSWU;
	end
	else if (is_fcvtsl) begin
		single_float_instruction_number_o = FALU_FCVTSL;
	end
	else if (is_fcvtslu) begin
		single_float_instruction_number_o = FALU_FCVTSLU;
	end
	else if (is_fsgnjs) begin
		single_float_instruction_number_o = FALU_FSGNJS;
	end
	else if (is_fsgnjns) begin
		single_float_instruction_number_o = FALU_FSGNJNS;
	end
	else if (is_fsgnjxs) begin
		single_float_instruction_number_o = FALU_FSGNJXS;
	end
	else if (is_feqs) begin
		single_float_instruction_number_o = FALU_FEQS;
	end
	else if (is_flts) begin
		single_float_instruction_number_o = FALU_FLTS;
	end
	else if (is_fles) begin
		single_float_instruction_number_o = FALU_FLES;
	end
	else if (is_fclass) begin
		single_float_instruction_number_o = FALU_FCLASS_S;
	end
	else if (is_fmvwx) begin
		single_float_instruction_number_o = FALU_FMVWX;
	end
	else if (is_fmvxw) begin
		single_float_instruction_number_o = FALU_FMVXW;
	end
	else if (is_fdivs) begin
		single_float_instruction_number_o = FDIVSQRT_DIVS;
	end
	else if (is_fsqrts) begin
		single_float_instruction_number_o = FDIVSQRT_FSQRTS;
	end
	else if (is_flw) begin
		single_float_instruction_number_o = FLW;
	end
	else if (is_fsw) begin
		single_float_instruction_number_o = FSW;
	end
	else if (is_fcvtsd) begin
		single_float_instruction_number_o = FALU_FCVTSD;
	end
	else if (is_fcvtds) begin
		single_float_instruction_number_o = FALU_FCVTDS;
	end
	else begin
		single_float_instruction_number_o = 31;
	end
end

endmodule

`endif //_RV_FDECODER_V_
