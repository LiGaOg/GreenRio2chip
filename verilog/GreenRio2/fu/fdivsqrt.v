//
// RISu64
// Copyright 2022 Wenting Zhang
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//`include "../params.vh"

module fdivsqrt(
    input  wire         clk,
    input  wire         rst,
    input  wire         trap,
    // To Issue
    input  wire [PHY_REG_ADDR_WIDTH-1:0]    fu_fdivsqrt_prd_addr_i,      //  v 1
    input  wire [63:0]                      fu_fdivsqrt_oprd1_i, //  v 1
    input  wire [63:0]                      fu_fdivsqrt_oprd2_i, //  v 1
    input  wire [ROB_INDEX_WIDTH-1 : 0]     fu_fdivsqrt_rob_index_i,
    input  wire [4:0]                       fu_fdivsqrt_func_sel_i,    //  v 1
    input  wire                             fu_fdivsqrt_divsqrt_i,
    input  wire [2:0]                       fu_fdivsqrt_rounding_mode_i,    //  v 1
    input  wire [2:0]			    fu_fdivsqrt_fcsr_frm_i,
    input  wire [1:0]                       fu_fdivsqrt_fmt_i,    //  v 1
    input  wire                             fu_fdivsqrt_req_valid_i,    //  v 1
    output wire                             fu_fdivsqrt_req_ready_o,    //  v 1
    // Hazard detection  for issue to detect hazard
    // To writeback
    output wire [PHY_REG_ADDR_WIDTH-1:0]    fdivsqrt_fu_wrb_prd_addr_o,
    output wire [ROB_INDEX_WIDTH-1 : 0]     fdivsqrt_fu_wrb_rob_index_o,
    output wire [XLEN - 1:0]                fdivsqrt_fu_wrb_data_o,   //  v  1
    output wire                             fdivsqrt_fu_wrb_resp_valid_o,    //  v  1
    output wire 			    fu_rcu_fdivsqrt_fflags_vld_o,
    output wire [4:0] 			    fu_rcu_fdivsqrt_fflags_o
//    input  wire         md_wb_ready,    //  v  1   always ready
    // Pipeline flush
);

    wire req_unit = fu_fdivsqrt_divsqrt_i;
    wire req_fmt = fu_fdivsqrt_fmt_i;
    wire fdivsqrt_fu_resp_valid_w;
    reg active_unit;
    reg active_fmt;
    reg active;
    reg [PHY_REG_ADDR_WIDTH - 1: 0] prd_addr;
    reg [ROB_INDEX_WIDTH - 1 : 0] rob_index;
    reg [5:0] dst;
    reg [4:0] div_exception_flags;
    reg [4:0] sqrt_exception_flags;
    reg [4:0] div_exception_flags_s;
    reg [4:0] sqrt_exception_flags_s;
    reg [4:0] div_exception_flags_d;
    reg [4:0] sqrt_exception_flags_d;

    wire div_req_ready;
    wire div_req_ready_s;
    wire div_req_ready_d;
    wire div_resp_valid;
    wire div_resp_valid_s;
    wire div_resp_valid_d;
    wire [63:0] div_resp_result;
    wire [31:0] div_resp_result_s;
    wire [63:0] div_resp_result_d;
    wire [2:0] final_rounding_mode;
    assign final_rounding_mode = (fu_fdivsqrt_rounding_mode_i == 3'b111) ? fu_fdivsqrt_fcsr_frm_i : fu_fdivsqrt_rounding_mode_i;

    fdsq fdsq_div_u(
	    .clk(clk),
	    .rst(rst | trap),
	    .frs1(fu_fdivsqrt_oprd1_i[31:0]),
	    .frs2(fu_fdivsqrt_oprd2_i[31:0]),
	    .ftype(1'b0),
	    .fcontrol(1'b1),
	    .roundingMode(final_rounding_mode),
	    .valid_in(fu_fdivsqrt_req_valid_i && fu_fdivsqrt_divsqrt_i == 1'b0 && !trap && !active),
	    .ready_out(div_req_ready_s),
	    .finish(div_resp_valid_s),
	    .farithematic_res(div_resp_result_s),
	    .exception_flags(div_exception_flags_s)
    );
    fddsq fddsq_div_u(
	    .clk(clk),
	    .rst(rst | trap),
	    .frs1(fu_fdivsqrt_oprd1_i),
	    .frs2(fu_fdivsqrt_oprd2_i),
	    .ftype(1'b0),
	    .fcontrol(1'b1),
	    .roundingMode(final_rounding_mode),
	    .valid_in(fu_fdivsqrt_req_valid_i && fu_fdivsqrt_divsqrt_i == 1'b0 && !trap && !active),
	    .ready_out(div_req_ready_d),
	    .finish(div_resp_valid_d),
	    .farithematic_res(div_resp_result_d),
	    .exception_flags(div_exception_flags_d)
    );

    assign div_req_ready = (active_fmt == 2'b00) ? div_req_ready_s : div_req_ready_d;
    assign div_resp_valid = (active_fmt == 2'b00) ? div_resp_valid_s : div_resp_valid_d;
    assign div_resp_result = (active_fmt == 2'b00) ? {32'b0, div_resp_result_s} : div_resp_result_d;
    assign div_exception_flags = (active_fmt == 2'b00) ? div_exception_flags_s : div_exception_flags_d;

    wire sqrt_req_ready;
    wire sqrt_req_ready_s;
    wire sqrt_req_ready_d;
    wire sqrt_resp_valid;
    wire sqrt_resp_valid_s;
    wire sqrt_resp_valid_d;
    wire [63:0] sqrt_resp_result;
    wire [31:0] sqrt_resp_result_s;
    wire [63:0] sqrt_resp_result_d;
    fdsq fdsq_sqrt_u(
	    .clk(clk),
	    .rst(rst | trap),
	    .frs1(fu_fdivsqrt_oprd1_i[31:0]),
	    .frs2(fu_fdivsqrt_oprd2_i[31:0]),
	    .ftype(1'b1),
	    .fcontrol(1'b1),
	    .roundingMode(final_rounding_mode),
	    .valid_in(fu_fdivsqrt_req_valid_i && fu_fdivsqrt_divsqrt_i == 1'b1 && !trap && !active),
	    .ready_out(sqrt_req_ready_s),
	    .finish(sqrt_resp_valid_s),
	    .farithematic_res(sqrt_resp_result_s),
	    .exception_flags(sqrt_exception_flags_s)
    );
    fddsq fddsq_sqrt_u(
	    .clk(clk),
	    .rst(rst | trap),
	    .frs1(fu_fdivsqrt_oprd1_i),
	    .frs2(fu_fdivsqrt_oprd2_i),
	    .ftype(1'b1),
	    .fcontrol(1'b1),
	    .roundingMode(final_rounding_mode),
	    .valid_in(fu_fdivsqrt_req_valid_i && fu_fdivsqrt_divsqrt_i == 1'b1 && !trap && !active),
	    .ready_out(sqrt_req_ready_d),
	    .finish(sqrt_resp_valid_d),
	    .farithematic_res(sqrt_resp_result_d),
	    .exception_flags(sqrt_exception_flags_d)
    );

    assign sqrt_req_ready = (active_fmt == 2'b00) ? sqrt_req_ready_s : sqrt_req_ready_d;
    assign sqrt_resp_valid = (active_fmt == 2'b00) ? sqrt_resp_valid_s : sqrt_resp_valid_d;
    assign sqrt_resp_result = (active_fmt == 2'b00) ? {32'b0, sqrt_resp_result_s} : sqrt_resp_result_d;
    assign sqrt_exception_flags = (active_fmt == 2'b00) ? sqrt_exception_flags_s : sqrt_exception_flags_d;
    assign fu_fdivsqrt_req_ready_o = !active;

    assign fdivsqrt_fu_wrb_data_o = (active_unit == 1'b0) ?
            (div_resp_result) : (sqrt_resp_result);
    assign fdivsqrt_fu_wrb_prd_addr_o = prd_addr;
    assign fdivsqrt_fu_wrb_rob_index_o = rob_index;
    assign fdivsqrt_fu_resp_valid_w = (active_unit == 1'b0) ?
            (div_resp_valid) : (sqrt_resp_valid);
    assign fdivsqrt_fu_wrb_resp_valid_o = fdivsqrt_fu_resp_valid_w && !trap;
    assign fu_rcu_fdivsqrt_fflags_vld_o = fdivsqrt_fu_resp_valid_w && !trap;
    assign fu_rcu_fdivsqrt_fflags_o = (active_unit == 1'b0) ? (div_exception_flags) : (sqrt_exception_flags);
    // Abortion is only valid the 0th and 1st cycle it started.

    always @(posedge clk) begin
        if (rst | trap) begin
            active <= 0;
        end else if (!active) begin
            if (fu_fdivsqrt_req_valid_i && fu_fdivsqrt_req_ready_o && !trap) begin
                active <= 1'b1;
                // Only speculated instructions can be cancelle
                active_unit <= req_unit;
		active_fmt <= req_fmt;
                prd_addr <= fu_fdivsqrt_prd_addr_i;
                rob_index <= fu_fdivsqrt_rob_index_i;
            end
        end else if (div_req_ready & sqrt_req_ready) begin
            active <= 1'b0;
        end
    end

endmodule

