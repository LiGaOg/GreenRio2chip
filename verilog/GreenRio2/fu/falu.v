`include "../params.vh"
module falu(
input clk,
input rstn,
input wfi,
input trap,

input [XLEN - 1:0] opr1_i,
input [XLEN - 1:0] opr2_i,
input [XLEN - 1:0] opr3_i,
input [4:0] falu_function_select_i,  //falu_function_out要
input [2:0] falu_rounding_mode_i,
input [2:0] fcsr_frm_i,
input [1:0] falu_fmt_i,
input [ROB_INDEX_WIDTH - 1:0] rob_index_i,
input [PHY_REG_ADDR_WIDTH - 1 : 0] prd_addr_i,
input rcu_fu_falu_req_valid_i,
// no ready signal, because alu is always ready

// 1st cycle output
// output [XLEN - 1:0] add_result,
output reg fu_rcu_falu_resp_valid_o,         //done
output reg [PHY_REG_ADDR_WIDTH-1:0] prd_addr_o,
output reg [ROB_INDEX_WIDTH - 1:0] rob_index_o,
// 2nd cycle output
output reg [XLEN - 1:0] falu_result_o, 
output reg [4:0] fu_rcu_falu_fflags_o,
output reg fflags_valid_o,
output reg fu_rcu_falu_resp_float_o
);

reg [63:0] farithematic_res;
reg valid_w;
reg [XLEN - 1 : 0] falu_input_a, falu_input_b, falu_input_c;

wire [2:0] final_rounding_mode;
assign final_rounding_mode = (falu_rounding_mode_i == 3'b111) ? fcsr_frm_i : falu_rounding_mode_i;


assign extend_value = 32'h00000000;

/* fonecycle */
fonecycle fonecycle_u(
	.frs1(falu_input_a),
	.frs2(falu_input_b),
	.frs3(falu_input_c),
	.ftype(falu_function_select_i),
	.fcontrol(1'b1),
	.fmt(falu_fmt_i),
	.roundingMode(final_rounding_mode),
	.farithematic_res(farithematic_res),
	.exception_flags(fu_rcu_falu_fflags_o),
	.fflags_valid(fflags_valid_o)
);

always @(*) begin
    falu_input_a = opr1_i;
    falu_input_b = opr2_i;
    falu_input_c = opr3_i;
    //control logic wire
    valid_w = !trap & rcu_fu_falu_req_valid_i;
end

always @(*) begin
        falu_result_o = farithematic_res; 

        fu_rcu_falu_resp_valid_o = valid_w;
        prd_addr_o = prd_addr_i;
        rob_index_o = rob_index_i;
end

always @ (*) begin
	if (!valid_w) begin
		fu_rcu_falu_resp_float_o = 1'b0;		
	end
	else begin
		case(falu_function_select_i)
			FALU_FCVTWS,
			FALU_FCVTWUS,
			FALU_FCVTLS,
			FALU_FCVTLUS,
			FALU_FEQS,
			FALU_FLTS,
			FALU_FLES,
			FALU_FCLASS_S,
			FALU_FMVXW:begin
				fu_rcu_falu_resp_float_o = 1'b0;
			end
			default:begin
				fu_rcu_falu_resp_float_o = 1'b1;
			end
		endcase
	end
end

endmodule

