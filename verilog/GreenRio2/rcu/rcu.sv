`ifndef _RCU_V_
`define _RCU_V_
`ifndef SYNTHESIS
`include "../params.vh"
`endif // SYNTHESIS
module rcu(
    input clk                                                   ,
    input rst                                                   ,
    //global ctrl
    input global_wfi_i                                          ,
    input global_trap_i                                         ,
    input global_ret_i                                          ,
    //hand shake with decode
    input deco_rob_req_valid_first_i                            ,
    input deco_rob_req_valid_second_i                           ,
    output deco_rob_req_ready_first_o                           ,
    output deco_rob_req_ready_second_o                          ,
    //from decode
    input uses_rs1_first_i                                      ,
    input uses_rs1_second_i                                     ,
    input uses_rs2_first_i                                      ,
    input uses_rs2_second_i                                     ,
    input uses_rs3_first_i					,
    input uses_rs3_second_i					,
    input uses_rd_first_i                                       ,
    input uses_rd_second_i                                      ,
    input uses_csr_first_i                                      ,
    input uses_csr_second_i                                     ,
    input [PC_WIDTH-1:0] pc_first_i                             ,
    input [PC_WIDTH-1:0] pc_second_i                            ,
    input [PC_WIDTH-1:0] next_pc_first_i                        ,
    input [PC_WIDTH-1:0] next_pc_second_i                       ,
    input [PC_WIDTH-1:0] predict_pc_first_i                     ,
    input [PC_WIDTH-1:0] predict_pc_second_i                    ,
    input [5:0] rs1_address_first_i                             ,
    input [5:0] rs1_address_second_i                            ,
    input [5:0] rs2_address_first_i                             ,
    input [5:0] rs2_address_second_i                            ,
    input [5:0] rs3_address_first_i                             ,
    input [5:0] rs3_address_second_i                            ,
    input [5:0] rd_address_first_i                              ,
    input [5:0] rd_address_second_i                             ,
    input [11:0] csr_address_first_i                            ,
    input [11:0] csr_address_second_i                           ,
    input mret_first_i                                          ,
    input mret_second_i                                         ,
    input sret_first_i                                          ,
    input sret_second_i                                         ,
    input wfi_first_i                                           ,
    input wfi_second_i                                          ,
    input [EXCEPTION_CAUSE_WIDTH-1:0] ecause_first_i            ,
    input [EXCEPTION_CAUSE_WIDTH-1:0] ecause_second_i           ,
    input exception_first_i                                     ,
    input exception_second_i                                    ,
    input half_first_i                                          ,
    input half_second_i                                         ,
    input is_fence_first_i                                      ,
    input is_fence_second_i                                     ,
    input [1:0] fence_op_first_i                                ,
    input [1:0] fence_op_second_i                               ,
    input is_aext_first_i                                       ,
    input is_aext_second_i                                      ,
    input is_mext_first_i                                       ,
    input is_mext_second_i                                      ,
    input is_fdivsqrt_first_i					,
    input is_fdivsqrt_second_i					,
    input csr_read_first_i                                      ,
    input csr_read_second_i                                     ,
    input csr_write_first_i                                     ,
    input csr_write_second_i                                    ,
    input [31:0] imm_data_first_i                               ,
    input [31:0] imm_data_second_i                              ,
    input [2:0] fu_function_first_i                             ,
    input [2:0] fu_function_second_i                            ,
    input [4:0] fu_float_function_first_i			,
    input [4:0] fu_float_function_second_i			,
    input [2:0] fu_float_rounding_mode_first_i			,
    input [2:0] fu_float_rounding_mode_second_i			,
    input [1:0] fu_float_fmt_first_i				,
    input [1:0] fu_float_fmt_second_i				,
    input alu_function_modifier_first_i                         ,
    input alu_function_modifier_second_i                        ,
    input [1:0] fu_select_a_first_i                             ,
    input [1:0] fu_select_a_second_i                            ,
    input [1:0] fu_select_b_first_i                             ,
    input [1:0] fu_select_b_second_i                            ,
    input [1:0] fu_select_c_first_i                             ,
    input [1:0] fu_select_c_second_i                            ,
    input jump_first_i                                          ,
    input jump_second_i                                         ,
    input branch_first_i                                        ,
    input branch_second_i                                       ,
    input is_alu_first_i                                        ,
    input is_alu_second_i                                       ,
    input is_float_first_i					,
    input is_float_second_i					,
    input is_falu_first_i					,
    input is_falu_second_i					,
    input load_first_i                                          ,
    input load_second_i                                         ,
    input store_first_i                                         ,
    input store_second_i                                        ,
    input [LDU_OP_WIDTH-1:0] ldu_op_first_i                     ,
    input [LDU_OP_WIDTH-1:0] ldu_op_second_i                    ,
    input [STU_OP_WIDTH-1:0] stu_op_first_i                     ,
    input [STU_OP_WIDTH-1:0] stu_op_second_i                    ,
    input aq_first_i                                            ,
    input aq_second_i                                           ,
    input rl_first_i                                            ,
    input rl_second_i                                           ,
    //from fu
    input func_alu1_done_valid_i                                ,
    input func_alu2_done_valid_i                                ,
    input func_falu1_done_valid_i                                ,
    input func_falu1_done_float_i				,
    input func_falu2_done_valid_i                                ,
    input func_falu2_done_float_i				,
    input func_lsu_done_valid_i                                 ,
    input func_lsu_done_float_i                                 ,
    input func_md_done_valid_i                                  ,
    input func_fdivsqrt_done_valid_i                                  ,
    input func_csru_done_valid_i                                ,
    input [PHY_REG_ADDR_WIDTH-1:0] physical_alu1_wrb_addr_i     , 
    input [PHY_REG_ADDR_WIDTH-1:0] physical_csru_wrb_addr_i     , //FIXME 
    input [PHY_REG_ADDR_WIDTH-1:0] physical_alu2_wrb_addr_i     , 
    input [PHY_REG_ADDR_WIDTH-1:0] physical_falu1_wrb_addr_i     , 
    input [PHY_REG_ADDR_WIDTH-1:0] physical_falu2_wrb_addr_i     , 
    input [PHY_REG_ADDR_WIDTH-1:0] physical_lsu_wrb_addr_i      , 
    input [PHY_REG_ADDR_WIDTH-1:0] physical_md_wrb_addr_i       ,
    input [PHY_REG_ADDR_WIDTH-1:0] physical_fdivsqrt_wrb_addr_i       ,
    input alu1_predict_miss_i                                   ,
    input alu1_branch_taken_i                                   ,
    input [PC_WIDTH-1:0] alu1_final_branch_pc_i                 ,
    input alu2_predict_miss_i                                   ,
    input alu2_branch_taken_i                                   ,
    input [PC_WIDTH-1:0] alu2_final_branch_pc_i                 ,
    input [ROB_INDEX_WIDTH-1:0] func_alu1_rob_index_i           ,
    input [ROB_INDEX_WIDTH-1:0] func_alu2_rob_index_i           ,
    input [ROB_INDEX_WIDTH-1:0] func_falu1_rob_index_i           ,
    input [ROB_INDEX_WIDTH-1:0] func_falu2_rob_index_i           ,
    input [ROB_INDEX_WIDTH-1:0] func_lsu_rob_index_i            ,
    input [ROB_INDEX_WIDTH-1:0] func_md_rob_index_i             ,
    input [ROB_INDEX_WIDTH-1:0] func_fdivsqrt_rob_index_i             ,
    input [ROB_INDEX_WIDTH-1:0] func_csru_rob_index_i           ,
    input [XLEN-1:0] physical_alu1_wrb_data_i                   , 
    input [XLEN-1:0] physical_csru_wrb_data_i                   , 
    input [XLEN-1:0] physical_alu2_wrb_data_i                   , 
    input [XLEN-1:0] physical_falu1_wrb_data_i                   , 
    input [XLEN-1:0] physical_falu2_wrb_data_i                   , 
    input [XLEN-1:0] physical_lsu_wrb_data_i                    , 
    input [XLEN-1:0] physical_md_wrb_data_i                     ,
    input [XLEN-1:0] physical_fdivsqrt_wrb_data_i                     ,
    input func_wrb_alu1_exp_i                                   ,
    input func_wrb_alu2_exp_i                                   ,
    input func_wrb_falu1_exp_i                                   ,
    input func_wrb_falu2_exp_i                                   ,
    input func_wrb_lsu_exp_i                                    ,
    input func_wrb_md_exp_i                                     ,
    input func_wrb_fdivsqrt_exp_i                                     ,
    input func_wrb_csru_exp_i                                   ,
    input [EXCEPTION_CAUSE_WIDTH-1:0] func_wrb_alu1_ecause_i    ,
    input [EXCEPTION_CAUSE_WIDTH-1:0] func_wrb_alu2_ecause_i    ,
    input [EXCEPTION_CAUSE_WIDTH-1:0] func_wrb_falu1_ecause_i    ,
    input [EXCEPTION_CAUSE_WIDTH-1:0] func_wrb_falu2_ecause_i    ,
    input [EXCEPTION_CAUSE_WIDTH-1:0] func_wrb_lsu_ecause_i     ,
    input [EXCEPTION_CAUSE_WIDTH-1:0] func_wrb_md_ecause_i      ,
    input [EXCEPTION_CAUSE_WIDTH-1:0] func_wrb_fdivsqrt_ecause_i      ,
    input [EXCEPTION_CAUSE_WIDTH-1:0] func_wrb_csru_ecause_i    ,
    //handshacke
    output rcu_alu1_req_valid_o                                 ,
    output rcu_alu2_req_valid_o                                 ,
    output rcu_falu1_req_valid_o                                 ,
    output rcu_falu2_req_valid_o                                 ,
    input rcu_md_req_ready_i                                    ,
    output rcu_md_req_valid_o                                   ,
    input rcu_fdivsqrt_req_ready_i                                    ,
    output rcu_fdivsqrt_req_valid_o                                   ,
    input rcu_lsu_req_ready_i                                   ,
    output rcu_lsu_req_valid_o                                  ,
    output rcu_csr_req_valid_o                                  ,

    // to fu
    output rcu_lsu_wakeup_o                                     ,
    output [ROB_INDEX_WIDTH-1:0] rcu_lsu_wakeup_index_o         ,
    //ALU1
    output [ROB_INDEX_WIDTH-1:0] rcu_alu1_rob_index_o           ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_alu1_prd_address_o      ,
    output [2:0] rcu_alu1_func3_o                               ,
    output [PC_WIDTH-1:0] rcu_alu1_pc_o                         ,
    output [PC_WIDTH-1:0] rcu_alu1_next_pc_o                    ,
    output [PC_WIDTH-1:0] rcu_alu1_predict_pc_o                 ,
    output [IMM_LEN-1:0] rcu_alu1_imm_data_o                    ,
    output [1:0] rcu_alu1_select_a_o                            ,
    output [1:0] rcu_alu1_select_b_o                            ,
    output [XLEN-1:0] rcu_alu1_rs1_data_o                       ,
    output [XLEN-1:0] rcu_alu1_rs2_data_o                       ,
    output  rcu_alu1_jump_o                                     ,
    output  rcu_alu1_branch_o                                   ,
    output  rcu_alu1_half_o                                     ,
    output  rcu_alu1_func_modifier_o                            ,
    //ALU2
    output [ROB_INDEX_WIDTH-1:0] rcu_alu2_rob_index_o           ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_alu2_prd_address_o      ,
    output [2:0] rcu_alu2_func3_o                               ,
    output [PC_WIDTH-1:0] rcu_alu2_pc_o                         ,
    output [PC_WIDTH-1:0] rcu_alu2_next_pc_o                    ,
    output [PC_WIDTH-1:0] rcu_alu2_predict_pc_o                 ,
    output [IMM_LEN-1:0] rcu_alu2_imm_data_o                    ,
    output [1:0] rcu_alu2_select_a_o                            ,
    output [1:0] rcu_alu2_select_b_o                            ,
    output [XLEN-1:0] rcu_alu2_rs1_data_o                       ,
    output [XLEN-1:0] rcu_alu2_rs2_data_o                       ,
    output  rcu_alu2_jump_o                                     ,
    output  rcu_alu2_branch_o                                   ,
    output  rcu_alu2_half_o                                     ,
    output  rcu_alu2_func_modifier_o                            ,
    //FALU1
    output [ROB_INDEX_WIDTH-1:0] rcu_falu1_rob_index_o           ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_falu1_prd_address_o      ,
    output [4:0] rcu_falu1_func5_o                               ,
    output [2:0] rcu_falu1_rounding_mode_o                       ,
    output [1:0] rcu_falu1_fmt_o				 ,
    output [1:0] rcu_falu1_select_a_o                            ,
    output [1:0] rcu_falu1_select_b_o                            ,
    output [1:0] rcu_falu1_select_c_o                            ,
    output [XLEN-1:0] rcu_falu1_rs1_data_o                       ,
    output [XLEN-1:0] rcu_falu1_rs2_data_o                       ,
    output [XLEN-1:0] rcu_falu1_rs3_data_o			,
    //FALU2
    output [ROB_INDEX_WIDTH-1:0] rcu_falu2_rob_index_o           ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_falu2_prd_address_o      ,
    output [4:0] rcu_falu2_func5_o                               ,
    output [2:0] rcu_falu2_rounding_mode_o                       ,
    output [1:0] rcu_falu2_fmt_o				 ,
    output [1:0] rcu_falu2_select_a_o                            ,
    output [1:0] rcu_falu2_select_b_o                            ,
    output [1:0] rcu_falu2_select_c_o                            ,
    output [XLEN-1:0] rcu_falu2_rs1_data_o                       ,
    output [XLEN-1:0] rcu_falu2_rs2_data_o                       ,
    output [XLEN-1:0] rcu_falu2_rs3_data_o			,
    //md
    output [MD_DATA_WIDTH-1:0] rcu_md_package_o                 ,
    //fdivsqrt
    output [FDIVSQRT_DATA_WIDTH-1:0] rcu_fdivsqrt_package_o     ,
    //lsu
    output [LSU_DATA_WIDTH-1:0] rcu_lsu_package_o               ,
    //csr
    output [ROB_INDEX_WIDTH-1:0] rcu_csr_rob_index_o            ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_csr_prd_address_o       ,
    output [2:0] rcu_csr_func3_o                                ,
    output [XLEN-1:0] rcu_csr_rs1_data_o                        ,
    output [IMM_LEN-1:0] rcu_csr_imm_data_o                     ,
    output [CSR_ADDR_LEN-1:0] rcu_csr_address_o                 ,
    output rcu_csr_do_read_o                                    ,
    output rcu_csr_do_write_o                                   ,
    // to fetch
    // output do_rob_commit_first_o                              
    output rcu_bpu_cmt_is_branch_first_o                        ,
    output rcu_bpu_cmt_is_branch_second_o                       ,
    output rcu_bpu_cmt_branch_taken_first_o                     ,
    output rcu_bpu_cmt_branch_taken_second_o                    ,
    output [PC_WIDTH-1:0] rcu_bpu_cmt_final_pc_first_o          ,
    output [PC_WIDTH-1:0] rcu_bpu_cmt_final_pc_second_o         ,
    output [PC_WIDTH-1:0] rcu_bpu_cmt_pc_first_o                ,
    output [PC_WIDTH-1:0] rcu_bpu_cmt_pc_second_o               ,
    output [PC_WIDTH-1:0] rcu_bpu_alu_result_pc_o               ,
    // to exception ctrl
    output rcu_do_rob_commit_first_o                            , // deliver to bpu simutanously
    output rcu_do_rob_commit_second_o                           , // deliver to bpu simutanously
    output [PC_WIDTH-1:0] rcu_cmt_pc_excp_o                     ,
    output predict_miss_o                                       ,
    output rcu_cmt_exception_o                                  ,
    output [EXCEPTION_CAUSE_WIDTH-1:0] rcu_cmt_ecause_o         ,
    output rcu_cmt_is_mret                                      ,
    output rcu_cmt_is_sret                                      ,
    output rcu_cmt_is_wfi                                       ,
    // to physical register
    `ifdef REG_TEST
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_prf_test_prd_first_o                 ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_prf_test_prd_second_o                ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_fp_prf_test_prd_first_o                 ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_fp_prf_test_prd_second_o                ,
    `endif
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_prf_preg_prs1_address_first_o        ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_prf_preg_prs2_address_first_o        ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_prf_preg_prs3_address_first_o        ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_fp_prf_preg_prs1_address_first_o        ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_fp_prf_preg_prs2_address_first_o        ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_fp_prf_preg_prs3_address_first_o        ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_prf_preg_prs1_address_second_o       ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_prf_preg_prs2_address_second_o       ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_prf_preg_prs3_address_second_o       ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_fp_prf_preg_prs1_address_second_o       ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_fp_prf_preg_prs2_address_second_o       ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_fp_prf_preg_prs3_address_second_o       ,
    input  [XLEN-1:0]               prf_rcu_phyreg_first_rs1_data_i         ,
    input  [XLEN-1:0]               prf_rcu_phyreg_first_rs2_data_i          ,
    input  [XLEN-1:0]               prf_rcu_phyreg_first_rs3_data_i          ,
    input  [XLEN-1:0]               fp_prf_rcu_phyreg_first_rs1_data_i         ,
    input  [XLEN-1:0]               fp_prf_rcu_phyreg_first_rs2_data_i          ,
    input  [XLEN-1:0]               fp_prf_rcu_phyreg_first_rs3_data_i          ,
    input  [XLEN-1:0]               prf_rcu_phyreg_second_rs1_data_i         ,
    input  [XLEN-1:0]               prf_rcu_phyreg_second_rs2_data_i         ,
    input  [XLEN-1:0]               prf_rcu_phyreg_second_rs3_data_i         ,
    input  [XLEN-1:0]               fp_prf_rcu_phyreg_second_rs1_data_i         ,
    input  [XLEN-1:0]               fp_prf_rcu_phyreg_second_rs2_data_i         ,
    input  [XLEN-1:0]               fp_prf_rcu_phyreg_second_rs3_data_i         ,
    output [PHY_REG_ADDR_WIDTH-1:0] rcu_prf_physical_alu1_csr_wrb_addr_o     ,
    output [XLEN-1:0]               rcu_prf_physical_alu1_csr_wrb_data_o     ,
    output                          rcu_prf_physical_alu1_csr_done_valid_o   

);

integer i;
//variable declaration
//free_list
wire free_list_wr_first_en, free_list_wr_second_en;
wire [FRLIST_DATA_WIDTH-1:0] free_list_wrdata_first, free_list_wrdata_second;
wire free_list_rd_first_en, free_list_rd_second_en;
wire free_list_rds_first_en, free_list_rds_second_en;
wire [FRLIST_DATA_WIDTH-1:0] free_list_rdata_first, free_list_rdata_second;
wire free_list_full, free_list_almost_full, free_list_empty, free_list_almost_empty;

//fp_free_list
wire fp_free_list_wr_first_en, fp_free_list_wr_second_en;
wire [FRLIST_DATA_WIDTH-1:0] fp_free_list_wrdata_first, fp_free_list_wrdata_second;
wire fp_free_list_rd_first_en, fp_free_list_rd_second_en;
wire fp_free_list_rds_first_en, fp_free_list_rds_second_en;
wire [FRLIST_DATA_WIDTH-1:0] fp_free_list_rdata_first, fp_free_list_rdata_second;
wire fp_free_list_full, fp_free_list_almost_full, fp_free_list_empty, fp_free_list_almost_empty;

//physical regfile
reg [PHY_REG_ADDR_WIDTH-1:0] preg_prs1_address_first, preg_prs2_address_first, preg_prs3_address_first, preg_prs1_address_second, preg_prs2_address_second, preg_prs3_address_second;
reg [PHY_REG_ADDR_WIDTH-1:0] fp_preg_prs1_address_first, fp_preg_prs2_address_first, fp_preg_prs3_address_first, fp_preg_prs1_address_second, fp_preg_prs2_address_second, fp_preg_prs3_address_second;
wire [XLEN-1:0] phyreg_first_rs1_data, phyreg_first_rs2_data, phyreg_first_rs3_data, phyreg_second_rs1_data, phyreg_second_rs2_data, phyreg_second_rs3_data;
wire [XLEN-1:0] fp_phyreg_first_rs1_data, fp_phyreg_first_rs2_data, fp_phyreg_first_rs3_data, fp_phyreg_second_rs1_data, fp_phyreg_second_rs2_data, fp_phyreg_second_rs3_data;
reg [XLEN-1:0] select_first_rs1_data, select_first_rs2_data, select_first_rs3_data, select_second_rs1_data, select_second_rs2_data, select_second_rs3_data;
reg select_first_rs1_source, select_second_rs1_source;
reg select_first_rd_source, select_second_rd_source;
// wire [PHY_REG_ADDR_WIDTH-1:0] physical_alu1_wrb_addr_i, physical_alu2_wrb_addr_i, physical_lsu_wrb_addr_i, physical_md_wrb_addr_i;
// wire [XLEN-1:0] physical_alu1_wrb_data_i, physical_alu2_wrb_data_i, physical_lsu_wrb_data_i, physical_md_wrb_data_i;
// wire physical_alu1_wrb_valid_i, physical_alu2_wrb_valid_i, physical_lsu_wrb_valid_i, physical_md_wrb_valid_i;
wire [XLEN-1:0] physical_alu1_csr_wrb_data;
wire physical_alu1_csr_done_valid;
wire [PHY_REG_ADDR_WIDTH-1:0] physical_alu1_csr_wrb_addr;
//available table
reg available_table[PHY_REG_SIZE-1:0];
//fp_available table
reg fp_available_table[PHY_REG_SIZE-1:0];
wire [PHY_REG_SIZE-1:0] real_available;
wire [PHY_REG_SIZE-1:0] fp_real_available;
//renaming
reg [PHY_REG_ADDR_WIDTH-1:0] rename_reg[63:0];
reg [PHY_REG_ADDR_WIDTH-1:0] rename_reg_backup[63:0];
//fp_renaming
reg [PHY_REG_ADDR_WIDTH-1:0] fp_rename_reg[63:0];
reg [PHY_REG_ADDR_WIDTH-1:0] fp_rename_reg_backup[63:0];
wire [PHY_REG_ADDR_WIDTH-1:0] name_prs1_first, name_prs2_first, name_prs3_first, name_lprd_first, name_prd_first;
wire [PHY_REG_ADDR_WIDTH-1:0] name_prs1_second, name_prs2_second, name_prs3_second, name_lprd_second, name_prd_second;
wire [PHY_REG_ADDR_WIDTH-1:0] prs1_first, prs2_first, prs3_first, prd_first, lprd_first;
wire [PHY_REG_ADDR_WIDTH-1:0] prs1_second, prs2_second, prs3_second, prd_second, lprd_second;

wire [PHY_REG_ADDR_WIDTH-1:0] fp_name_prs1_first, fp_name_prs2_first, fp_name_prs3_first, fp_name_lprd_first, fp_name_prd_first;
wire [PHY_REG_ADDR_WIDTH-1:0] fp_name_prs1_second, fp_name_prs2_second, fp_name_prs3_second, fp_name_lprd_second, fp_name_prd_second;
wire [PHY_REG_ADDR_WIDTH-1:0] fp_prs1_first, fp_prs2_first, fp_prs3_first, fp_prd_first, fp_lprd_first;
wire [PHY_REG_ADDR_WIDTH-1:0] fp_prs1_second, fp_prs2_second, fp_prs3_second, fp_prd_second, fp_lprd_second;
//rob decode op signal
reg [PC_WIDTH-1:0] rob_op_pc[ROB_SIZE-1:0];
reg [PC_WIDTH-1:0] rob_op_next_pc[ROB_SIZE-1:0];
reg [PC_WIDTH-1:0] rob_op_predict_pc[ROB_SIZE-1:0];
reg rob_op_mret[ROB_SIZE-1:0];
reg rob_op_sret[ROB_SIZE-1:0];
reg rob_op_wfi[ROB_SIZE-1:0];
reg rob_op_half[ROB_SIZE-1:0];
reg rob_op_is_float[ROB_SIZE-1:0];
reg rob_op_is_fence[ROB_SIZE-1:0];
reg [1:0] rob_op_fence_op[ROB_SIZE-1:0];
reg rob_op_aext[ROB_SIZE-1:0];
reg [IMM_LEN-1:0] rob_op_imm_data[ROB_SIZE-1:0];
reg [2:0] rob_op_func3[ROB_SIZE-1:0];
reg [4:0] rob_op_func5[ROB_SIZE-1:0];
reg [XLEN-1:0] rob_op_alu_result[ROB_SIZE-1:0];
//ALU
reg rob_op_is_alu[ROB_SIZE-1:0];
reg rob_op_alu_modify[ROB_SIZE-1:0];
reg [1:0] rob_op_alu_select_a[ROB_SIZE-1:0];
reg [1:0] rob_op_alu_select_b[ROB_SIZE-1:0];
reg rob_op_alu_jump[ROB_SIZE-1:0];
reg rob_op_alu_branch[ROB_SIZE-1:0];

reg rob_fp_rd_source[ROB_SIZE-1:0];
reg rob_fp_rs1_source[ROB_SIZE-1:0];

//FALU
reg rob_op_is_falu[ROB_SIZE-1:0];
reg [2:0] rob_op_rounding_mode[ROB_SIZE-1:0];
reg [1:0] rob_op_fmt[ROB_SIZE-1:0];
reg [1:0] rob_op_falu_select_a[ROB_SIZE-1:0];
reg [1:0] rob_op_falu_select_b[ROB_SIZE-1:0];
reg [1:0] rob_op_falu_select_c[ROB_SIZE-1:0];
//MD
reg rob_op_is_md[ROB_SIZE-1:0];
// FDIVSQRT
reg rob_op_is_fdivsqrt[ROB_SIZE-1:0];
//LSU
reg rob_op_is_load[ROB_SIZE-1:0];
reg rob_op_is_store[ROB_SIZE-1:0];
reg [LDU_OP_WIDTH-1:0] rob_op_ldu_op[ROB_SIZE-1:0];
reg [STU_OP_WIDTH-1:0] rob_op_stu_op[ROB_SIZE-1:0];
reg rob_op_aq[ROB_SIZE-1:0];
reg rob_op_rl[ROB_SIZE-1:0];
//CSR
reg rob_op_is_csr[ROB_SIZE-1:0];
reg [CSR_ADDR_LEN-1:0] rob_op_csr_address[ROB_SIZE-1:0];
reg rob_op_csr_read[ROB_SIZE-1:0];
reg rob_op_csr_write[ROB_SIZE-1:0];
//rob use signal
reg rob_used[ROB_SIZE-1:0];
//rob select ctrl
wire [ROB_SIZE-1:0] rob_select_ready;
wire [ROB_SIZE-1:0] rob_edit_frm;
wire [1:0] rob_bypass_select_ready;
//rob selected signal
reg rob_selected[ROB_SIZE-1:0];
//rob exception signal
reg rob_exp[ROB_SIZE-1:0];
reg [EXCEPTION_CAUSE_WIDTH-1:0] rob_ecause[ROB_SIZE-1:0];
//branch taken
reg rob_branch_taken[ROB_SIZE-1:0];
//predict miss
reg rob_predict_miss[ROB_SIZE-1:0];
reg dff_predict_miss;
reg dff_cmt_jump;
wire dff_cmt_miss_delay, cmt_miss;
reg dff_cmt_branch_first       ,dff_cmt_branch_second      ;
reg dff_cmt_branch_taken_first ,dff_cmt_branch_taken_second;
reg [PC_WIDTH-1:0] dff_cmt_op_pc_first        ,dff_cmt_op_pc_second       ;
reg [PC_WIDTH-1:0] dff_cmt_final_pc_first     ,dff_cmt_final_pc_second    ;
reg [PC_WIDTH-1:0] rob_final_branch_pc[ROB_SIZE-1:0];
//rob prs1
reg [PHY_REG_ADDR_WIDTH-1:0] rob_prs1[ROB_SIZE-1:0];
//rob prs2
reg [PHY_REG_ADDR_WIDTH-1:0] rob_prs2[ROB_SIZE-1:0];
//rob prs3
reg [PHY_REG_ADDR_WIDTH-1:0] rob_prs3[ROB_SIZE-1:0];
//rob prd
reg [PHY_REG_ADDR_WIDTH-1:0] rob_prd[ROB_SIZE-1:0];
//rob rd
reg [5:0] rob_rd[ROB_SIZE-1:0];
//rob lprd
reg [PHY_REG_ADDR_WIDTH-1:0] rob_lprd[ROB_SIZE-1:0];
//rob finish
reg rob_finish[ROB_SIZE-1:0];
//rob wake up
reg rob_wakeup[ROB_SIZE-1:0];
//rob skip
wire do_rob_select_skip_first, do_rob_select_skip_second;
//rob write ctrl
wire rob_first_write_ready, rob_second_write_ready;
wire do_rob_write_first, do_rob_write_second;
wire [1:0] do_rob_write;
wire [ROB_INDEX_WIDTH-1:0] wr_rob_index, wr_rob_index_first, wr_rob_index_second;
//rob select ctrl
wire bypass_select_first_valid, bypass_select_second_valid;
wire rob_select_first_valid, rob_select_second_valid;
wire [ROB_INDEX_WIDTH-1:0] rob_select_first_index, rob_select_second_index;
//rob commit ctrl
wire do_rob_commit_first, do_rob_commit_second;
reg do_rob_commit_first_float, do_rob_commit_second_float;
wire [1:0] do_rob_commit;
wire [ROB_INDEX_WIDTH-1:0] cmt_rob_index, cmt_rob_index_first, cmt_rob_index_second;
// issue signal
//first entry
wire compress_select_first_valid, compress_select_second_valid;
reg [ROB_INDEX_WIDTH-1:0] select_first_rob_index     ;
reg [PHY_REG_ADDR_WIDTH-1:0] select_first_prd_address   ;
reg [2:0] select_first_func3         ;
reg [4:0] select_first_func5	     ;

reg [2:0] select_first_rounding_mode ;
reg [1:0] select_first_fmt	     ;
reg [PC_WIDTH-1:0] select_first_pc            ;
reg [PC_WIDTH-1:0] select_first_next_pc       ;
reg [PC_WIDTH-1:0] select_first_predict_pc    ;
reg [IMM_LEN-1:0] select_first_imm           ;
reg [1:0] select_first_select_a      ;
reg [1:0] select_first_select_b      ;
reg [1:0] select_first_select_c      ;
// wire [PHY_REG_ADDR_WIDTH-1:0] preg_prs1_address_first    ;
// wire [PHY_REG_ADDR_WIDTH-1:0] preg_prs2_address_first    ;
reg select_first_is_alu        ;
reg select_first_is_falu       ;
reg select_first_jump          ;
reg select_first_branch        ;
reg select_first_half          ;
reg select_first_is_float      ;
reg select_first_func_modifier ;
reg select_first_is_md         ;
reg select_first_is_fdivsqrt   ;
reg [2:0] select_first_md_op         ;
reg [4:0] select_first_fdivsqrt_op   ;
reg select_first_is_load   ;
reg select_first_is_store  ;
reg [LDU_OP_WIDTH-1:0] select_first_ld_opcode ;
reg [STU_OP_WIDTH-1:0] select_first_st_opcode ;
reg select_first_lsu_fence ;
reg [1:0] select_first_lsu_fence_op ; 
reg select_first_aext;
reg select_first_aq;
reg select_first_rl;
reg select_is_csr;
reg [CSR_ADDR_LEN-1:0] select_csr_address         ;
reg select_do_csr_read         ;
reg select_do_csr_write        ;
//second entry
reg [ROB_INDEX_WIDTH-1:0] select_second_rob_index     ;
reg [PHY_REG_ADDR_WIDTH-1:0] select_second_prd_address   ;
reg [2:0] select_second_func3         ;
reg [4:0] select_second_func5         ;
reg [2:0] select_second_rounding_mode ;
reg [1:0] select_second_fmt           ;
reg [PC_WIDTH-1:0] select_second_pc            ;
reg [PC_WIDTH-1:0] select_second_next_pc       ;
reg [PC_WIDTH-1:0] select_second_predict_pc    ;
reg [IMM_LEN-1:0] select_second_imm           ;
reg [1:0] select_second_select_a      ;
reg [1:0] select_second_select_b      ;
reg [1:0] select_second_select_c      ;
// wire [PHY_REG_ADDR_WIDTH-1:0] preg_prs1_address_second    ;
// wire [PHY_REG_ADDR_WIDTH-1:0] preg_prs2_address_second    ;
reg select_second_is_alu        ;
reg select_second_is_falu       ;
reg select_second_jump          ;
reg select_second_branch        ;
reg select_second_half          ;
reg select_second_is_float      ;
reg select_second_func_modifier ;
reg select_second_is_md         ;
reg select_second_is_fdivsqrt   ;
reg [2:0] select_second_md_op         ;
reg [4:0] select_second_fdivsqrt_op   ;
reg select_second_is_load   ;
reg select_second_is_store  ;
reg [LDU_OP_WIDTH-1:0] select_second_ld_opcode ;
reg [STU_OP_WIDTH-1:0] select_second_st_opcode ;
reg select_second_lsu_fence ;
reg [1:0] select_second_lsu_fence_op ; 
reg select_second_aext;
reg select_second_aq;
reg select_second_rl;
//alu1 reg
reg [ROB_INDEX_WIDTH-1:0] alu1_rob_index       ;
reg [PHY_REG_ADDR_WIDTH-1:0] alu1_prd_address     ;
reg [2:0] alu1_func                     ;
reg [PC_WIDTH-1:0] alu1_pc              ;
reg [PC_WIDTH-1:0] alu1_next_pc         ;
reg [PC_WIDTH-1:0] alu1_predict_pc      ;
reg [IMM_LEN-1:0] alu1_imm              ;
reg [1:0] alu1_select_a        ;
reg [1:0] alu1_select_b        ;
reg [XLEN-1:0] alu1_rs1_data        ;
reg [XLEN-1:0] alu1_rs2_data        ;
reg alu1_jump            ;
reg alu1_branch          ;
reg alu1_half            ;
reg alu1_func_modifier   ;
reg alu1_valid            ;
//alu2 reg
reg [ROB_INDEX_WIDTH-1:0] alu2_rob_index       ;
reg [PHY_REG_ADDR_WIDTH-1:0] alu2_prd_address     ;
reg [2:0] alu2_func            ;
reg [PC_WIDTH-1:0] alu2_pc              ;
reg [PC_WIDTH-1:0] alu2_next_pc         ;
reg [PC_WIDTH-1:0] alu2_predict_pc      ;
reg [IMM_LEN-1:0] alu2_imm             ;
reg [1:0] alu2_select_a        ;
reg [1:0] alu2_select_b        ;
reg [XLEN-1:0] alu2_rs1_data        ;
reg [XLEN-1:0] alu2_rs2_data        ;
reg alu2_jump            ;
reg alu2_branch          ;
reg alu2_half            ;
reg alu2_func_modifier   ;
reg alu2_valid           ;
//falu1 reg
reg [ROB_INDEX_WIDTH-1:0] falu1_rob_index       ;
reg [PHY_REG_ADDR_WIDTH-1:0] falu1_prd_address     ;
reg [4:0] falu1_func            ;
reg [2:0] falu1_rounding_mode   ;
reg [1:0] falu1_fmt		;
reg [1:0] falu1_select_a        ;
reg [1:0] falu1_select_b        ;
reg [1:0] falu1_select_c        ;
reg [XLEN-1:0] falu1_rs1_data        ;
reg [XLEN-1:0] falu1_rs2_data        ;
reg [XLEN-1:0] falu1_rs3_data        ;
reg falu1_valid            ;
//falu2 reg
reg [ROB_INDEX_WIDTH-1:0] falu2_rob_index       ;
reg [PHY_REG_ADDR_WIDTH-1:0] falu2_prd_address     ;
reg [4:0] falu2_func            ;
reg [2:0] falu2_rounding_mode   ;
reg [1:0] falu2_fmt		;
reg [1:0] falu2_select_a        ;
reg [1:0] falu2_select_b        ;
reg [1:0] falu2_select_c        ;
reg [XLEN-1:0] falu2_rs1_data        ;
reg [XLEN-1:0] falu2_rs2_data        ;
reg [XLEN-1:0] falu2_rs3_data        ;
reg falu2_valid            ;
//md queue
wire mdq_wr_first_en, mdq_wr_second_en;
wire mdq_rd_first_en, mdq_rd_second_en;
wire [MD_DATA_WIDTH-1:0] mdq_wrdata_first, mdq_wrdata_second;
wire [MD_DATA_WIDTH-1:0] mdq_do_wdata_first, mdq_do_wdata_second;
wire [MD_DATA_WIDTH-1:0] mdq_rdata_first, mdq_rdata_second;
wire mdq_full, mdq_almost_full, mdq_empty, mdq_almost_empty;
wire [MD_QUEUE_DEPTH_WIDTH:0] mdq_fifo_num;
//fdivsqrt queue
wire fdivsqrtq_wr_first_en, fdivsqrtq_wr_second_en;
wire fdivsqrtq_rd_first_en, fdivsqrtq_rd_second_en;
wire [FDIVSQRT_DATA_WIDTH-1:0] fdivsqrtq_wrdata_first, fdivsqrtq_wrdata_second;
wire [FDIVSQRT_DATA_WIDTH-1:0] fdivsqrtq_do_wdata_first, fdivsqrtq_do_wdata_second;
wire [FDIVSQRT_DATA_WIDTH-1:0] fdivsqrtq_rdata_first, fdivsqrtq_rdata_second;
wire fdivsqrtq_full, fdivsqrtq_almost_full, fdivsqrtq_empty, fdivsqrtq_almost_empty;
wire [FDIVSQRT_QUEUE_DEPTH_WIDTH:0] fdivsqrtq_fifo_num;
//lsu queue
wire lsuq_wr_first_en, lsuq_wr_second_en;
wire lsuq_rd_first_en, lsuq_rd_second_en;
wire [LSU_DATA_WIDTH-1:0] lsuq_wrdata_first, lsuq_wrdata_second;
wire [LSU_DATA_WIDTH-1:0] lsuq_rdata_first, lsuq_rdata_second;
wire [LSU_DATA_WIDTH-1:0] lsuq_do_wdata_first,lsuq_do_wdata_second;
wire lsuq_full, lsuq_almost_full, lsuq_empty, lsuq_almost_empty;
wire [LSU_QUEUE_DEPTH_WIDTH:0] lsuq_fifo_num;
//csr reg
reg [ROB_INDEX_WIDTH-1:0] csr_rob_index;
reg [PHY_REG_ADDR_WIDTH-1:0] csr_prd_address;
reg [2:0] csr_func3;
reg [XLEN-1:0] csr_rs1_data;
reg [IMM_LEN-1:0] csr_imm_data;
reg [CSR_ADDR_LEN-1:0] csr_address;
reg csr_do_read, csr_do_write;
reg csr_valid;

//branch speculate fault(including mode return)
wire global_speculate_fault;
assign global_speculate_fault = global_ret_i | global_trap_i | predict_miss_o;
//: branch speculate fault

//freelist with two port 
f2if2o_freelist #(
    .FIFO_DATA_WIDTH(FRLIST_DATA_WIDTH),
    .FIFO_SIZE(FRLIST_DEPTH),
    .FIFO_SIZE_WIDTH(FRLIST_DEPTH_WIDTH)
) free_list_u(
    .clk(clk)                                      ,
    .rst(rst)                                      ,
    .excep_rst_i(global_speculate_fault)           ,
    .wr_first_en_i(free_list_wr_first_en)          ,
    .wr_second_en_i(free_list_wr_second_en)        ,
    .rd_first_en_i(free_list_rd_first_en)          ,
    .rd_excep_first_en_i(free_list_rds_first_en)   ,
    .rd_second_en_i(free_list_rd_second_en)        ,
    .rd_excep_second_en_i(free_list_rds_second_en) ,
    .wdata_first_i(free_list_wrdata_first)         ,
    .wdata_second_i(free_list_wrdata_second)       ,
    .rdata_first_o(free_list_rdata_first)          ,
    .rdata_second_o(free_list_rdata_second)        ,
    .fifo_full_o(free_list_full)                   ,
    .fifo_almost_full_o(free_list_almost_full)     ,
    .fifo_empty_o(free_list_empty)                 ,
    .fifo_almost_empty_o(free_list_almost_empty)   ,
    .fifo_num_o()                              
);
reg rd_source_first, rs1_source_first;
reg rd_source_second, rs1_source_second;
assign free_list_wrdata_first = rob_lprd[cmt_rob_index_first];
assign free_list_wrdata_second = rob_lprd[cmt_rob_index_second];
assign free_list_wr_first_en = do_rob_commit_first & (rob_lprd[cmt_rob_index_first] != 0) & !global_speculate_fault & !do_rob_commit_first_float;
assign free_list_wr_second_en = do_rob_commit_second & (rob_lprd[cmt_rob_index_second] != 0) & !global_speculate_fault & !do_rob_commit_second_float;
assign free_list_rd_first_en = do_rob_write_first & uses_rd_first_i & (rd_address_first_i != 0) & !rd_source_first;
assign free_list_rd_second_en = do_rob_write_second & uses_rd_second_i & (rd_address_second_i != 0) & !rd_source_second;
assign free_list_rds_first_en = do_rob_commit_first & (rob_prd[cmt_rob_index_first] != 0) & !global_speculate_fault & !do_rob_commit_first_float;
assign free_list_rds_second_en = do_rob_commit_second & (rob_prd[cmt_rob_index_second] != 0) & !global_speculate_fault & !do_rob_commit_second_float;
//: freelist with two port 

//fp_freelist with two port 
f2if2o_fp_freelist #(
    .FIFO_DATA_WIDTH(FRLIST_DATA_WIDTH),
    .FIFO_SIZE(FRLIST_DEPTH),
    .FIFO_SIZE_WIDTH(FRLIST_DEPTH_WIDTH)
) fp_free_list_u(
    .clk(clk)                                      ,
    .rst(rst)                                      ,
    .excep_rst_i(global_speculate_fault)           ,
    .wr_first_en_i(fp_free_list_wr_first_en)          ,
    .wr_second_en_i(fp_free_list_wr_second_en)        ,
    .rd_first_en_i(fp_free_list_rd_first_en)          ,
    .rd_excep_first_en_i(fp_free_list_rds_first_en)   ,
    .rd_second_en_i(fp_free_list_rd_second_en)        ,
    .rd_excep_second_en_i(fp_free_list_rds_second_en) ,
    .wdata_first_i(fp_free_list_wrdata_first)         ,
    .wdata_second_i(fp_free_list_wrdata_second)       ,
    .rdata_first_o(fp_free_list_rdata_first)          ,
    .rdata_second_o(fp_free_list_rdata_second)        ,
    .fifo_full_o(fp_free_list_full)                   ,
    .fifo_almost_full_o(fp_free_list_almost_full)     ,
    .fifo_empty_o(fp_free_list_empty)                 ,
    .fifo_almost_empty_o(fp_free_list_almost_empty)   ,
    .fifo_num_o()                              
);

assign fp_free_list_wrdata_first = rob_lprd[cmt_rob_index_first];
assign fp_free_list_wrdata_second = rob_lprd[cmt_rob_index_second];
assign fp_free_list_wr_first_en = do_rob_commit_first & (rob_lprd[cmt_rob_index_first] != 0) & !global_speculate_fault & do_rob_commit_first_float;
assign fp_free_list_wr_second_en = do_rob_commit_second & (rob_lprd[cmt_rob_index_second] != 0) & !global_speculate_fault & do_rob_commit_second_float;
assign fp_free_list_rd_first_en = do_rob_write_first & uses_rd_first_i & rd_source_first & is_float_first_i;
assign fp_free_list_rd_second_en = do_rob_write_second & uses_rd_second_i &  rd_source_second & is_float_second_i;
assign fp_free_list_rds_first_en = do_rob_commit_first & (rob_prd[cmt_rob_index_first] != 0) & !global_speculate_fault & do_rob_commit_first_float;
assign fp_free_list_rds_second_en = do_rob_commit_second & (rob_prd[cmt_rob_index_second] != 0) & !global_speculate_fault & do_rob_commit_second_float;
//: fp_freelist with two port 
//physical regfile
`ifdef REG_TEST
wire [5:0] test_rd_first  = rob_rd[cmt_rob_index_first];
wire [5:0] test_rd_second = rob_rd[cmt_rob_index_second];
wire test_rd_first_source = rob_fp_rd_source[cmt_rob_index_first];
wire test_rd_second_source = rob_fp_rd_source[cmt_rob_index_second];
wire [PHY_REG_ADDR_WIDTH-1:0] test_prd_first  = rob_prd[cmt_rob_index_first];
wire [PHY_REG_ADDR_WIDTH-1:0] test_prd_second = rob_prd[cmt_rob_index_second];
wire [PHY_REG_ADDR_WIDTH-1:0] test_fp_prd_first  = rob_prd[cmt_rob_index_first];
wire [PHY_REG_ADDR_WIDTH-1:0] test_fp_prd_second = rob_prd[cmt_rob_index_second];

wire [XLEN-1:0] test_rdata_first ;
wire [XLEN-1:0] test_rdata_second;
wire [PC_WIDTH-1:0] test_pc_first  = rob_op_pc[cmt_rob_index_first];
wire [PC_WIDTH-1:0] test_pc_second = rob_op_pc[cmt_rob_index_second];
`endif

// physical_regfile #(
//     .REG_SIZE(PHY_REG_SIZE),
//     .REG_SIZE_WIDTH(PHY_REG_ADDR_WIDTH)
// )physical_regfile_u(
//     .clk                      (clk)                            ,
//     .rst                      (rst)                            ,
//     `ifdef REG_TEST
//     .test_prd_first_i         (test_prd_first)                 ,
//     .test_prd_second_i        (test_prd_second)                ,
//     .test_rdata_first_o       (test_rdata_first )              ,
//     .test_rdata_second_o      (test_rdata_second)              ,
//     `endif
//     .prs1_address_first_i     (preg_prs1_address_first)        ,
//     .prs2_address_first_i     (preg_prs2_address_first)        ,
//     .prs1_address_second_i    (preg_prs1_address_second)       ,
//     .prs2_address_second_i    (preg_prs2_address_second)       ,
//     .prs1_data_first_o        (phyreg_first_rs1_data1)          ,
//     .prs2_data_first_o        (phyreg_first_rs2_data1)          ,
//     .prs1_data_second_o       (phyreg_second_rs1_data1)         ,
//     .prs2_data_second_o       (phyreg_second_rs2_data1)         ,
//     .alu1_wrb_address_i       (physical_alu1_csr_wrb_addr)     ,
//     .alu2_wrb_address_i       (physical_alu2_wrb_addr_i)       ,
//     .lsu_wrb_address_i        (physical_lsu_wrb_addr_i)        ,
//     .md_wrb_address_i         (physical_md_wrb_addr_i)         ,
//     .alu1_wrb_data_i          (physical_alu1_csr_wrb_data)     ,
//     .alu2_wrb_data_i          (physical_alu2_wrb_data_i)       ,
//     .lsu_wrb_data_i           (physical_lsu_wrb_data_i)        ,
//     .md_wrb_data_i            (physical_md_wrb_data_i)         ,
//     .alu1_rcu_resp_valid_i    (physical_alu1_csr_done_valid)   ,
//     .alu2_rcu_resp_valid_i    (func_alu2_done_valid_i)     ,
//     .lsu_rcu_resp_valid_i     (func_lsu_done_valid_i)      ,
//     .md_rcu_resp_valid_i      (func_md_done_valid_i)                           
// );
`ifdef REG_TEST
assign rcu_prf_test_prd_first_o                = test_prd_first                ;
assign rcu_prf_test_prd_second_o               = test_prd_second                  ;      
assign rcu_fp_prf_test_prd_first_o                = test_fp_prd_first                ;
assign rcu_fp_prf_test_prd_second_o               = test_fp_prd_second                  ;      
`endif
assign rcu_prf_preg_prs1_address_first_o       = preg_prs1_address_first          ;
assign rcu_prf_preg_prs2_address_first_o       = preg_prs2_address_first          ;
assign rcu_prf_preg_prs3_address_first_o       = preg_prs3_address_first          ;
assign rcu_prf_preg_prs1_address_second_o      = preg_prs1_address_second         ;
assign rcu_prf_preg_prs2_address_second_o      = preg_prs2_address_second         ;
assign rcu_prf_preg_prs3_address_second_o      = preg_prs3_address_second         ;
assign rcu_fp_prf_preg_prs1_address_first_o       = fp_preg_prs1_address_first          ;
assign rcu_fp_prf_preg_prs2_address_first_o       = fp_preg_prs2_address_first          ;
assign rcu_fp_prf_preg_prs3_address_first_o       = fp_preg_prs3_address_first          ;
assign rcu_fp_prf_preg_prs1_address_second_o      = fp_preg_prs1_address_second         ;
assign rcu_fp_prf_preg_prs2_address_second_o      = fp_preg_prs2_address_second         ;
assign rcu_fp_prf_preg_prs3_address_second_o      = fp_preg_prs3_address_second         ;

assign  phyreg_first_rs1_data  =  prf_rcu_phyreg_first_rs1_data_i             ;
assign  phyreg_first_rs2_data =  prf_rcu_phyreg_first_rs2_data_i              ;
assign  phyreg_first_rs3_data =  prf_rcu_phyreg_first_rs3_data_i              ;
assign  phyreg_second_rs1_data =  prf_rcu_phyreg_second_rs1_data_i             ;
assign  phyreg_second_rs2_data=  prf_rcu_phyreg_second_rs2_data_i             ;
assign  phyreg_second_rs3_data=  prf_rcu_phyreg_second_rs3_data_i             ;

assign  fp_phyreg_first_rs1_data  =  fp_prf_rcu_phyreg_first_rs1_data_i             ;
assign  fp_phyreg_first_rs2_data =  fp_prf_rcu_phyreg_first_rs2_data_i              ;
assign  fp_phyreg_first_rs3_data =  fp_prf_rcu_phyreg_first_rs3_data_i              ;
assign  fp_phyreg_second_rs1_data =  fp_prf_rcu_phyreg_second_rs1_data_i             ;
assign  fp_phyreg_second_rs2_data=  fp_prf_rcu_phyreg_second_rs2_data_i             ;
assign  fp_phyreg_second_rs3_data=  fp_prf_rcu_phyreg_second_rs3_data_i             ;

assign rcu_prf_physical_alu1_csr_wrb_addr_o    = physical_alu1_csr_wrb_addr       ;
assign rcu_prf_physical_alu1_csr_wrb_data_o    = physical_alu1_csr_wrb_data       ;
assign rcu_prf_physical_alu1_csr_done_valid_o  = physical_alu1_csr_done_valid     ;

assign physical_alu1_csr_done_valid = func_alu1_done_valid_i | func_csru_done_valid_i;
assign physical_alu1_csr_wrb_addr = func_alu1_done_valid_i ? physical_alu1_wrb_addr_i
                                                           : physical_csru_wrb_addr_i;
assign physical_alu1_csr_wrb_data = func_alu1_done_valid_i ? physical_alu1_wrb_data_i
                                                           : physical_csru_wrb_data_i;
always @(*) begin
    select_first_rs1_data  = select_first_is_float ? (select_first_rs1_source ? fp_phyreg_first_rs1_data : phyreg_first_rs1_data) : phyreg_first_rs1_data;
    if((preg_prs1_address_first == physical_alu1_wrb_addr_i) & (physical_alu1_wrb_addr_i != 0) & func_alu1_done_valid_i & !select_first_rs1_source) begin
        select_first_rs1_data = physical_alu1_wrb_data_i;
    end
    if((preg_prs1_address_first == physical_alu2_wrb_addr_i) & (physical_alu2_wrb_addr_i != 0) & func_alu2_done_valid_i & !select_first_rs1_source) begin
        select_first_rs1_data = physical_alu2_wrb_data_i;
    end
    if((preg_prs1_address_first == physical_falu1_wrb_addr_i) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & !func_falu1_done_float_i & !select_first_rs1_source) begin
        select_first_rs1_data = physical_falu1_wrb_data_i;
    end
    if((preg_prs1_address_first == physical_falu2_wrb_addr_i) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & !func_falu2_done_float_i & !select_first_rs1_source) begin
        select_first_rs1_data = physical_falu2_wrb_data_i;
    end
    if((preg_prs1_address_first == physical_md_wrb_addr_i) & (physical_md_wrb_addr_i != 0) & func_md_done_valid_i & !select_first_rs1_source) begin
        select_first_rs1_data = physical_md_wrb_data_i;
    end
    if((preg_prs1_address_first == physical_lsu_wrb_addr_i) & (physical_lsu_wrb_addr_i != 0) & func_lsu_done_valid_i & !func_lsu_done_float_i & !select_first_rs1_source) begin
        select_first_rs1_data = physical_lsu_wrb_data_i;
    end
    if((preg_prs1_address_first == physical_csru_wrb_addr_i) & (physical_csru_wrb_addr_i != 0) & func_csru_done_valid_i & !select_first_rs1_source) begin
        select_first_rs1_data = physical_csru_wrb_data_i;
    end
    if((fp_preg_prs1_address_first == physical_falu1_wrb_addr_i) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & func_falu1_done_float_i & select_first_rs1_source) begin
        select_first_rs1_data = physical_falu1_wrb_data_i;
    end
    if((fp_preg_prs1_address_first == physical_falu2_wrb_addr_i) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & func_falu2_done_float_i & select_first_rs1_source) begin
        select_first_rs1_data = physical_falu2_wrb_data_i;
    end
    if((fp_preg_prs1_address_first == physical_fdivsqrt_wrb_addr_i) & (physical_fdivsqrt_wrb_addr_i != 0) & func_fdivsqrt_done_valid_i & select_first_rs1_source) begin
        select_first_rs1_data = physical_fdivsqrt_wrb_data_i;
    end
    if((fp_preg_prs1_address_first == physical_lsu_wrb_addr_i) & (physical_lsu_wrb_addr_i != 0) & func_lsu_done_valid_i & func_lsu_done_float_i & select_first_rs1_source) begin
        select_first_rs1_data = physical_lsu_wrb_data_i;
    end
end
always @(*) begin
    select_first_rs2_data  = (select_first_is_float) ? fp_phyreg_first_rs2_data : phyreg_first_rs2_data;
    if((preg_prs2_address_first == physical_alu1_wrb_addr_i) & (physical_alu1_wrb_addr_i != 0) & func_alu1_done_valid_i  & !select_first_is_float) begin
        select_first_rs2_data = physical_alu1_wrb_data_i;
    end
    if((preg_prs2_address_first == physical_alu2_wrb_addr_i) & (physical_alu2_wrb_addr_i != 0) & func_alu2_done_valid_i & !select_first_is_float) begin
        select_first_rs2_data = physical_alu2_wrb_data_i;
    end
    if((preg_prs2_address_first == physical_falu1_wrb_addr_i) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & !func_falu1_done_float_i & !select_first_is_float) begin
        select_first_rs2_data = physical_falu1_wrb_data_i;
    end
    if((preg_prs2_address_first == physical_falu2_wrb_addr_i) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & !func_falu2_done_float_i & !select_first_is_float) begin
        select_first_rs2_data = physical_falu2_wrb_data_i;
    end
    if((preg_prs2_address_first == physical_md_wrb_addr_i) & (physical_md_wrb_addr_i != 0) & func_md_done_valid_i & !select_first_is_float) begin
        select_first_rs2_data = physical_md_wrb_data_i;
    end
    if((preg_prs2_address_first == physical_lsu_wrb_addr_i) & (physical_lsu_wrb_addr_i != 0) & func_lsu_done_valid_i & !func_lsu_done_float_i & !select_first_is_float) begin
        select_first_rs2_data = physical_lsu_wrb_data_i;
    end
    if((preg_prs2_address_first == physical_csru_wrb_addr_i) & (physical_csru_wrb_addr_i != 0) & func_csru_done_valid_i & !select_first_is_float) begin
        select_first_rs2_data = physical_csru_wrb_data_i;
    end
    if((fp_preg_prs2_address_first == physical_falu1_wrb_addr_i) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & func_falu1_done_float_i & select_first_is_float) begin
        select_first_rs2_data = physical_falu1_wrb_data_i;
    end
    if((fp_preg_prs2_address_first == physical_falu2_wrb_addr_i) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & func_falu2_done_float_i & select_first_is_float) begin
        select_first_rs2_data = physical_falu2_wrb_data_i;
    end
    if((fp_preg_prs2_address_first == physical_lsu_wrb_addr_i) & (physical_lsu_wrb_addr_i != 0) & func_lsu_done_valid_i & func_lsu_done_float_i & select_first_is_float) begin
        select_first_rs2_data = physical_lsu_wrb_data_i;
    end
    if((fp_preg_prs2_address_first == physical_fdivsqrt_wrb_addr_i) & (physical_fdivsqrt_wrb_addr_i != 0) & func_fdivsqrt_done_valid_i & select_first_is_float) begin
        select_first_rs2_data = physical_fdivsqrt_wrb_data_i;
    end
end
always @(*) begin
    select_first_rs3_data  = fp_phyreg_first_rs3_data;
    if((fp_preg_prs3_address_first == physical_falu1_wrb_addr_i) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & func_falu1_done_float_i & select_first_is_float) begin
        select_first_rs3_data = physical_falu1_wrb_data_i;
    end
    if((fp_preg_prs3_address_first == physical_falu2_wrb_addr_i) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & func_falu2_done_float_i & select_first_is_float) begin
        select_first_rs3_data = physical_falu2_wrb_data_i;
    end
    if((fp_preg_prs3_address_first == physical_lsu_wrb_addr_i) & (physical_lsu_wrb_addr_i != 0) & func_lsu_done_valid_i & func_lsu_done_float_i & select_first_is_float) begin
        select_first_rs3_data = physical_lsu_wrb_data_i;
    end
    if((fp_preg_prs3_address_first == physical_fdivsqrt_wrb_addr_i) & (physical_fdivsqrt_wrb_addr_i != 0) & func_fdivsqrt_done_valid_i & select_first_is_float) begin
        select_first_rs3_data = physical_fdivsqrt_wrb_data_i;
    end
end
always @(*) begin
    select_second_rs1_data  = select_second_is_float ? (select_second_rs1_source ? fp_phyreg_second_rs1_data : phyreg_second_rs1_data) : phyreg_second_rs1_data;
    if((preg_prs1_address_second == physical_alu1_wrb_addr_i) & (physical_alu1_wrb_addr_i != 0) & func_alu1_done_valid_i& !select_second_rs1_source) begin
        select_second_rs1_data = physical_alu1_wrb_data_i;
    end
    if((preg_prs1_address_second == physical_alu2_wrb_addr_i) & (physical_alu2_wrb_addr_i != 0) & func_alu2_done_valid_i& !select_second_rs1_source) begin
        select_second_rs1_data = physical_alu2_wrb_data_i;
    end
    if((preg_prs1_address_second == physical_falu1_wrb_addr_i) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & !func_falu1_done_float_i & !select_second_rs1_source) begin
        select_second_rs1_data = physical_falu1_wrb_data_i;
    end
    if((preg_prs1_address_second == physical_falu2_wrb_addr_i) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & !func_falu2_done_float_i & !select_second_rs1_source) begin
        select_second_rs1_data = physical_falu2_wrb_data_i;
    end
    if((preg_prs1_address_second == physical_md_wrb_addr_i) & (physical_md_wrb_addr_i != 0) & func_md_done_valid_i & !select_second_rs1_source) begin
        select_second_rs1_data = physical_md_wrb_data_i;
    end
    if((preg_prs1_address_second == physical_lsu_wrb_addr_i) & (physical_lsu_wrb_addr_i != 0) & func_lsu_done_valid_i & !func_lsu_done_float_i & !select_second_rs1_source) begin
        select_second_rs1_data = physical_lsu_wrb_data_i;
    end
    if((preg_prs1_address_second == physical_csru_wrb_addr_i) & (physical_csru_wrb_addr_i != 0) & func_csru_done_valid_i& !select_second_rs1_source) begin
        select_second_rs1_data = physical_csru_wrb_data_i;
    end
    if((fp_preg_prs1_address_second == physical_falu1_wrb_addr_i) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & func_falu1_done_float_i & select_second_rs1_source) begin
        select_second_rs1_data = physical_falu1_wrb_data_i;
    end
    if((fp_preg_prs1_address_second == physical_falu2_wrb_addr_i) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & func_falu2_done_float_i & select_second_rs1_source) begin
        select_second_rs1_data = physical_falu2_wrb_data_i;
    end
    if((fp_preg_prs1_address_second == physical_lsu_wrb_addr_i) & (physical_lsu_wrb_addr_i != 0) & func_lsu_done_valid_i & func_lsu_done_float_i & select_second_rs1_source) begin
        select_second_rs1_data = physical_lsu_wrb_data_i;
    end
    if((fp_preg_prs1_address_second == physical_fdivsqrt_wrb_addr_i) & (physical_fdivsqrt_wrb_addr_i != 0) & func_fdivsqrt_done_valid_i & select_second_rs1_source) begin
        select_second_rs1_data = physical_fdivsqrt_wrb_data_i;
    end
end
always @(*) begin
    select_second_rs2_data = (select_second_is_float) ? fp_phyreg_second_rs2_data : phyreg_second_rs2_data;
    if((preg_prs2_address_second == physical_alu1_wrb_addr_i) & (physical_alu1_wrb_addr_i != 0) & func_alu1_done_valid_i& !select_second_is_float) begin
        select_second_rs2_data = physical_alu1_wrb_data_i;
    end
    if((preg_prs2_address_second == physical_alu2_wrb_addr_i) & (physical_alu2_wrb_addr_i != 0) & func_alu2_done_valid_i& !select_second_is_float) begin
        select_second_rs2_data = physical_alu2_wrb_data_i;
    end
    if((preg_prs2_address_second == physical_falu1_wrb_addr_i) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & !func_falu1_done_float_i & !select_second_is_float) begin
        select_second_rs2_data = physical_falu1_wrb_data_i;
    end
    if((preg_prs2_address_second == physical_falu2_wrb_addr_i) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & !func_falu2_done_float_i & !select_second_is_float) begin
        select_second_rs2_data = physical_falu2_wrb_data_i;
    end
    if((preg_prs2_address_second == physical_md_wrb_addr_i) & (physical_md_wrb_addr_i != 0) & func_md_done_valid_i & !select_second_is_float) begin
        select_second_rs2_data = physical_md_wrb_data_i;
    end
    if((preg_prs2_address_second == physical_lsu_wrb_addr_i) & (physical_lsu_wrb_addr_i != 0) & func_lsu_done_valid_i & !func_lsu_done_float_i & !select_second_is_float) begin
        select_second_rs2_data = physical_lsu_wrb_data_i;
    end
    if((preg_prs2_address_second == physical_csru_wrb_addr_i) & (physical_csru_wrb_addr_i != 0) & func_csru_done_valid_i& !select_second_is_float) begin
        select_second_rs2_data = physical_csru_wrb_data_i;
    end
    if((fp_preg_prs2_address_second == physical_falu1_wrb_addr_i) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & func_falu1_done_float_i & select_second_is_float) begin
        select_second_rs2_data = physical_falu1_wrb_data_i;
    end
    if((fp_preg_prs2_address_second == physical_falu2_wrb_addr_i) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & func_falu2_done_float_i & select_second_is_float) begin
        select_second_rs2_data = physical_falu2_wrb_data_i;
    end
    if((fp_preg_prs2_address_second == physical_lsu_wrb_addr_i) & (physical_lsu_wrb_addr_i != 0) & func_lsu_done_valid_i & func_lsu_done_float_i & select_second_is_float) begin
        select_second_rs2_data = physical_lsu_wrb_data_i;
    end
    if((fp_preg_prs2_address_second == physical_fdivsqrt_wrb_addr_i) & (physical_fdivsqrt_wrb_addr_i != 0) & func_fdivsqrt_done_valid_i & select_second_is_float) begin
        select_second_rs2_data = physical_fdivsqrt_wrb_data_i;
    end
end
always @(*) begin
    select_second_rs3_data = fp_phyreg_second_rs3_data;
    if((fp_preg_prs3_address_second == physical_falu1_wrb_addr_i) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & func_falu1_done_float_i & select_second_is_float) begin
        select_second_rs3_data = physical_falu1_wrb_data_i;
    end
    if((fp_preg_prs3_address_second == physical_falu2_wrb_addr_i) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & func_falu2_done_float_i & select_second_is_float) begin
        select_second_rs3_data = physical_falu2_wrb_data_i;
    end
    if((fp_preg_prs3_address_second == physical_lsu_wrb_addr_i) & (physical_lsu_wrb_addr_i != 0) & func_lsu_done_valid_i & func_lsu_done_float_i & select_second_is_float) begin
        select_second_rs3_data = physical_lsu_wrb_data_i;
    end
    if((fp_preg_prs3_address_second == physical_fdivsqrt_wrb_addr_i) & (physical_fdivsqrt_wrb_addr_i != 0) & func_fdivsqrt_done_valid_i & select_second_is_float) begin
        select_second_rs3_data = physical_fdivsqrt_wrb_data_i;
    end
end
//: physical regfile

//available table
always @(posedge clk) begin
    if(rst) begin
        for (i = 0; i < PHY_REG_SIZE; i = i + 1) begin
            available_table[i] <= (i == 0) | 0;
        end
    end else begin
        if (func_alu1_done_valid_i) begin
            available_table[physical_alu1_wrb_addr_i] <= 1;
        end
        if (func_alu2_done_valid_i) begin
            available_table[physical_alu2_wrb_addr_i] <= 1;
        end
        if (func_falu1_done_valid_i & !func_falu1_done_float_i) begin
            available_table[physical_falu1_wrb_addr_i] <= 1;
        end
        if (func_falu2_done_valid_i & !func_falu2_done_float_i) begin
            available_table[physical_falu2_wrb_addr_i] <= 1;
        end
        if (func_lsu_done_valid_i & !func_lsu_done_float_i) begin
            available_table[physical_lsu_wrb_addr_i] <= 1;
        end
        if (func_md_done_valid_i) begin
            available_table[physical_md_wrb_addr_i] <= 1;
        end
        if (func_csru_done_valid_i) begin
            available_table[physical_csru_wrb_addr_i] <= 1;
        end
        if (do_rob_write_first) begin
            available_table[prd_first] <= (prd_first == 0) | 0;
        end
        if (do_rob_write_second) begin
            available_table[prd_second] <= (prd_second == 0) | 0;
        end
    end
end
//fp_available table
always @(posedge clk) begin
    if(rst) begin
        for (i = 0; i < PHY_REG_SIZE; i = i + 1) begin
            fp_available_table[i] <= (i == 0) | 0;
        end
    end else begin
        if (func_falu1_done_valid_i & func_falu1_done_float_i) begin
            fp_available_table[physical_falu1_wrb_addr_i] <= 1;
        end
        if (func_falu2_done_valid_i & func_falu2_done_float_i) begin
            fp_available_table[physical_falu2_wrb_addr_i] <= 1;
        end
        if (func_lsu_done_valid_i & func_lsu_done_float_i) begin
            fp_available_table[physical_lsu_wrb_addr_i] <= 1;
        end
        if (func_fdivsqrt_done_valid_i) begin
            fp_available_table[physical_fdivsqrt_wrb_addr_i] <= 1;
        end
        if (do_rob_write_first) begin
            fp_available_table[fp_prd_first] <= (fp_prd_first == 0) | 0;
        end
        if (do_rob_write_second) begin
            fp_available_table[fp_prd_second] <= (fp_prd_second == 0) | 0;
        end
    end
end
generate
    for(genvar j = 0; j < PHY_REG_SIZE; j = j + 1) begin
        assign real_available[j] = available_table[j] & !((prd_first == j) & do_rob_write_first) & !((prd_second == j) & do_rob_write_second) | //the available will clear a cycle late after (write rob = 1)
                                   ((physical_alu1_wrb_addr_i == j) & (physical_alu1_wrb_addr_i != 0) & func_alu1_done_valid_i) |
                                   ((physical_alu2_wrb_addr_i == j) & (physical_alu2_wrb_addr_i != 0) & func_alu2_done_valid_i) |
                                   ((physical_falu1_wrb_addr_i == j) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & !func_falu1_done_float_i) |
                                   ((physical_falu2_wrb_addr_i == j) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & !func_falu2_done_float_i) |
                                   ((physical_md_wrb_addr_i   == j) & (physical_md_wrb_addr_i   != 0) & func_md_done_valid_i  ) |
                                   ((physical_lsu_wrb_addr_i  == j) & (physical_lsu_wrb_addr_i  != 0) & func_lsu_done_valid_i & !func_lsu_done_float_i) |
                                   ((physical_csru_wrb_addr_i == j) & (physical_csru_wrb_addr_i != 0) & func_csru_done_valid_i) ;
    end
endgenerate

generate
    for(genvar j = 0; j < PHY_REG_SIZE; j = j + 1) begin
        assign fp_real_available[j] = fp_available_table[j] & !((fp_prd_first == j) & do_rob_write_first) & !((fp_prd_second == j) & do_rob_write_second) | //the available will clear a cycle late after (write rob = 1)
                                   ((physical_falu1_wrb_addr_i == j) & (physical_falu1_wrb_addr_i != 0) & func_falu1_done_valid_i & func_falu1_done_float_i) |
                                   ((physical_falu2_wrb_addr_i == j) & (physical_falu2_wrb_addr_i != 0) & func_falu2_done_valid_i & func_falu2_done_float_i) |
                                   ((physical_fdivsqrt_wrb_addr_i   == j) & (physical_fdivsqrt_wrb_addr_i   != 0) & func_fdivsqrt_done_valid_i  ) |
                                   ((physical_lsu_wrb_addr_i  == j) & (physical_lsu_wrb_addr_i  != 0) & func_lsu_done_valid_i & func_lsu_done_float_i); 
    end
endgenerate
//: available table

//renaming table
always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 64; i = i + 1) begin
            rename_reg[i] <= 0;
        end 
    end else if (global_speculate_fault) begin
        for (i = 0; i < 64; i = i + 1) begin //when trapped replace rename_reg by old one
            rename_reg[i] <= rename_reg_backup[i];
        end
    end else begin 
        if (uses_rd_first_i) begin
            if (free_list_rd_first_en) begin
                rename_reg[rd_address_first_i] <= free_list_rdata_first;
            end
        end
        if (uses_rd_second_i) begin
            if (free_list_rd_second_en) begin
                rename_reg[rd_address_second_i] <= free_list_rdata_second;
            end
        end
    end
end
    
always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 64; i = i + 1) begin
            rename_reg_backup[i] <= 0;
        end
    end else begin
        if (do_rob_commit_first & !do_rob_commit_first_float & !global_speculate_fault) begin
            rename_reg_backup[rob_rd[cmt_rob_index_first]] <= rob_prd[cmt_rob_index_first];
        end
        if (do_rob_commit_second & !do_rob_commit_second_float & !global_speculate_fault) begin
            rename_reg_backup[rob_rd[cmt_rob_index_second]] <= rob_prd[cmt_rob_index_second];
        end
    end
end
//: renaming table
//fp renaming table
always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 64; i = i + 1) begin
            fp_rename_reg[i] <= 0;
        end 
    end else if (global_speculate_fault) begin
        for (i = 0; i < 64; i = i + 1) begin //when trapped replace rename_reg by old one
            fp_rename_reg[i] <= fp_rename_reg_backup[i];
        end
    end else begin 
        if (uses_rd_first_i) begin
            if (fp_free_list_rd_first_en) begin
                fp_rename_reg[rd_address_first_i] <= fp_free_list_rdata_first;
            end
        end
        if (uses_rd_second_i) begin
            if (fp_free_list_rd_second_en) begin
                fp_rename_reg[rd_address_second_i] <= fp_free_list_rdata_second;
            end
        end
    end
end
    
always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 64; i = i + 1) begin
            fp_rename_reg_backup[i] <= 0;
        end
    end else begin
        if (do_rob_commit_first & do_rob_commit_first_float & !global_speculate_fault) begin
            fp_rename_reg_backup[rob_rd[cmt_rob_index_first]] <= rob_prd[cmt_rob_index_first];
        end
        if (do_rob_commit_second & do_rob_commit_second_float & !global_speculate_fault) begin
            fp_rename_reg_backup[rob_rd[cmt_rob_index_second]] <= rob_prd[cmt_rob_index_second];
        end
    end
end
//: fp_renaming table

//two issue renaming
// use_rd and uses_csr 
assign name_prs1_first = rename_reg[rs1_address_first_i]   ;
assign name_prs2_first = rename_reg[rs2_address_first_i]   ;
assign name_prs3_first = rename_reg[rs3_address_first_i]   ;
assign name_lprd_first = rename_reg[rd_address_first_i]    ;
assign name_prd_first  = free_list_rdata_first              ;
assign name_prs1_second = rename_reg[rs1_address_second_i]  ;
assign name_prs2_second = rename_reg[rs2_address_second_i]  ;
assign name_prs3_second = rename_reg[rs3_address_second_i]  ;
assign name_lprd_second = rename_reg[rd_address_second_i]   ;
assign name_prd_second  = free_list_rdata_second            ;

assign fp_name_prs1_first = fp_rename_reg[rs1_address_first_i]   ;
assign fp_name_prs2_first = fp_rename_reg[rs2_address_first_i]   ;
assign fp_name_prs3_first = fp_rename_reg[rs3_address_first_i]   ;
assign fp_name_lprd_first = fp_rename_reg[rd_address_first_i]    ;
assign fp_name_prd_first  = fp_free_list_rdata_first              ;
assign fp_name_prs1_second = fp_rename_reg[rs1_address_second_i]  ;
assign fp_name_prs2_second = fp_rename_reg[rs2_address_second_i]  ;
assign fp_name_prs3_second = fp_rename_reg[rs3_address_second_i]  ;
assign fp_name_lprd_second = fp_rename_reg[rd_address_second_i]   ;
assign fp_name_prd_second  = fp_free_list_rdata_second            ;

assign prs1_first = uses_rs1_first_i ? name_prs1_first
                                     : 0;
assign prs2_first = uses_rs2_first_i ? name_prs2_first
                                     : 0;
assign prs3_first = uses_rs3_first_i ? name_prs3_first
                                     : 0;
assign prd_first  = free_list_rd_first_en ? name_prd_first
                                          : 0;
assign lprd_first = uses_rd_first_i ? name_lprd_first
                                    : 0;
assign prd_second = free_list_rd_second_en ? name_prd_second
                                           : 0;
assign prs1_second = uses_rs1_second_i ? (((rs1_address_second_i == rd_address_first_i) & (rs1_source_second == rd_source_first) & uses_rd_first_i) ? name_prd_first
                                                                                                           : name_prs1_second)
                                       : 0;
assign prs2_second = uses_rs2_second_i ? (((rs2_address_second_i == rd_address_first_i) & (rd_source_first == 1'b0) & uses_rd_first_i) ? name_prd_first
                                                                                                           : name_prs2_second)
                                       : 0;
assign prs3_second = uses_rs3_second_i ? (((rs3_address_second_i == rd_address_first_i & (rd_source_first == 1'b0)) & uses_rd_first_i & rd_source_first) ? name_prd_first
                                                                                                           : name_prs3_second)
                                       : 0;
assign lprd_second = uses_rd_second_i ? ((rd_address_second_i == rd_address_first_i) & (rd_source_second == rd_source_first) & uses_rd_first_i) ? name_prd_first
                                                                                                        : name_lprd_second
                                      : 0;

assign fp_prs1_first = uses_rs1_first_i ? fp_name_prs1_first : 0;
assign fp_prs2_first = uses_rs2_first_i ? fp_name_prs2_first : 0;
assign fp_prs3_first = uses_rs3_first_i ? fp_name_prs3_first : 0;
assign fp_prd_first  = fp_free_list_rd_first_en ? fp_name_prd_first : 0;
assign fp_lprd_first = uses_rd_first_i ? fp_name_lprd_first : 0;

assign fp_prd_second = fp_free_list_rd_second_en ? fp_name_prd_second : 0;
assign fp_prs1_second = uses_rs1_second_i ? (((rs1_address_second_i == rd_address_first_i) & (rs1_source_second == rd_source_first) & uses_rd_first_i) ? fp_name_prd_first: fp_name_prs1_second): 0;
assign fp_prs2_second = uses_rs2_second_i ? (((rs2_address_second_i == rd_address_first_i) & (rd_source_first == 1'b1) & uses_rd_first_i) ? fp_name_prd_first : fp_name_prs2_second): 0;
assign fp_prs3_second = uses_rs3_second_i ? (((rs3_address_second_i == rd_address_first_i) & (rd_source_first == 1'b1) & uses_rd_first_i) ? fp_name_prd_first : fp_name_prs3_second): 0;
assign fp_lprd_second = uses_rd_second_i ? (((rd_address_second_i == rd_address_first_i) & (rd_source_second == rd_source_first) & uses_rd_first_i) ? fp_name_prd_first : fp_name_lprd_second): 0;
//: two issue renaming

//Rob Entry

always @ (*) begin
	if (is_float_first_i) begin
		case(fu_float_function_first_i)
			FALU_FCVTWS,
			FALU_FCVTWUS,
			FALU_FCVTLS,
			FALU_FCVTLUS,
			FALU_FEQS,
			FALU_FLTS,
			FALU_FLES,
			FALU_FCLASS_S,
			FALU_FMVXW:begin
				rd_source_first = 1'b0;
			end
			default:begin
				rd_source_first = 1'b1;
			end
		endcase
	end
	else begin
		rd_source_first = 1'b0;
	end
end
always @ (*) begin
	if (is_float_first_i) begin
		case(fu_float_function_first_i)
			FALU_FCVTSW,
			FALU_FCVTSWU,
			FALU_FCVTSL,
			FALU_FCVTSLU,
			FALU_FMVWX,
			FLW,
			FSW:begin
				rs1_source_first = 1'b0;
			end
			default:begin
				rs1_source_first = 1'b1;
			end
		endcase
	end
	else begin
		rs1_source_first = 1'b0;
	end
end
always @ (*) begin
	if (is_float_second_i) begin
		case(fu_float_function_second_i)
			FALU_FCVTWS,
			FALU_FCVTWUS,
			FALU_FCVTLS,
			FALU_FCVTLUS,
			FALU_FEQS,
			FALU_FLTS,
			FALU_FLES,
			FALU_FCLASS_S,
			FALU_FMVXW:begin
				rd_source_second = 1'b0;
			end
			default:begin
				rd_source_second = 1'b1;
			end
		endcase
	end
	else begin
		rd_source_second = 1'b0;
	end
end
always @ (*) begin
	if (is_float_second_i) begin
		case(fu_float_function_second_i)
			FALU_FCVTSW,
			FALU_FCVTSWU,
			FALU_FCVTSL,
			FALU_FCVTSLU,
			FALU_FMVWX,
			FLW,
			FSW:begin
				rs1_source_second = 1'b0;
			end
			default:begin
				rs1_source_second = 1'b1;
			end
		endcase
	end
	else begin
		rs1_source_second = 1'b0;
	end
end
//rob decode-op signal
//first entry
//basic signal
always @(posedge clk) begin
    if (do_rob_write_first) begin
        rob_op_pc[wr_rob_index_first] <= pc_first_i;
        rob_op_next_pc[wr_rob_index_first] <= next_pc_first_i;
        rob_op_predict_pc[wr_rob_index_first] <= predict_pc_first_i;
        rob_op_mret[wr_rob_index_first] <= mret_first_i;
        rob_op_sret[wr_rob_index_first] <= sret_first_i;
        rob_op_wfi[wr_rob_index_first] <= wfi_first_i;
        rob_op_half[wr_rob_index_first] <= half_first_i;
	rob_op_is_float[wr_rob_index_first] <= is_float_first_i;
	rob_fp_rd_source[wr_rob_index_first] <= rd_source_first;
	rob_fp_rs1_source[wr_rob_index_first] <= rs1_source_first;
        rob_op_is_fence[wr_rob_index_first] <= is_fence_first_i;
        rob_op_fence_op[wr_rob_index_first] <= fence_op_first_i;
        rob_op_aext[wr_rob_index_first] <= is_aext_first_i;
        rob_op_imm_data[wr_rob_index_first] <= imm_data_first_i;
        rob_op_func3[wr_rob_index_first] <= fu_function_first_i;
	rob_op_func5[wr_rob_index_first] <= fu_float_function_first_i;
	rob_op_rounding_mode[wr_rob_index_first] <= fu_float_rounding_mode_first_i;
	rob_op_fmt[wr_rob_index_first] <= fu_float_fmt_first_i;
    end
    if (do_rob_write_second) begin
        rob_op_pc[wr_rob_index_second] <= pc_second_i;
        rob_op_next_pc[wr_rob_index_second] <= next_pc_second_i;
        rob_op_predict_pc[wr_rob_index_second] <= predict_pc_second_i;
        rob_op_mret[wr_rob_index_second] <= mret_second_i;
        rob_op_sret[wr_rob_index_second] <= sret_second_i;
        rob_op_wfi[wr_rob_index_second] <= wfi_second_i;
        rob_op_half[wr_rob_index_second] <= half_second_i;
	rob_op_is_float[wr_rob_index_second] <= is_float_second_i;
	rob_fp_rd_source[wr_rob_index_second] <= rd_source_second;
	rob_fp_rs1_source[wr_rob_index_second] <= rs1_source_second;
        rob_op_is_fence[wr_rob_index_second] <= is_fence_second_i;
        rob_op_fence_op[wr_rob_index_second] <= fence_op_second_i;
        rob_op_aext[wr_rob_index_second] <= is_aext_second_i;
        rob_op_imm_data[wr_rob_index_second] <= imm_data_second_i;
        rob_op_func3[wr_rob_index_second] <= fu_function_second_i;
	rob_op_func5[wr_rob_index_second] <= fu_float_function_second_i;
	rob_op_rounding_mode[wr_rob_index_second] <= fu_float_rounding_mode_second_i;
	rob_op_fmt[wr_rob_index_second] <= fu_float_fmt_second_i;
    end
end
//ALU signal
always @(posedge clk) begin
    if (do_rob_write_first) begin
        rob_op_is_alu[wr_rob_index_first] <= is_alu_first_i;
        rob_op_alu_modify[wr_rob_index_first] <= alu_function_modifier_first_i;
        rob_op_alu_select_a[wr_rob_index_first] <= fu_select_a_first_i;
        rob_op_alu_select_b[wr_rob_index_first] <= fu_select_b_first_i;
        rob_op_alu_jump[wr_rob_index_first] <= jump_first_i;
        rob_op_alu_branch[wr_rob_index_first] <= branch_first_i;
    end
    if (do_rob_write_second) begin
        rob_op_is_alu[wr_rob_index_second] <= is_alu_second_i;
        rob_op_alu_modify[wr_rob_index_second] <= alu_function_modifier_second_i;
        rob_op_alu_select_a[wr_rob_index_second] <= fu_select_a_second_i;
        rob_op_alu_select_b[wr_rob_index_second] <= fu_select_b_second_i;
        rob_op_alu_jump[wr_rob_index_second] <= jump_second_i;
        rob_op_alu_branch[wr_rob_index_second] <= branch_second_i;
    end
end
//FALU signal
always @(posedge clk) begin
    if (do_rob_write_first) begin
	    rob_op_is_falu[wr_rob_index_first] <= is_falu_first_i;
	    rob_op_falu_select_a[wr_rob_index_first] <= fu_select_a_first_i;
	    rob_op_falu_select_b[wr_rob_index_first] <= fu_select_b_first_i;
	    rob_op_falu_select_c[wr_rob_index_first] <= fu_select_c_first_i;
    end
    if (do_rob_write_second) begin
	    rob_op_is_falu[wr_rob_index_second] <= is_falu_second_i;
	    rob_op_falu_select_a[wr_rob_index_second] <= fu_select_a_second_i;
	    rob_op_falu_select_b[wr_rob_index_second] <= fu_select_b_second_i;
	    rob_op_falu_select_c[wr_rob_index_second] <= fu_select_c_second_i;
    end
end
//MD signal 
always @(posedge clk) begin
    if (do_rob_write_first) begin
        rob_op_is_md[wr_rob_index_first] <= is_mext_first_i;
    end
    if (do_rob_write_second) begin
        rob_op_is_md[wr_rob_index_second] <= is_mext_second_i;
    end
end
//FDIVSQRT signal 
always @(posedge clk) begin
    if (do_rob_write_first) begin
        rob_op_is_fdivsqrt[wr_rob_index_first] <= is_fdivsqrt_first_i;
    end
    if (do_rob_write_second) begin
        rob_op_is_fdivsqrt[wr_rob_index_second] <= is_fdivsqrt_second_i;
    end
end
//LSU signal
always @(posedge clk) begin
    if (do_rob_write_first) begin
        rob_op_is_load[wr_rob_index_first] <= load_first_i;
        rob_op_is_store[wr_rob_index_first] <= store_first_i;
        rob_op_ldu_op[wr_rob_index_first] <= ldu_op_first_i;
        rob_op_stu_op[wr_rob_index_first] <= stu_op_first_i;
        rob_op_aq[wr_rob_index_first] <= aq_first_i;
        rob_op_rl[wr_rob_index_first] <= rl_first_i;
    end
    if (do_rob_write_second) begin
        rob_op_is_load[wr_rob_index_second] <= load_second_i;
        rob_op_is_store[wr_rob_index_second] <= store_second_i;
        rob_op_ldu_op[wr_rob_index_second] <= ldu_op_second_i;
        rob_op_stu_op[wr_rob_index_second] <= stu_op_second_i;
        rob_op_aq[wr_rob_index_second] <= aq_second_i;
        rob_op_rl[wr_rob_index_second] <= rl_second_i;
    end
end
//CSR signal
always @(posedge clk) begin
    if (do_rob_write_first) begin
        rob_op_is_csr[wr_rob_index_first] <= csr_read_first_i | csr_write_first_i;
        rob_op_csr_address[wr_rob_index_first] <= csr_address_first_i;
        rob_op_csr_read[wr_rob_index_first] <= csr_read_first_i;
        rob_op_csr_write[wr_rob_index_first] <= csr_write_first_i;
    end
    if (do_rob_write_second) begin
        rob_op_is_csr[wr_rob_index_second] <= csr_read_second_i | csr_write_second_i;
        rob_op_csr_address[wr_rob_index_second] <= csr_address_second_i;
        rob_op_csr_read[wr_rob_index_second] <= csr_read_second_i;
        rob_op_csr_write[wr_rob_index_second] <= csr_write_second_i;
    end
end
// : rob decode-op signal

//rob use signal
always @(posedge clk) begin 
    if (rst | global_speculate_fault) begin //trapped = (sip || tip || eip || exception) as input
        for (i = 0; i < ROB_SIZE; i = i + 1) begin //when trapped and reset clean all rob
                rob_used[i] <= 0;
            end 
    end else begin
        if (do_rob_write_first) begin 
            rob_used[wr_rob_index_first] <= 1;
        end
        if (do_rob_write_second) begin 
            rob_used[wr_rob_index_second] <= 1;
        end
        if (do_rob_commit_first) begin 
            rob_used[cmt_rob_index_first] <= 0;
        end
        if (do_rob_commit_second) begin 
            rob_used[cmt_rob_index_second] <= 0;
        end
    end
end
//: rob use signal

//rob select ctrl signal
//rob
generate
    for (genvar j = 0; j < ROB_SIZE; j = j + 1) begin
	assign rob_edit_frm[j] = rob_op_csr_write[j] && (rob_op_csr_address[j] == 12'h02 || rob_op_csr_address[j] == 12'h03);
    end
endgenerate

integer index;
reg has_edit_frm;
always @(*) begin
	has_edit_frm = 1'b0;
	for (index = 0; index < ROB_SIZE; index = index + 1) begin
		has_edit_frm = has_edit_frm | rob_edit_frm[index];
	end
end

wire edit_frm_first, edit_frm_second;
assign edit_frm_first = csr_write_first_i && (csr_address_first_i == 12'h02 || csr_address_second_i == 12'h03); 
assign edit_frm_second = csr_write_second_i && (csr_address_second_i == 12'h02 || csr_address_second_i == 12'h03); 

wire [ROB_SIZE-1:0] fp_rob_select_ready;
generate
    for (genvar j = 0; j < ROB_SIZE; j = j + 1) begin
        assign fp_rob_select_ready[j] = ((fp_real_available[rob_prs1[j]] & rob_fp_rs1_source[j]) | (real_available[rob_prs1[j]] & !rob_fp_rs1_source[j])) &
                                     fp_real_available[rob_prs2[j]] &
                                     fp_real_available[rob_prs3[j]] &
				     rob_op_is_float[j] &
                                     rob_used[j] &
                                     !rob_selected[j] &
                                     !((rob_op_is_load[j] | rob_op_is_store[j]) & lsuq_almost_full) &        
                                     !(rob_op_is_fdivsqrt[j] & fdivsqrtq_almost_full) &
                                     !rob_exp[j] & 
                                     !rob_op_mret[j] &
                                     !rob_op_sret[j] &
                                     !global_wfi_i  & 
				     !has_edit_frm
                                     ;
    end
endgenerate
generate
    for (genvar j = 0; j < ROB_SIZE; j = j + 1) begin
        assign rob_select_ready[j] = (real_available[rob_prs1[j]] &
                                     real_available[rob_prs2[j]] &
                                     real_available[rob_prs3[j]] &
                                     rob_used[j] &
				     !rob_op_is_float[j] &
                                     !rob_selected[j] &
                                     !((rob_op_is_load[j] | rob_op_is_store[j]) & lsuq_almost_full) &        
                                     !(rob_op_is_md[j] & mdq_almost_full) &
                                     !(rob_op_is_fdivsqrt[j] & fdivsqrtq_almost_full) &
                                     ((rob_op_is_csr[j] & (cmt_rob_index == j)) | !rob_op_is_csr[j]) &                
                                     !rob_exp[j] & 
                                     !rob_op_mret[j] &
                                     !rob_op_sret[j] &
                                     !global_wfi_i) | fp_rob_select_ready[j]
                                     ;
    end
endgenerate
wire [1:0] fp_rob_bypass_select_ready;
assign fp_rob_bypass_select_ready[0] = ((fp_real_available[fp_prs1_first] & rs1_source_first) | (real_available[prs1_first] & !rs1_source_first)) &
                                    fp_real_available[fp_prs2_first] &
                                    fp_real_available[fp_prs3_first] &
				    is_float_first_i &
                                    do_rob_write_first &
                                    !((load_first_i | store_first_i) & lsuq_almost_full) &
                                    !(is_fdivsqrt_first_i & fdivsqrtq_almost_full) &
                                    !do_rob_select_skip_first &
                                    !global_wfi_i &
                                    !has_edit_frm;

assign fp_rob_bypass_select_ready[1] = ((fp_real_available[fp_prs1_second] & rs1_source_second) | (real_available[prs1_second] & !rs1_source_second)) &
                                    fp_real_available[fp_prs2_second] &
                                    fp_real_available[fp_prs3_second] &
				    is_float_second_i &
                                    do_rob_write_second &
                                    !((load_second_i | store_second_i) & lsuq_almost_full) &
                                    !(is_fdivsqrt_second_i & fdivsqrtq_almost_full) &
                                    !do_rob_select_skip_second &
                                    !global_wfi_i &
				    !has_edit_frm &
                                    !edit_frm_first;


assign rob_bypass_select_ready[0] = (real_available[prs1_first] &
                                    real_available[prs2_first] &
                                    real_available[prs3_first] &
				    !is_float_first_i &
                                    do_rob_write_first &
                                    !((load_first_i | store_first_i) & lsuq_almost_full) &
                                    !(is_mext_first_i & mdq_almost_full) &
                                    (((csr_read_first_i | csr_write_first_i) & (cmt_rob_index == wr_rob_index_first)) | !(csr_read_first_i | csr_write_first_i)) &                     
                                    !do_rob_select_skip_first &
                                    !global_wfi_i) | fp_rob_bypass_select_ready[0];
                                    ;

assign rob_bypass_select_ready[1] = (real_available[prs1_second] &
                                    real_available[prs2_second] &
                                    real_available[prs3_second] &
                                    do_rob_write_second &
				    !is_float_second_i &
                                    !((load_second_i | store_second_i) & lsuq_almost_full) &
                                    !(is_mext_second_i & mdq_almost_full) &
                                    (((csr_read_second_i | csr_write_second_i) & (cmt_rob_index == wr_rob_index_second)) | !(csr_read_second_i | csr_write_second_i)) &                      
                                    !do_rob_select_skip_second &
                                    !global_wfi_i) | fp_rob_bypass_select_ready[1];
                                    ;
//: rob select ctrl

//rob selected signal
always @(posedge clk) begin 
    if (rst | global_speculate_fault) begin
        for (i = 0; i < ROB_SIZE; i = i + 1) begin
            rob_selected[i] <= 0;
        end
    end else begin
        if (compress_select_first_valid) begin
            rob_selected[select_first_rob_index] <= 1;
        end
        if (compress_select_second_valid) begin
            rob_selected[select_second_rob_index] <= 1;
        end
        if (do_rob_commit_first) begin 
            rob_selected[cmt_rob_index_first] <= 0;
        end
        if (do_rob_commit_second) begin 
            rob_selected[cmt_rob_index_second] <= 0;
        end
    end
end
//: rob selected signal

//rob exception signal
always @(posedge clk) begin
    if (rst | global_speculate_fault) begin
        for (i = 0; i < ROB_SIZE; i = i + 1) begin
            rob_exp[i] <= 0;
            rob_ecause[i] <= 0;
        end
    end else begin
        if(do_rob_write_first) begin
            rob_exp[wr_rob_index_first] <= exception_first_i;
            rob_ecause[wr_rob_index_first] <= exception_first_i ? ecause_first_i : 0;
        end
        if(do_rob_write_second) begin
            rob_exp[wr_rob_index_second] <= exception_second_i;
            rob_ecause[wr_rob_index_second] <= exception_second_i ? ecause_second_i : 0;
        end
        if(func_wrb_alu1_exp_i) begin
            rob_exp[func_alu1_rob_index_i] <= func_wrb_alu1_exp_i;
            rob_ecause[func_alu1_rob_index_i] <= func_wrb_alu1_ecause_i;
        end
        if(func_wrb_alu2_exp_i) begin
            rob_exp[func_alu2_rob_index_i] <= func_wrb_alu2_exp_i;
            rob_ecause[func_alu2_rob_index_i] <= func_wrb_alu2_ecause_i;
        end
        if(func_wrb_falu1_exp_i) begin
            rob_exp[func_falu1_rob_index_i] <= func_wrb_falu1_exp_i;
            rob_ecause[func_falu1_rob_index_i] <= func_wrb_falu1_ecause_i;
        end
        if(func_wrb_falu2_exp_i) begin
            rob_exp[func_falu2_rob_index_i] <= func_wrb_falu2_exp_i;
            rob_ecause[func_falu2_rob_index_i] <= func_wrb_falu2_ecause_i;
        end
        if(func_wrb_lsu_exp_i) begin
            rob_exp[func_lsu_rob_index_i] <= func_wrb_lsu_exp_i;
            rob_ecause[func_lsu_rob_index_i] <= func_wrb_lsu_ecause_i;
        end
        if(func_wrb_md_exp_i) begin
            rob_exp[func_md_rob_index_i] <= func_wrb_md_exp_i;
            rob_ecause[func_md_rob_index_i] <= func_wrb_md_ecause_i;
        end
        if(func_wrb_fdivsqrt_exp_i) begin
            rob_exp[func_fdivsqrt_rob_index_i] <= func_wrb_fdivsqrt_exp_i;
            rob_ecause[func_fdivsqrt_rob_index_i] <= func_wrb_fdivsqrt_ecause_i;
        end
        if(func_wrb_csru_exp_i) begin
            rob_exp[func_csru_rob_index_i] <= func_wrb_csru_exp_i;
            rob_ecause[func_csru_rob_index_i] <= func_wrb_csru_ecause_i;
        end
    end
end
// : rob exception signal

//exception ctrl
assign rcu_do_rob_commit_first_o = do_rob_commit_first;
assign rcu_do_rob_commit_second_o = do_rob_commit_second;
assign rcu_cmt_pc_excp_o = rob_op_pc[cmt_rob_index_first];
assign rcu_cmt_exception_o = rob_exp[cmt_rob_index_first];
assign rcu_cmt_ecause_o = rob_ecause[cmt_rob_index_first];
assign rcu_cmt_is_mret = rob_op_mret[cmt_rob_index_first];
assign rcu_cmt_is_sret = rob_op_sret[cmt_rob_index_first];
assign rcu_cmt_is_wfi = rob_op_wfi[cmt_rob_index_first];
//: exception ctrl

//branch taken
always @(posedge clk) begin
    if(rst | global_speculate_fault) begin
        for (i = 0; i < ROB_SIZE; i = i + 1) begin
            rob_branch_taken[i] <= 0;
        end
    end else begin
        if (func_alu1_done_valid_i & alu1_branch_taken_i) begin
            rob_branch_taken[func_alu1_rob_index_i] <= 1;
        end
        if (func_alu2_done_valid_i & alu2_branch_taken_i) begin
            rob_branch_taken[func_alu2_rob_index_i] <= 1;
        end
        if (do_rob_commit_first) begin
            rob_branch_taken[cmt_rob_index_first] <= 0;
        end
        if (do_rob_commit_second) begin
            rob_branch_taken[cmt_rob_index_second] <= 0;
        end
    end
end
//: branch taken

//predict miss
always @(posedge clk) begin
    if(rst | global_speculate_fault) begin
        for (i = 0; i < ROB_SIZE; i = i + 1) begin
            rob_predict_miss[i] <= 0;
        end
    end else begin
        if (func_alu1_done_valid_i & alu1_predict_miss_i) begin
            rob_predict_miss[func_alu1_rob_index_i] <= 1;
        end
        if (func_alu2_done_valid_i & alu2_predict_miss_i) begin
            rob_predict_miss[func_alu2_rob_index_i] <= 1;
        end
        if (do_rob_commit_first) begin
            rob_predict_miss[cmt_rob_index_first] <= 0;
        end
        if (do_rob_commit_second) begin
            rob_predict_miss[cmt_rob_index_second] <= 0;
        end
    end
end
// final_branch_pc
always @(posedge clk) begin
    if(func_alu1_done_valid_i) begin
        if ((rob_op_alu_branch[func_alu1_rob_index_i] | rob_op_alu_jump[func_alu1_rob_index_i])) begin
            rob_final_branch_pc[func_alu1_rob_index_i] <= alu1_final_branch_pc_i;
        end else begin
            rob_final_branch_pc[func_alu1_rob_index_i] <= rob_op_pc[func_alu1_rob_index_i];
        end
    end
    if(func_alu2_done_valid_i) begin
        if ((rob_op_alu_branch[func_alu2_rob_index_i] | rob_op_alu_jump[func_alu2_rob_index_i])) begin
            rob_final_branch_pc[func_alu2_rob_index_i] <= alu2_final_branch_pc_i;
        end else begin
            rob_final_branch_pc[func_alu2_rob_index_i] <= rob_op_pc[func_alu2_rob_index_i];
        end
    end
end        
assign rcu_bpu_cmt_is_branch_first_o = dff_cmt_miss_delay ? dff_cmt_branch_first
                                                : cmt_miss ? rob_op_alu_branch[cmt_rob_index_first] | rob_op_alu_jump[cmt_rob_index_first] : 0;
assign rcu_bpu_cmt_is_branch_second_o = dff_cmt_miss_delay ? dff_cmt_branch_second
                                                 : cmt_miss ? rob_op_alu_branch[cmt_rob_index_second] | rob_op_alu_jump[cmt_rob_index_second] : 0;
assign rcu_bpu_cmt_branch_taken_first_o = dff_cmt_miss_delay ? dff_cmt_branch_taken_first
                                                   : cmt_miss ? rob_branch_taken[cmt_rob_index_first] : 0;
assign rcu_bpu_cmt_branch_taken_second_o = dff_cmt_miss_delay ? dff_cmt_branch_taken_second
                                                    : cmt_miss ? rob_branch_taken[cmt_rob_index_second] : 0;
assign rcu_bpu_cmt_pc_first_o = dff_cmt_miss_delay ? dff_cmt_op_pc_first
                                         : cmt_miss ? rob_op_pc[cmt_rob_index_first] : 0;
assign rcu_bpu_cmt_pc_second_o = dff_cmt_miss_delay ? dff_cmt_op_pc_second
                                          : cmt_miss ? rob_op_pc[cmt_rob_index_second] : 0;
assign rcu_bpu_cmt_final_pc_first_o = dff_cmt_miss_delay ? dff_cmt_final_pc_first
                                               : cmt_miss ? rob_final_branch_pc[cmt_rob_index_first] : 0;
assign rcu_bpu_cmt_final_pc_second_o = dff_cmt_miss_delay ? dff_cmt_final_pc_second
                                                : cmt_miss ? rob_final_branch_pc[cmt_rob_index_second] : 0;
assign predict_miss_o = dff_cmt_miss_delay ? 1 : cmt_miss ? 1 : 0;
assign dff_cmt_miss_delay = dff_cmt_jump & dff_predict_miss;
assign cmt_miss = !rob_op_alu_jump[cmt_rob_index_first] & rob_predict_miss[cmt_rob_index_first];

always @(posedge clk) begin
    if (rst | global_speculate_fault) begin
        dff_cmt_jump                <= 0;
        dff_predict_miss            <= 0;
        dff_cmt_branch_first        <= 0;
        dff_cmt_branch_second       <= 0;
        dff_cmt_branch_taken_first  <= 0;
        dff_cmt_branch_taken_second <= 0;
        dff_cmt_op_pc_first         <= 0;
        dff_cmt_op_pc_second        <= 0;
        dff_cmt_final_pc_first      <= 0;
        dff_cmt_final_pc_second     <= 0;
    end else begin
        dff_cmt_jump                <= rob_op_alu_jump[cmt_rob_index_first];
        dff_predict_miss            <= rob_predict_miss[cmt_rob_index_first];
        dff_cmt_branch_first        <= rob_op_alu_branch[cmt_rob_index_first] | rob_op_alu_jump[cmt_rob_index_first];
        dff_cmt_branch_second       <= rob_op_alu_branch[cmt_rob_index_second] | rob_op_alu_jump[cmt_rob_index_second];
        dff_cmt_branch_taken_first  <= rob_branch_taken[cmt_rob_index_first];
        dff_cmt_branch_taken_second <= rob_branch_taken[cmt_rob_index_second];
        dff_cmt_op_pc_first         <= rob_op_pc[cmt_rob_index_first];
        dff_cmt_op_pc_second        <= rob_op_pc[cmt_rob_index_second];
        dff_cmt_final_pc_first      <= rob_final_branch_pc[cmt_rob_index_first];
        dff_cmt_final_pc_second     <= rob_final_branch_pc[cmt_rob_index_second];
    end
end
//: predict miss

// branch calculated pc
always @(posedge clk) begin
    if (func_alu1_done_valid_i) begin
        rob_op_alu_result[func_alu1_rob_index_i] <= physical_alu1_wrb_data_i;
    end
    if (func_alu2_done_valid_i) begin
        rob_op_alu_result[func_alu2_rob_index_i] <= physical_alu2_wrb_data_i;
    end
end
assign rcu_bpu_alu_result_pc_o = rob_op_alu_result[cmt_rob_index_first][PC_WIDTH-1:0];
// : branch calculated pc

//rob prs1
always @(posedge clk) begin 
    if (do_rob_write_first) begin
	    if (is_float_first_i) begin
	    	if (rs1_source_first) begin
	    		rob_prs1[wr_rob_index_first] <= fp_prs1_first;
	    	end	
		else begin
			rob_prs1[wr_rob_index_first] <= prs1_first; 
		end
	    end
	    else begin
		rob_prs1[wr_rob_index_first] <= prs1_first; 
	    end
    end
    if (do_rob_write_second) begin
	    if (is_float_second_i) begin
	    	if (rs1_source_second) begin
	    		rob_prs1[wr_rob_index_second] <= fp_prs1_second;
	    	end	
		else begin
			rob_prs1[wr_rob_index_second] <= prs1_second; 
		end
	    end
	    else begin
		rob_prs1[wr_rob_index_second] <= prs1_second; 
	    end
    end
end 
// : rob prs1

//rob prs2
always @(posedge clk) begin 
    if (do_rob_write_first) begin
	    if (is_float_first_i) begin
		rob_prs2[wr_rob_index_first] <= fp_prs2_first; 
	    end
	    else begin
		rob_prs2[wr_rob_index_first] <= prs2_first; 
	    end
    end
    if (do_rob_write_second) begin
	    if (is_float_second_i) begin
		rob_prs2[wr_rob_index_second] <= fp_prs2_second; 
	    end
	    else begin
		rob_prs2[wr_rob_index_second] <= prs2_second; 
	    end
    end
end 
// : rob prs2

//rob prs3
always @(posedge clk) begin 
    if (do_rob_write_first) begin
        rob_prs3[wr_rob_index_first] <= fp_prs3_first; 
    end
    if (do_rob_write_second) begin
        rob_prs3[wr_rob_index_second] <= fp_prs3_second; 
    end
end 
// : rob prs3

//rob prd
always @(posedge clk) begin 
    if (do_rob_write_first) begin
	    if (is_float_first_i) begin
		    if (rd_source_first != 0) begin
			rob_prd[wr_rob_index_first] <= fp_prd_first;
		    end
		    else begin
		    	rob_prd[wr_rob_index_first] <= prd_first;
		    end
	    end
	    else begin
		rob_prd[wr_rob_index_first] <= prd_first;
	    end
    end
    if (do_rob_write_second) begin
	    if (is_float_second_i) begin
		    if (rd_source_second != 0) begin
			rob_prd[wr_rob_index_second] <= fp_prd_second;
		    end
		    else begin
			rob_prd[wr_rob_index_second] <= prd_second;
		    end
	    end
	    else begin
		rob_prd[wr_rob_index_second] <= prd_second;
	    end
    end
end
// : rob prd

//rob lprd
always @(posedge clk) begin
    if (do_rob_write_first) begin
	    if (is_float_first_i) begin
		    if (rd_source_first) begin
			rob_lprd[wr_rob_index_first] <= fp_lprd_first;
		    end
		    else begin
			rob_lprd[wr_rob_index_first] <= lprd_first;
		    end
	    end
	    else begin
		rob_lprd[wr_rob_index_first] <= lprd_first;
	    end
    end
    if (do_rob_write_second) begin
	    if (is_float_second_i) begin
		    if (rd_source_second) begin
		    	rob_lprd[wr_rob_index_first] <= fp_lprd_second;
		    end
		    else begin
		    	rob_lprd[wr_rob_index_second] <= lprd_second;
		    end
	    end
	    else begin
		rob_lprd[wr_rob_index_second] <= lprd_second;
	    end
    end
end
// : rob lprd

//rob rd 
always @(posedge clk) begin
    if (do_rob_write_first) begin
        if (uses_rd_first_i) begin
            rob_rd[wr_rob_index_first] <= rd_address_first_i;
        end else begin
            rob_rd[wr_rob_index_first] <= 0;
        end
    end
    if (do_rob_write_second) begin
        if (uses_rd_second_i) begin
            rob_rd[wr_rob_index_second] <= rd_address_second_i;
        end else begin
            rob_rd[wr_rob_index_second] <= 0;
        end
    end
end
// : rob rd

`ifdef REG_TEST
reg [PHY_REG_ADDR_WIDTH-1:0] rob_rs2[ROB_SIZE-1:0];
always @(posedge clk) begin
    if (do_rob_write_first) begin
        if (uses_rs2_first_i) begin
            rob_rs2[wr_rob_index_first] <= rs2_address_first_i;
        end else begin
            rob_rs2[wr_rob_index_first] <= 0;
        end
    end
    if (do_rob_write_second) begin
        if (uses_rs2_second_i) begin
            rob_rs2[wr_rob_index_second] <= rs2_address_second_i;
        end else begin
            rob_rs2[wr_rob_index_second] <= 0;
        end
    end
end
`endif

//rob FU finish
always @(posedge clk) begin
    if (rst | global_speculate_fault) begin
        for (i = 0; i < ROB_SIZE; i = i + 1) begin
            rob_finish[i] <= 0;
        end
    end else begin
        if (func_alu1_done_valid_i) begin
            rob_finish[func_alu1_rob_index_i] <= 1;
        end
        if (func_alu2_done_valid_i) begin
            rob_finish[func_alu2_rob_index_i] <= 1;
        end
        if (func_falu1_done_valid_i) begin
            rob_finish[func_falu1_rob_index_i] <= 1;
        end
        if (func_falu2_done_valid_i) begin
            rob_finish[func_falu2_rob_index_i] <= 1;
        end
        if (func_lsu_done_valid_i) begin
            rob_finish[func_lsu_rob_index_i] <= 1;
        end
        if (func_md_done_valid_i) begin
            rob_finish[func_md_rob_index_i] <= 1;
        end
        if (func_fdivsqrt_done_valid_i) begin
            rob_finish[func_fdivsqrt_rob_index_i] <= 1;
        end
        if (func_csru_done_valid_i) begin
            rob_finish[func_csru_rob_index_i] <= 1;
        end
        if (do_rob_commit_first) begin
            rob_finish[cmt_rob_index_first] <= 0;
        end
        if (do_rob_commit_second) begin
            rob_finish[cmt_rob_index_second] <= 0;
        end
        if (do_rob_select_skip_first) begin
            rob_finish[wr_rob_index_first] <= 1;
        end
        if (do_rob_select_skip_second) begin
            rob_finish[wr_rob_index_second] <= 1;
        end
    end
end
// : rob FU finish

//: Rob Entry

//rob wake up
always @(posedge clk) begin
    if(do_rob_write_first) begin
        if(load_first_i | store_first_i) begin
            rob_wakeup[wr_rob_index_first] <= 1;
        end else begin
            rob_wakeup[wr_rob_index_first] <= 0;
        end
    end
    if(do_rob_write_second) begin
        if(load_second_i | store_second_i) begin
            rob_wakeup[wr_rob_index_second] <= 1;
        end else begin
            rob_wakeup[wr_rob_index_second] <= 0;
        end
    end
end
assign rcu_lsu_wakeup_o = rob_wakeup[cmt_rob_index_first] & rob_used[cmt_rob_index_first];
assign rcu_lsu_wakeup_index_o = cmt_rob_index_first;
//: rob wake up

//rob skip gen
assign do_rob_select_skip_first = (exception_first_i | //& !ecause_first_i[EXCEPTION_CAUSE_WIDTH-1] |
                                  mret_first_i |
                                  sret_first_i |
                                  wfi_first_i) &
                                  do_rob_write_first
                                  ;
assign do_rob_select_skip_second = (exception_second_i | //& !ecause_second_i[EXCEPTION_CAUSE_WIDTH-1] |
                                   mret_second_i |
                                   sret_second_i |
                                   wfi_second_i) &
                                   do_rob_write_second
                                   ;
// : rob skip gen

//rob write ctrl
configurable_2mode_counter #(
    .CNT_SIZE(ROB_SIZE),
    .CNT_SIZE_WIDTH(ROB_SIZE_WIDTH)
) wr_rob_counter (
    .clk(clk),
    .rst(rst | global_speculate_fault),
    .mode_i(do_rob_write),
    .cnt_rst_vector_i({ROB_SIZE_WIDTH{1'b0}}),
    .cnt_o(wr_rob_index),
    .cnt_end_o()
);
assign deco_rob_req_ready_first_o = rob_first_write_ready;
assign deco_rob_req_ready_second_o = rob_second_write_ready;
assign rob_first_write_ready = !rob_used[wr_rob_index_first];
assign rob_second_write_ready = !rob_used[wr_rob_index_second];
assign do_rob_write_first = rob_first_write_ready & 
                            deco_rob_req_valid_first_i & 
                            !global_speculate_fault &
                            !global_wfi_i
                            ;
assign do_rob_write_second = rob_second_write_ready & 
                             deco_rob_req_valid_second_i & 
                             !global_speculate_fault &
                             !global_wfi_i
                             ;
assign do_rob_write = {do_rob_write_second, do_rob_write_first};
assign wr_rob_index_first = wr_rob_index;
assign wr_rob_index_second = (wr_rob_index == ROB_SIZE - 1) ? 0
                                                            : wr_rob_index + 1;
//: rob entry ctrl

//rob select ctrl
//first stage selector
reg [ROB_SIZE-1:0] rob_op_ls;
always @(*) begin
    for (i = 0; i < ROB_SIZE; i = i + 1) begin
        rob_op_ls[i] = (rob_op_is_store[i] | rob_op_is_load[i] | rob_op_is_csr[i]) & !rob_selected[i];
    end
end
oldest2_abitter_bps_lss #(
    .SEL_WIDTH(ROB_SIZE),
    .PRIORITY_WIDTH(ROB_SIZE_WIDTH)
)oldest2_selector(
    .priority_fix_i(cmt_rob_index),
    .req_ls_i(rob_op_ls),
    .req_i(rob_select_ready),
    .new_req_first_i(rob_bypass_select_ready[0]),
    .new_req_second_i(rob_bypass_select_ready[1]),
    .new_req_ls_first_i(load_first_i | store_first_i),
    .new_req_ls_second_i(load_second_i | store_second_i),
    .new_grant_first_o(bypass_select_first_valid),
    .new_grant_second_o(bypass_select_second_valid),
    .first_grant_valid_o(rob_select_first_valid),
    .first_grant_index_o(rob_select_first_index),
    .second_grant_valid_o(rob_select_second_valid),
    .second_grant_index_o(rob_select_second_index)
);
/*
oldest2_abitter_bps #(
    .SEL_WIDTH(ROB_SIZE),
    .PRIORITY_WIDTH(ROB_SIZE_WIDTH)
)oldest2_selector(
    .priority_fix_i(cmt_rob_index),
    .req_i(rob_select_ready),
    .new_req_first_i(rob_bypass_select_ready[0]),
    .new_req_second_i(rob_bypass_select_ready[1]),
    .new_grant_first_o(bypass_select_first_valid),
    .new_grant_second_o(bypass_select_second_valid),
    .first_grant_valid_o(rob_select_first_valid),
    .first_grant_index_o(rob_select_first_index),
    .second_grant_valid_o(rob_select_second_valid),
    .second_grant_index_o(rob_select_second_index)
);
*/
//: rob select ctrl

//rob commit ctrl
configurable_2mode_counter #(
    .CNT_SIZE(ROB_SIZE),
    .CNT_SIZE_WIDTH(ROB_SIZE_WIDTH)
) cmt_rob_counter (
    .clk(clk),
    .rst(rst | global_speculate_fault),
    .mode_i(do_rob_commit),
	.cnt_rst_vector_i({ROB_SIZE_WIDTH{1'b0}}),
    .cnt_o(cmt_rob_index),
    .cnt_end_o()
);

assign do_rob_commit_first = rob_used[cmt_rob_index_first] & 
                             rob_finish[cmt_rob_index_first] & 
                             !dff_cmt_miss_delay &
                             !global_wfi_i;
assign do_rob_commit_second = rob_used[cmt_rob_index_second] & 
                              rob_finish[cmt_rob_index_second] & 
                              !rob_predict_miss[cmt_rob_index_second] & !rob_predict_miss[cmt_rob_index_first] &
                              !rob_exp[cmt_rob_index_second] & !rob_exp[cmt_rob_index_first] &
                              !rob_op_mret[cmt_rob_index_second] & !rob_op_mret[cmt_rob_index_first] &
                              !rob_op_sret[cmt_rob_index_second] & !rob_op_sret[cmt_rob_index_first] &
                              !rob_op_wfi[cmt_rob_index_second] & !rob_op_wfi[cmt_rob_index_first] &
                              do_rob_commit_first;
always @ (*) begin
	do_rob_commit_first_float = do_rob_commit_first & rob_fp_rd_source[cmt_rob_index_first];
	do_rob_commit_second_float = do_rob_commit_second & rob_fp_rd_source[cmt_rob_index_second];

end
assign do_rob_commit = {do_rob_commit_second, do_rob_commit_first};
assign cmt_rob_index_first = cmt_rob_index;                                                          
assign cmt_rob_index_second = (cmt_rob_index == ROB_SIZE - 1) ? 0
                                                              : cmt_rob_index + 1;
//: rob commit ctrl

//issue signal gen
//first issue port
always @(*) begin 
    if(rob_select_first_valid) begin //read preg
        select_first_rob_index      = rob_select_first_index                         ;
        select_first_prd_address    = rob_prd[rob_select_first_index]                ;
        select_first_func3          = rob_op_func3[rob_select_first_index]           ;
	select_first_func5          = rob_op_func5[rob_select_first_index]	     ;
	select_first_rs1_source     = rob_fp_rs1_source[rob_select_first_index]      ;
	select_first_rd_source      = rob_fp_rd_source[rob_select_first_index]       ;
	select_first_rounding_mode  = rob_op_rounding_mode[rob_select_first_index]   ;
	select_first_fmt            = rob_op_fmt[rob_select_first_index]	     ;
        select_first_pc             = rob_op_pc[rob_select_first_index]              ;
        select_first_next_pc        = rob_op_next_pc[rob_select_first_index]         ;
        select_first_predict_pc     = rob_op_predict_pc[rob_select_first_index]      ;
        select_first_imm            = rob_op_imm_data[rob_select_first_index]        ;
        select_first_select_a       = rob_op_alu_select_a[rob_select_first_index]    ;
        select_first_select_b       = rob_op_alu_select_b[rob_select_first_index]    ;
	select_first_select_c       = rob_op_falu_select_c[rob_select_first_index]   ;
        preg_prs1_address_first     = rob_prs1[rob_select_first_index]               ;
        preg_prs2_address_first     = rob_prs2[rob_select_first_index]               ;
	preg_prs3_address_first     = rob_prs3[rob_select_first_index]               ;
        fp_preg_prs1_address_first  = rob_prs1[rob_select_first_index]               ;
        fp_preg_prs2_address_first  = rob_prs2[rob_select_first_index]               ;
	fp_preg_prs3_address_first  = rob_prs3[rob_select_first_index]               ;
        select_first_is_alu         = rob_op_is_alu[rob_select_first_index]          ;
	select_first_is_falu        = rob_op_is_falu[rob_select_first_index]	     ;
        select_first_jump           = rob_op_alu_jump[rob_select_first_index]        ;
        select_first_branch         = rob_op_alu_branch[rob_select_first_index]      ;
        select_first_half           = rob_op_half[rob_select_first_index]            ;
	select_first_is_float       = rob_op_is_float[rob_select_first_index]	     ;
        select_first_func_modifier  = rob_op_alu_modify[rob_select_first_index]      ;
        select_first_is_md          = rob_op_is_md[rob_select_first_index]           ;
	select_first_is_fdivsqrt    = rob_op_is_fdivsqrt[rob_select_first_index]     ;
        select_first_md_op          = rob_op_func3[rob_select_first_index]           ;
	select_first_fdivsqrt_op    = rob_op_func5[rob_select_first_index]           ;
        select_first_is_load        = rob_op_is_load[rob_select_first_index]         ;
        select_first_is_store       = rob_op_is_store[rob_select_first_index]        ;
        select_first_ld_opcode      = rob_op_ldu_op[rob_select_first_index]          ;
        select_first_st_opcode      = rob_op_stu_op[rob_select_first_index]          ;
        select_first_lsu_fence      = rob_op_is_fence[rob_select_first_index]        ;
        select_first_lsu_fence_op   = rob_op_fence_op[rob_select_first_index]        ;
        select_first_aext           = rob_op_aext[rob_select_first_index]            ;
        select_first_aq             = rob_op_aq[rob_select_first_index]              ;
        select_first_rl             = rob_op_rl[rob_select_first_index]              ;
        select_is_csr               = rob_op_is_csr[rob_select_first_index]          ;
        select_csr_address          = rob_op_csr_address[rob_select_first_index]     ;
        select_do_csr_read          = rob_op_csr_read[rob_select_first_index]        ;
        select_do_csr_write         = rob_op_csr_write[rob_select_first_index]       ;
    end else if(rob_select_second_valid) begin
        select_first_rob_index      = rob_select_second_index                         ;
        select_first_prd_address    = rob_prd[rob_select_second_index]                ;
        select_first_func3          = rob_op_func3[rob_select_second_index]           ;
	select_first_func5          = rob_op_func5[rob_select_second_index]           ;
	select_first_rs1_source     = rob_fp_rs1_source[rob_select_second_index]      ;
	select_first_rd_source	    = rob_fp_rd_source[rob_select_second_index]       ;
	select_first_rounding_mode  = rob_op_rounding_mode[rob_select_second_index]   ;
	select_first_fmt            = rob_op_fmt[rob_select_second_index]	      ;
        select_first_pc             = rob_op_pc[rob_select_second_index]              ;
        select_first_next_pc        = rob_op_next_pc[rob_select_second_index]         ;
        select_first_predict_pc     = rob_op_predict_pc[rob_select_second_index]      ;
        select_first_imm            = rob_op_imm_data[rob_select_second_index]        ;
        select_first_select_a       = rob_op_alu_select_a[rob_select_second_index]    ;
        select_first_select_b       = rob_op_alu_select_b[rob_select_second_index]    ;
	select_first_select_c       = rob_op_falu_select_c[rob_select_second_index]    ;
        preg_prs1_address_first     = rob_prs1[rob_select_second_index]               ;
        preg_prs2_address_first     = rob_prs2[rob_select_second_index]               ;
	preg_prs3_address_first     = rob_prs3[rob_select_second_index]               ;
        fp_preg_prs1_address_first  = rob_prs1[rob_select_second_index]               ;
        fp_preg_prs2_address_first  = rob_prs2[rob_select_second_index]               ;
	fp_preg_prs3_address_first  = rob_prs3[rob_select_second_index]               ;
        select_first_is_alu         = rob_op_is_alu[rob_select_second_index]          ;
	select_first_is_falu        = rob_op_is_falu[rob_select_second_index]         ;
        select_first_jump           = rob_op_alu_jump[rob_select_second_index]        ;
        select_first_branch         = rob_op_alu_branch[rob_select_second_index]      ;
        select_first_half           = rob_op_half[rob_select_second_index]            ;
	select_first_is_float       = rob_op_is_float[rob_select_second_index]	      ;
        select_first_func_modifier  = rob_op_alu_modify[rob_select_second_index]      ;
        select_first_is_md          = rob_op_is_md[rob_select_second_index]           ;
	select_first_is_fdivsqrt    = rob_op_is_fdivsqrt[rob_select_second_index]     ;
        select_first_md_op          = rob_op_func3[rob_select_second_index]           ;
	select_first_fdivsqrt_op    = rob_op_func5[rob_select_second_index]           ;
        select_first_is_load        = rob_op_is_load[rob_select_second_index]         ;
        select_first_is_store       = rob_op_is_store[rob_select_second_index]        ;
        select_first_ld_opcode      = rob_op_ldu_op[rob_select_second_index]          ;
        select_first_st_opcode      = rob_op_stu_op[rob_select_second_index]          ;
        select_first_lsu_fence      = rob_op_is_fence[rob_select_second_index]        ;
        select_first_lsu_fence_op   = rob_op_fence_op[rob_select_second_index]        ;
        select_first_aext           = rob_op_aext[rob_select_second_index]            ;
        select_first_aq             = rob_op_aq[rob_select_second_index]              ;
        select_first_rl             = rob_op_rl[rob_select_second_index]              ;
        select_csr_address          = rob_op_csr_address[rob_select_second_index]     ;
        select_do_csr_read          = rob_op_csr_read[rob_select_second_index]        ;
        select_do_csr_write         = rob_op_csr_write[rob_select_second_index]       ;
    end else if(bypass_select_first_valid) begin
        select_first_rob_index      = wr_rob_index_first              ;
        select_first_prd_address    = rd_source_first ? fp_prd_first : prd_first;
        select_first_func3          = fu_function_first_i             ;
	select_first_func5          = fu_float_function_first_i       ;
	select_first_rs1_source     = rs1_source_first		      ;
	select_first_rd_source      = rd_source_first		      ;
	select_first_rounding_mode  = fu_float_rounding_mode_first_i  ;
	select_first_fmt            = fu_float_fmt_first_i            ;
        select_first_pc             = pc_first_i                      ;
        select_first_next_pc        = next_pc_first_i                 ;
        select_first_predict_pc     = predict_pc_first_i              ;
        select_first_imm            = imm_data_first_i                ;
        select_first_select_a       = fu_select_a_first_i             ;
        select_first_select_b       = fu_select_b_first_i             ;
	select_first_select_c       = fu_select_c_first_i             ;
        preg_prs1_address_first     = prs1_first                      ;
        preg_prs2_address_first     = prs2_first                      ;
	preg_prs3_address_first     = prs3_first                      ;
        fp_preg_prs1_address_first  = fp_prs1_first               ;
        fp_preg_prs2_address_first  = fp_prs2_first               ;
	fp_preg_prs3_address_first  = fp_prs3_first               ;
        select_first_is_alu         = is_alu_first_i                  ;
	select_first_is_falu        = is_falu_first_i                 ;
        select_first_jump           = jump_first_i                    ;
        select_first_branch         = branch_first_i                  ;
        select_first_half           = half_first_i                    ;
	select_first_is_float       = is_float_first_i		      ;
        select_first_func_modifier  = alu_function_modifier_first_i   ;
        select_first_is_md          = is_mext_first_i                 ;
	select_first_is_fdivsqrt    = is_fdivsqrt_first_i	      ;
        select_first_md_op          = fu_function_first_i             ;
	select_first_fdivsqrt_op    = fu_float_function_first_i       ;
        select_first_is_load        = load_first_i                    ;
        select_first_is_store       = store_first_i                   ;
        select_first_ld_opcode      = ldu_op_first_i                  ;
        select_first_st_opcode      = stu_op_first_i                  ;
        select_first_lsu_fence      = is_fence_first_i                ;
        select_first_lsu_fence_op   = fence_op_first_i                ;
        select_first_aext           = is_aext_first_i                 ;
        select_first_aq             = aq_first_i                      ;
        select_first_rl             = rl_first_i                      ;
        select_is_csr               = csr_read_first_i | csr_write_first_i;
        select_csr_address          = csr_address_first_i             ;
        select_do_csr_read          = csr_read_first_i                ;
        select_do_csr_write         = csr_write_first_i               ;
    end else if(bypass_select_second_valid) begin
        select_first_rob_index      = wr_rob_index_second              ;
        select_first_prd_address    = rd_source_second ? fp_prd_second : prd_second                       ;
        select_first_func3          = fu_function_second_i             ;
	select_first_func5          = fu_float_function_second_i       ;
	select_first_rs1_source     = rs1_source_second		       ;
	select_first_rd_source      = rd_source_second		       ;
	select_first_rounding_mode  = fu_float_rounding_mode_second_i  ;
	select_first_fmt            = fu_float_fmt_second_i	       ;
        select_first_pc             = pc_second_i                      ;
        select_first_next_pc        = next_pc_second_i                 ;
        select_first_predict_pc     = predict_pc_second_i              ;
        select_first_imm            = imm_data_second_i                ;
        select_first_select_a       = fu_select_a_second_i             ;
        select_first_select_b       = fu_select_b_second_i             ;
	select_first_select_c       = fu_select_c_second_i             ;
        preg_prs1_address_first     = prs1_second                      ;
        preg_prs2_address_first     = prs2_second                      ;
	preg_prs3_address_first     = prs3_second		       ;
        fp_preg_prs1_address_first  = fp_prs1_second               ;
        fp_preg_prs2_address_first  = fp_prs2_second               ;
	fp_preg_prs3_address_first  = fp_prs3_second               ;
        select_first_is_alu         = is_alu_second_i                  ;
	select_first_is_falu        = is_falu_second_i		       ;
        select_first_jump           = jump_second_i                    ;
        select_first_branch         = branch_second_i                  ;
        select_first_half           = half_second_i                    ;
	select_first_is_float       = is_float_second_i		       ;
        select_first_func_modifier  = alu_function_modifier_second_i   ;
        select_first_is_md          = is_mext_second_i                 ;
	select_first_is_fdivsqrt    = is_fdivsqrt_second_i  	       ;
        select_first_md_op          = fu_function_second_i             ;
	select_first_fdivsqrt_op    = fu_float_function_second_i       ;
        select_first_is_load        = load_second_i                    ;
        select_first_is_store       = store_second_i                   ;
        select_first_ld_opcode      = ldu_op_second_i                  ;
        select_first_st_opcode      = stu_op_second_i                  ;
        select_first_lsu_fence      = is_fence_second_i                ;
        select_first_lsu_fence_op   = fence_op_second_i                ;
        select_first_aext           = is_aext_second_i                 ;
        select_first_aq             = aq_second_i                      ;
        select_first_rl             = rl_second_i                      ;
        select_is_csr               = csr_read_second_i | csr_write_second_i;
        select_csr_address          = csr_address_second_i             ;
        select_do_csr_read          = csr_read_second_i                ;
        select_do_csr_write         = csr_write_second_i               ;
    end else begin
        select_first_rob_index      = 0;
        select_first_prd_address    = 0;
        select_first_func3          = 0;
	select_first_func5          = 0;
	select_first_rs1_source     = 0;
	select_first_rd_source      = 0;
	select_first_rounding_mode  = 0;
	select_first_fmt            = 0;
        select_first_pc             = 0;
        select_first_next_pc        = 0;
        select_first_predict_pc     = 0;
        select_first_imm            = 0;
        select_first_select_a       = 0;
        select_first_select_b       = 0;
	select_first_select_c       = 0;
        preg_prs1_address_first     = 0;
        preg_prs2_address_first     = 0;
	preg_prs3_address_first     = 0;
        fp_preg_prs1_address_first  = 0               ;
        fp_preg_prs2_address_first  = 0               ;
	fp_preg_prs3_address_first  = 0               ;
        select_first_is_alu         = 0;
	select_first_is_falu        = 0;
        select_first_jump           = 0;
        select_first_branch         = 0;
        select_first_half           = 0;
	select_first_is_float       = 0;
        select_first_func_modifier  = 0;
        select_first_is_md          = 0;
	select_first_is_fdivsqrt    = 0;
        select_first_md_op          = 0;
	select_first_fdivsqrt_op    = 0;
        select_first_is_load        = 0;
        select_first_is_store       = 0;
        select_first_ld_opcode      = 0;
        select_first_st_opcode      = 0;
        select_first_lsu_fence      = 0;
        select_first_lsu_fence_op   = 0;
        select_first_aext           = 0;
        select_first_aq             = 0;
        select_first_rl             = 0;
        select_is_csr               = 0;
        select_csr_address          = 0;
        select_do_csr_read          = 0;
        select_do_csr_write         = 0;
    end
end
//second issue port
always @(*) begin 
    if(bypass_select_second_valid) begin //read preg
        select_second_rob_index      = wr_rob_index_second              ;
        select_second_prd_address    = rd_source_second ? fp_prd_second : prd_second                       ;
        select_second_func3          = fu_function_second_i             ;
	select_second_func5          = fu_float_function_second_i        ;
	select_second_rs1_source     = rs1_source_second		  ;
	select_second_rd_source      = rd_source_second			;
	select_second_rounding_mode  = fu_float_rounding_mode_second_i   ;
	select_second_fmt            = fu_float_fmt_second_i             ;
        select_second_pc             = pc_second_i                      ;
        select_second_next_pc        = next_pc_second_i                 ;
        select_second_predict_pc     = predict_pc_second_i              ;
        select_second_imm            = imm_data_second_i                ;
        select_second_select_a       = fu_select_a_second_i             ;
        select_second_select_b       = fu_select_b_second_i             ;
	select_second_select_c       = fu_select_c_second_i		;
        preg_prs1_address_second     = prs1_second                      ;
        preg_prs2_address_second     = prs2_second                      ;
	preg_prs3_address_second     = prs3_second			;
        fp_preg_prs1_address_second     = fp_prs1_second                      ;
        fp_preg_prs2_address_second     = fp_prs2_second                      ;
	fp_preg_prs3_address_second     = fp_prs3_second			;
        select_second_is_alu         = is_alu_second_i                  ;
	select_second_is_falu        = is_falu_second_i			;
        select_second_jump           = jump_second_i                    ;
        select_second_branch         = branch_second_i                  ;
        select_second_half           = half_second_i                    ;
	select_second_is_float       = is_float_second_i		;
        select_second_func_modifier  = alu_function_modifier_second_i   ;
        select_second_is_md          = is_mext_second_i                 ;
	select_second_is_fdivsqrt    = is_fdivsqrt_second_i             ;
        select_second_md_op          = fu_function_second_i             ;
	select_second_fdivsqrt_op    = fu_float_function_second_i       ;
        select_second_is_load        = load_second_i                    ;
        select_second_is_store       = store_second_i                   ;
        select_second_ld_opcode      = ldu_op_second_i                  ;
        select_second_st_opcode      = stu_op_second_i                  ;
        select_second_lsu_fence      = is_fence_second_i                ;
        select_second_lsu_fence_op   = fence_op_second_i                ;
        select_second_aext           = is_aext_second_i                 ;
        select_second_aq             = aq_second_i                      ;
        select_second_rl             = rl_second_i                      ;
    end else if(bypass_select_first_valid) begin
        select_second_rob_index      = wr_rob_index_first              ;
        select_second_prd_address    = rd_source_first ? fp_prd_first : prd_first                       ;
        select_second_func3          = fu_function_first_i             ;
	select_second_func5          = fu_float_function_first_i       ;
	select_second_rs1_source     = rs1_source_first		       ;
	select_second_rd_source	     = rd_source_first			;
	select_second_rounding_mode  = fu_float_rounding_mode_first_i  ;
	select_second_fmt            = fu_float_fmt_first_i            ;
        select_second_pc             = pc_first_i                      ;
        select_second_next_pc        = next_pc_first_i                 ;
        select_second_predict_pc     = predict_pc_first_i              ;
        select_second_imm            = imm_data_first_i                ;
        select_second_select_a       = fu_select_a_first_i             ;
        select_second_select_b       = fu_select_b_first_i             ;
	select_second_select_c       = fu_select_c_first_i	       ;
        preg_prs1_address_second     = prs1_first                      ;
        preg_prs2_address_second     = prs2_first                      ;
	preg_prs3_address_second     = prs3_first                      ;
        fp_preg_prs1_address_second     = fp_prs1_first                      ;
        fp_preg_prs2_address_second     = fp_prs2_first                      ;
	fp_preg_prs3_address_second     = fp_prs3_first                      ;
        select_second_is_alu         = is_alu_first_i                  ;
	select_second_is_falu        = is_falu_first_i                 ;
        select_second_jump           = jump_first_i                    ;
        select_second_branch         = branch_first_i                  ;
        select_second_half           = half_first_i                    ;
	select_second_is_float       = is_float_first_i               ;
        select_second_func_modifier  = alu_function_modifier_first_i   ;
        select_second_is_md          = is_mext_first_i                 ;
	select_second_is_fdivsqrt    = is_fdivsqrt_first_i             ;
        select_second_md_op          = fu_function_first_i             ;
	select_second_fdivsqrt_op    = fu_float_function_first_i       ;
        select_second_is_load        = load_first_i                    ;
        select_second_is_store       = store_first_i                   ;
        select_second_ld_opcode      = ldu_op_first_i                  ;
        select_second_st_opcode      = stu_op_first_i                  ;
        select_second_lsu_fence      = is_fence_first_i                ;
        select_second_lsu_fence_op   = fence_op_first_i                ;
        select_second_aext           = is_aext_first_i                 ;
        select_second_aq             = aq_first_i                      ;
        select_second_rl             = rl_first_i                      ;
    end else if(rob_select_second_valid) begin
        select_second_rob_index      = rob_select_second_index                         ;
        select_second_prd_address    = rob_prd[rob_select_second_index]                ;
        select_second_func3          = rob_op_func3[rob_select_second_index]           ;
	select_second_func5          = rob_op_func5[rob_select_second_index]	       ;
	select_second_rs1_source     = rob_fp_rs1_source[rob_select_second_index]      ;
	select_second_rd_source      = rob_fp_rd_source[rob_select_second_index]       ;
	select_second_rounding_mode  = rob_op_rounding_mode[rob_select_second_index]   ;
	select_second_fmt            = rob_op_fmt[rob_select_second_index]             ;
        select_second_pc             = rob_op_pc[rob_select_second_index]              ;
        select_second_next_pc        = rob_op_next_pc[rob_select_second_index]         ;
        select_second_predict_pc     = rob_op_predict_pc[rob_select_second_index]      ;
        select_second_imm            = rob_op_imm_data[rob_select_second_index]        ;
        select_second_select_a       = rob_op_alu_select_a[rob_select_second_index]    ;
        select_second_select_b       = rob_op_alu_select_b[rob_select_second_index]    ;
	select_second_select_c       = rob_op_falu_select_c[rob_select_second_index]   ;
        preg_prs1_address_second     = rob_prs1[rob_select_second_index]               ;
        preg_prs2_address_second     = rob_prs2[rob_select_second_index]               ;
	preg_prs3_address_second     = rob_prs3[rob_select_second_index]               ;
        fp_preg_prs1_address_second     = rob_prs1[rob_select_second_index]               ;
        fp_preg_prs2_address_second     = rob_prs2[rob_select_second_index]               ;
	fp_preg_prs3_address_second     = rob_prs3[rob_select_second_index]               ;
        select_second_is_alu         = rob_op_is_alu[rob_select_second_index]          ;
	select_second_is_falu        = rob_op_is_falu[rob_select_second_index]         ;
        select_second_jump           = rob_op_alu_jump[rob_select_second_index]        ;
        select_second_branch         = rob_op_alu_branch[rob_select_second_index]      ;
        select_second_half           = rob_op_half[rob_select_second_index]            ;
	select_second_is_float       = rob_op_is_float[rob_select_second_index]	       ;
        select_second_func_modifier  = rob_op_alu_modify[rob_select_second_index]      ;
        select_second_is_md          = rob_op_is_md[rob_select_second_index]           ;
	select_second_is_fdivsqrt    = rob_op_is_fdivsqrt[rob_select_second_index]     ;
        select_second_md_op          = rob_op_func3[rob_select_second_index]           ;
	select_second_fdivsqrt_op    = rob_op_func5[rob_select_second_index]           ;
        select_second_is_load        = rob_op_is_load[rob_select_second_index]         ;
        select_second_is_store       = rob_op_is_store[rob_select_second_index]        ;
        select_second_ld_opcode      = rob_op_ldu_op[rob_select_second_index]          ;
        select_second_st_opcode      = rob_op_stu_op[rob_select_second_index]          ;
        select_second_lsu_fence      = rob_op_is_fence[rob_select_second_index]        ;
        select_second_lsu_fence_op   = rob_op_fence_op[rob_select_second_index]        ;
        select_second_aext           = rob_op_aext[rob_select_second_index]            ;
        select_second_aq             = rob_op_aq[rob_select_second_index]              ;
        select_second_rl             = rob_op_rl[rob_select_second_index]              ;
    end else if(rob_select_first_valid) begin
        select_second_rob_index      = rob_select_first_index                         ;
        select_second_prd_address    = rob_prd[rob_select_first_index]                ;
        select_second_func3          = rob_op_func3[rob_select_first_index]           ;
	select_second_func5          = rob_op_func5[rob_select_first_index]           ;
	select_second_rs1_source     = rob_fp_rs1_source[rob_select_first_index]      ;
	select_second_rd_source	     = rob_fp_rd_source[rob_select_first_index]	      ;
	select_second_rounding_mode  = rob_op_rounding_mode[rob_select_first_index]   ;
	select_second_fmt            = rob_op_fmt[rob_select_first_index]             ;
        select_second_pc             = rob_op_pc[rob_select_first_index]              ;
        select_second_next_pc        = rob_op_next_pc[rob_select_first_index]         ;
        select_second_predict_pc     = rob_op_predict_pc[rob_select_first_index]      ;
        select_second_imm            = rob_op_imm_data[rob_select_first_index]        ;
        select_second_select_a       = rob_op_alu_select_a[rob_select_first_index]    ;
        select_second_select_b       = rob_op_alu_select_b[rob_select_first_index]    ;
	select_second_select_c       = rob_op_falu_select_c[rob_select_first_index]   ;
        preg_prs1_address_second     = rob_prs1[rob_select_first_index]               ;
        preg_prs2_address_second     = rob_prs2[rob_select_first_index]               ;
	preg_prs3_address_second     = rob_prs3[rob_select_first_index]               ;
        fp_preg_prs1_address_second     = rob_prs1[rob_select_first_index]               ;
        fp_preg_prs2_address_second     = rob_prs2[rob_select_first_index]               ;
	fp_preg_prs3_address_second     = rob_prs3[rob_select_first_index]               ;
        select_second_is_alu         = rob_op_is_alu[rob_select_first_index]          ;
	select_second_is_falu        = rob_op_is_falu[rob_select_first_index]         ;
        select_second_jump           = rob_op_alu_jump[rob_select_first_index]        ;
        select_second_branch         = rob_op_alu_branch[rob_select_first_index]      ;
        select_second_half           = rob_op_half[rob_select_first_index]            ;
	select_second_is_float       = rob_op_is_float[rob_select_first_index]        ;
        select_second_func_modifier  = rob_op_alu_modify[rob_select_first_index]      ;
        select_second_is_md          = rob_op_is_md[rob_select_first_index]           ;
	select_second_is_fdivsqrt    = rob_op_is_fdivsqrt[rob_select_first_index]     ;
        select_second_md_op          = rob_op_func3[rob_select_first_index]           ;
	select_second_fdivsqrt_op    = rob_op_func5[rob_select_first_index]           ;
        select_second_is_load        = rob_op_is_load[rob_select_first_index]         ;
        select_second_is_store       = rob_op_is_store[rob_select_first_index]        ;
        select_second_ld_opcode      = rob_op_ldu_op[rob_select_first_index]          ;
        select_second_st_opcode      = rob_op_stu_op[rob_select_first_index]          ;
        select_second_lsu_fence      = rob_op_is_fence[rob_select_first_index]        ;
        select_second_lsu_fence_op   = rob_op_fence_op[rob_select_first_index]        ;
        select_second_aext           = rob_op_aext[rob_select_first_index]            ;
        select_second_aq             = rob_op_aq[rob_select_first_index]              ;
        select_second_rl             = rob_op_rl[rob_select_first_index]              ;
    end else begin
        select_second_rob_index      = 0;
        select_second_prd_address    = 0;
        select_second_func3          = 0;
	select_second_func5          = 0;
	select_second_rs1_source     = 0;
	select_second_rd_source	     = 0;
	select_second_rounding_mode  = 0;
	select_second_fmt            = 0;
        select_second_pc             = 0;
        select_second_next_pc        = 0;
        select_second_predict_pc     = 0;
        select_second_imm            = 0;
        select_second_select_a       = 0;
        select_second_select_b       = 0;
	select_second_select_c       = 0;
        preg_prs1_address_second     = 0;
        preg_prs2_address_second     = 0;
	preg_prs3_address_second     = 0;
        fp_preg_prs1_address_second     = 0;
        fp_preg_prs2_address_second     = 0;
	fp_preg_prs3_address_second     = 0;
        select_second_is_alu         = 0;
	select_second_is_falu        = 0;
        select_second_jump           = 0;
        select_second_branch         = 0;
        select_second_half           = 0;
	select_second_is_float       = 0;
        select_second_func_modifier  = 0;
        select_second_is_md          = 0;
	select_second_is_fdivsqrt    = 0;
        select_second_md_op          = 0;
	select_second_fdivsqrt_op    = 0;
        select_second_is_load        = 0;
        select_second_is_store       = 0;
        select_second_ld_opcode      = 0;
        select_second_st_opcode      = 0;
        select_second_lsu_fence      = 0;
        select_second_lsu_fence_op   = 0;
        select_second_aext           = 0;
        select_second_aq             = 0;
        select_second_rl             = 0;
    end
end
assign compress_select_first_valid = bypass_select_first_valid | bypass_select_second_valid | rob_select_first_valid | rob_select_second_valid;
assign compress_select_second_valid = !(bypass_select_first_valid ^ bypass_select_second_valid ^ rob_select_first_valid ^ rob_select_second_valid) & compress_select_first_valid;
// : issue signal gen

//alu1 pipeline reg
always @(posedge clk) begin
    alu1_valid <= compress_select_first_valid & select_first_is_alu & !select_is_csr & !rst & !global_speculate_fault;                        
    if (compress_select_first_valid & select_first_is_alu & !select_is_csr) begin
        alu1_rob_index     <= select_first_rob_index         ;                                      
        alu1_prd_address   <= select_first_prd_address       ;                                        
        alu1_func          <= select_first_func3             ;                                                           
        alu1_pc            <= select_first_pc                ;                               
        alu1_next_pc       <= select_first_next_pc           ;                                           
        alu1_predict_pc    <= select_first_predict_pc        ;                                           
        alu1_imm           <= select_first_imm               ;       
        alu1_select_a      <= select_first_select_a          ;                                     
        alu1_select_b      <= select_first_select_b          ;                   
        alu1_rs1_data      <= select_first_rs1_data          ;                                                                   
        alu1_rs2_data      <= select_first_rs2_data          ;                                                                 
        alu1_jump          <= select_first_jump              ;               
        alu1_branch        <= select_first_branch            ;                 
        alu1_half          <= select_first_half              ;               
        alu1_func_modifier <= select_first_func_modifier     ;                        
    end 
end
assign rcu_alu1_req_valid_o     = alu1_valid           ;
assign rcu_alu1_rob_index_o     = alu1_rob_index       ;
assign rcu_alu1_prd_address_o   = alu1_prd_address     ;
assign rcu_alu1_func3_o         = alu1_func            ;
assign rcu_alu1_pc_o            = alu1_pc              ;
assign rcu_alu1_next_pc_o       = alu1_next_pc         ;
assign rcu_alu1_predict_pc_o    = alu1_predict_pc      ;
assign rcu_alu1_imm_data_o      = alu1_imm             ;
assign rcu_alu1_select_a_o      = alu1_select_a        ;
assign rcu_alu1_select_b_o      = alu1_select_b        ;
assign rcu_alu1_rs1_data_o      = alu1_rs1_data        ;
assign rcu_alu1_rs2_data_o      = alu1_rs2_data        ;
assign rcu_alu1_jump_o          = alu1_jump            ;
assign rcu_alu1_branch_o        = alu1_branch          ;
assign rcu_alu1_half_o          = alu1_half            ;
assign rcu_alu1_func_modifier_o = alu1_func_modifier   ;
//: alu1 pipeline reg

//alu2 pipeline reg
always @(posedge clk) begin
    alu2_valid <= compress_select_second_valid & select_second_is_alu & !rst & !global_speculate_fault;;
    if (compress_select_second_valid & select_second_is_alu) begin
        alu2_rob_index     <= select_second_rob_index        ;        
        alu2_prd_address   <= select_second_prd_address      ;        
        alu2_func          <= select_second_func3            ;        
        alu2_pc            <= select_second_pc               ;        
        alu2_next_pc       <= select_second_next_pc          ;        
        alu2_predict_pc    <= select_second_predict_pc       ;        
        alu2_imm           <= select_second_imm              ;               
        alu2_select_a      <= select_second_select_a         ;        
        alu2_select_b      <= select_second_select_b         ;        
        alu2_rs1_data      <= select_second_rs1_data         ;        
        alu2_rs2_data      <= select_second_rs2_data         ;        
        alu2_jump          <= select_second_jump             ;        
        alu2_branch        <= select_second_branch           ;        
        alu2_half          <= select_second_half             ;        
        alu2_func_modifier <= select_second_func_modifier    ;        
    end 
end
assign rcu_alu2_req_valid_o     = alu2_valid           ;
assign rcu_alu2_rob_index_o     = alu2_rob_index       ;
assign rcu_alu2_prd_address_o   = alu2_prd_address     ;
assign rcu_alu2_func3_o         = alu2_func            ;
assign rcu_alu2_pc_o            = alu2_pc              ;
assign rcu_alu2_next_pc_o       = alu2_next_pc         ;
assign rcu_alu2_predict_pc_o    = alu2_predict_pc      ;
assign rcu_alu2_imm_data_o      = alu2_imm             ;
assign rcu_alu2_select_a_o      = alu2_select_a        ;
assign rcu_alu2_select_b_o      = alu2_select_b        ;
assign rcu_alu2_rs1_data_o      = alu2_rs1_data        ;
assign rcu_alu2_rs2_data_o      = alu2_rs2_data        ;
assign rcu_alu2_jump_o          = alu2_jump            ;
assign rcu_alu2_branch_o        = alu2_branch          ;
assign rcu_alu2_half_o          = alu2_half            ;
assign rcu_alu2_func_modifier_o = alu2_func_modifier   ;
//: alu2 pipeline reg

//falu1 pipeline reg
always @(posedge clk) begin
    falu1_valid <= compress_select_first_valid & select_first_is_falu & !rst & !global_speculate_fault;                        
    if (compress_select_first_valid & select_first_is_falu) begin
	falu1_rob_index <= select_first_rob_index;
	falu1_prd_address <= select_first_prd_address;
	falu1_func <= select_first_func5;
	falu1_rounding_mode <= select_first_rounding_mode;
	falu1_fmt <= select_first_fmt;
	falu1_select_a <= select_first_select_a;
	falu1_select_b <= select_first_select_b;
	falu1_select_c <= select_first_select_c;
	falu1_rs1_data <= select_first_rs1_data;
	falu1_rs2_data <= select_first_rs2_data;
	falu1_rs3_data <= select_first_rs3_data;
    end 
end
assign rcu_falu1_req_valid_o     = falu1_valid           ;
assign rcu_falu1_rob_index_o     = falu1_rob_index       ;
assign rcu_falu1_prd_address_o   = falu1_prd_address     ;
assign rcu_falu1_func5_o         = falu1_func            ;
assign rcu_falu1_rounding_mode_o = falu1_rounding_mode   ;
assign rcu_falu1_fmt_o           = falu1_fmt             ;
assign rcu_falu1_select_a_o      = falu1_select_a        ;
assign rcu_falu1_select_b_o      = falu1_select_b        ;
assign rcu_falu1_select_c_o      = falu1_select_c        ;
assign rcu_falu1_rs1_data_o      = falu1_rs1_data        ;
assign rcu_falu1_rs2_data_o      = falu1_rs2_data        ;
assign rcu_falu1_rs3_data_o      = falu1_rs3_data        ;
//: falu1 pipeline reg

//falu2 pipeline reg
always @(posedge clk) begin
    falu2_valid <= compress_select_second_valid & select_second_is_falu & !rst & !global_speculate_fault;                        
    if (compress_select_second_valid & select_second_is_falu) begin
	falu2_rob_index <= select_second_rob_index;
	falu2_prd_address <= select_second_prd_address;
	falu2_func <= select_second_func5;
	falu2_rounding_mode <= select_second_rounding_mode;
	falu2_fmt <= select_second_fmt;
	falu2_select_a <= select_second_select_a;
	falu2_select_b <= select_second_select_b;
	falu2_select_c <= select_second_select_c;
	falu2_rs1_data <= select_second_rs1_data;
	falu2_rs2_data <= select_second_rs2_data;
	falu2_rs3_data <= select_second_rs3_data;
    end 
end
assign rcu_falu2_req_valid_o     = falu2_valid           ;
assign rcu_falu2_rob_index_o     = falu2_rob_index       ;
assign rcu_falu2_prd_address_o   = falu2_prd_address     ;
assign rcu_falu2_func5_o         = falu2_func            ;
assign rcu_falu2_rounding_mode_o = falu2_rounding_mode   ;
assign rcu_falu2_fmt_o           = falu2_fmt             ;
assign rcu_falu2_select_a_o      = falu2_select_a        ;
assign rcu_falu2_select_b_o      = falu2_select_b        ;
assign rcu_falu2_select_c_o      = falu2_select_c        ;
assign rcu_falu2_rs1_data_o      = falu2_rs1_data        ;
assign rcu_falu2_rs2_data_o      = falu2_rs2_data        ;
assign rcu_falu2_rs3_data_o      = falu2_rs3_data        ;
//: falu2 pipeline reg
//md queue
f2if2o #(
    .FIFO_DATA_WIDTH(MD_DATA_WIDTH),
    .FIFO_SIZE(MD_QUEUE_DEPTH),
    .FIFO_SIZE_WIDTH(MD_QUEUE_DEPTH_WIDTH)
) md_queue(
    .clk(clk)                                   ,
    .rst(rst | global_speculate_fault)          ,
    .wr_first_en_i(mdq_wr_first_en)             ,
    .wr_second_en_i(mdq_wr_second_en)           ,
    .rd_first_en_i(mdq_rd_first_en)             ,
    .rd_second_en_i(mdq_rd_second_en)           ,
    .wdata_first_i(mdq_wrdata_first)            ,
    .wdata_second_i(mdq_wrdata_second)          ,
    .rdata_first_o(mdq_rdata_first)             ,
    .rdata_second_o(mdq_rdata_second)           ,
    .fifo_full_o(mdq_full)                      ,
    .fifo_almost_full_o(mdq_almost_full)        ,
    .fifo_empty_o(mdq_empty)                    ,
    .fifo_almost_empty_o(mdq_almost_empty)      ,
    .fifo_num_o(mdq_fifo_num)                   
);
assign mdq_do_first_write = compress_select_first_valid & select_first_is_md    ;
assign mdq_do_second_write = compress_select_second_valid & select_second_is_md ;
assign mdq_wr_first_en = (mdq_do_first_write ^ mdq_do_second_write) ? !mdq_full
                                                             : mdq_do_first_write & !mdq_full;       
assign mdq_wr_second_en = (mdq_do_first_write ^ mdq_do_second_write) ? 1'b0
                                                             : mdq_do_first_write & !mdq_almost_full;
assign mdq_do_wdata_first = {select_first_rob_index,
                           select_first_prd_address,
                           select_first_rs1_data,
                           select_first_rs2_data,
                           select_first_func3,
                           select_first_half
                           };
assign mdq_do_wdata_second = {select_second_rob_index,
                            select_second_prd_address,
                            select_second_rs1_data,
                            select_second_rs2_data,
                            select_second_func3,
                            select_second_half
                            };
assign mdq_wrdata_first = mdq_do_first_write ? mdq_do_wdata_first : mdq_do_wdata_second;
assign mdq_wrdata_second = mdq_wr_second_en ? mdq_do_wdata_second : 0;
assign mdq_do_first_read = rcu_md_req_ready_i;
assign rcu_md_req_valid_o = !mdq_empty;
assign mdq_rd_first_en = mdq_do_first_read & !mdq_empty;
assign mdq_rd_second_en = 1'b0;
assign rcu_md_package_o = mdq_rdata_first;
//: md queue

//fdivsqrt queue
f2if2o #(
    .FIFO_DATA_WIDTH(FDIVSQRT_DATA_WIDTH),
    .FIFO_SIZE(FDIVSQRT_QUEUE_DEPTH),
    .FIFO_SIZE_WIDTH(FDIVSQRT_QUEUE_DEPTH_WIDTH)
) fdivsqrt_queue(
    .clk(clk)                                   ,
    .rst(rst | global_speculate_fault)          ,
    .wr_first_en_i(fdivsqrtq_wr_first_en)             ,
    .wr_second_en_i(fdivsqrtq_wr_second_en)           ,
    .rd_first_en_i(fdivsqrtq_rd_first_en)             ,
    .rd_second_en_i(fdivsqrtq_rd_second_en)           ,
    .wdata_first_i(fdivsqrtq_wrdata_first)            ,
    .wdata_second_i(fdivsqrtq_wrdata_second)          ,
    .rdata_first_o(fdivsqrtq_rdata_first)             ,
    .rdata_second_o(fdivsqrtq_rdata_second)           ,
    .fifo_full_o(fdivsqrtq_full)                      ,
    .fifo_almost_full_o(fdivsqrtq_almost_full)        ,
    .fifo_empty_o(fdivsqrtq_empty)                    ,
    .fifo_almost_empty_o(fdivsqrtq_almost_empty)      ,
    .fifo_num_o(fdivsqrtq_fifo_num)                   
);
assign fdivsqrtq_do_first_write = compress_select_first_valid & select_first_is_fdivsqrt    ;
assign fdivsqrtq_do_second_write = compress_select_second_valid & select_second_is_fdivsqrt ;
assign fdivsqrtq_wr_first_en = (fdivsqrtq_do_first_write ^ fdivsqrtq_do_second_write) ? !fdivsqrtq_full
                                                             : fdivsqrtq_do_first_write & !fdivsqrtq_full;       
assign fdivsqrtq_wr_second_en = (fdivsqrtq_do_first_write ^ fdivsqrtq_do_second_write) ? 1'b0
                                                             : fdivsqrtq_do_first_write & !fdivsqrtq_almost_full;
assign fdivsqrtq_do_wdata_first = {select_first_rob_index,
                           select_first_prd_address,
                           select_first_rs1_data,
                           select_first_rs2_data,
                           select_first_func5,
			   select_first_rounding_mode,
			   select_first_fmt
                           };
assign fdivsqrtq_do_wdata_second = {select_second_rob_index,
                            select_second_prd_address,
                            select_second_rs1_data,
                            select_second_rs2_data,
                            select_second_func5,
			    select_second_rounding_mode,
			    select_second_fmt
                            };
assign fdivsqrtq_wrdata_first = fdivsqrtq_do_first_write ? fdivsqrtq_do_wdata_first : fdivsqrtq_do_wdata_second;
assign fdivsqrtq_wrdata_second = fdivsqrtq_wr_second_en ? fdivsqrtq_do_wdata_second : 0;
assign fdivsqrtq_do_first_read = rcu_fdivsqrt_req_ready_i;
assign rcu_fdivsqrt_req_valid_o = !fdivsqrtq_empty;
assign fdivsqrtq_rd_first_en = fdivsqrtq_do_first_read & !fdivsqrtq_empty;
assign fdivsqrtq_rd_second_en = 1'b0;
assign rcu_fdivsqrt_package_o = fdivsqrtq_rdata_first;
//: md queue

//lsu queue
f2if2o #(
    .FIFO_DATA_WIDTH(LSU_DATA_WIDTH),
    .FIFO_SIZE(LSU_QUEUE_DEPTH),
    .FIFO_SIZE_WIDTH(LSU_QUEUE_DEPTH_WIDTH)
) lsu_queue(
    .clk(clk)                                     ,
    .rst(rst | global_speculate_fault)            ,
    .wr_first_en_i(lsuq_wr_first_en)              ,
    .wr_second_en_i(lsuq_wr_second_en)            ,
    .rd_first_en_i(lsuq_rd_first_en)              ,
    .rd_second_en_i(lsuq_rd_second_en)            ,
    .wdata_first_i(lsuq_wrdata_first)             ,
    .wdata_second_i(lsuq_wrdata_second)           ,
    .rdata_first_o(lsuq_rdata_first)              ,
    .rdata_second_o(lsuq_rdata_second)            ,
    .fifo_full_o(lsuq_full)                       ,
    .fifo_almost_full_o(lsuq_almost_full)         ,
    .fifo_empty_o(lsuq_empty)                     ,
    .fifo_almost_empty_o(lsuq_almost_empty)       ,
    .fifo_num_o(lsuq_fifo_num)                              
);
assign lsuq_do_first_write = compress_select_first_valid & (select_first_is_load | select_first_is_store);
assign lsuq_do_second_write = compress_select_second_valid & (select_second_is_load | select_second_is_store);
assign lsuq_wr_first_en = (lsuq_do_first_write ^ lsuq_do_second_write) ? !lsuq_full
                                                                         : lsuq_do_first_write & !lsuq_full;       
assign lsuq_wr_second_en = (lsuq_do_first_write ^ lsuq_do_second_write) ? 1'b0
                                                                        : lsuq_do_first_write & !lsuq_almost_full;
assign lsuq_do_wdata_first = {select_first_rob_index,
                    select_first_prd_address,
                    select_first_rs1_data,
                    select_first_rs2_data,
                    select_first_imm,
                    select_first_is_load,
                    select_first_is_store,
		    select_first_is_float,
		    select_first_func5,
                    select_first_ld_opcode,
                    select_first_st_opcode,
                    select_first_lsu_fence,
                    select_first_lsu_fence_op,
                    select_first_aext,
                    select_first_aq,
                    select_first_rl
                    };
assign lsuq_do_wdata_second = {select_second_rob_index,
                    select_second_prd_address,
                    select_second_rs1_data,
                    select_second_rs2_data,
                    select_second_imm,
                    select_second_is_load,
                    select_second_is_store,
		    select_second_is_float,
		    select_second_func5,
                    select_second_ld_opcode,
                    select_second_st_opcode,
                    select_second_lsu_fence,
                    select_second_lsu_fence_op,
                    select_second_aext,
                    select_second_aq,
                    select_second_rl
                    };
assign lsuq_wrdata_first = lsuq_do_first_write ? lsuq_do_wdata_first : lsuq_do_wdata_second;
assign lsuq_wrdata_second = lsuq_wr_second_en ? lsuq_do_wdata_second : 0;
assign lsuq_do_first_read = rcu_lsu_req_ready_i; 
assign rcu_lsu_req_valid_o = !lsuq_empty;
assign lsuq_rd_first_en = lsuq_do_first_read & !lsuq_empty;
assign lsuq_rd_second_en = 1'b0;
assign rcu_lsu_package_o = lsuq_rdata_first;
//: lsu queue

`ifdef REG_TEST
reg [XLEN-1:0] rob_test_st_data[ROB_SIZE-1:0];
reg [XLEN-1:0] rob_test_st_addr[ROB_SIZE-1:0];

always @(posedge clk) begin
    if (compress_select_first_valid & select_first_is_store) begin
        case(rob_op_stu_op[select_first_rob_index])
            STU_SB:
                rob_test_st_data[select_first_rob_index] <= {56'b0,select_first_rs2_data[7:0]};
            STU_SH:
                rob_test_st_data[select_first_rob_index] <= {48'b0,select_first_rs2_data[15:0]};
            STU_SW:
                rob_test_st_data[select_first_rob_index] <= {32'b0,select_first_rs2_data[31:0]};
            STU_SD:
                rob_test_st_data[select_first_rob_index] <= select_first_rs2_data;
        endcase
        rob_test_st_addr[select_first_rob_index] <= select_first_rs1_data + {{32{select_first_imm[31]}},select_first_imm};
    end
    if (compress_select_second_valid & select_second_is_store) begin
        rob_test_st_data[select_second_rob_index] <= select_second_rs2_data;
        rob_test_st_addr[select_second_rob_index] <= select_second_rs1_data + {{32{select_second_imm[31]}},select_second_imm};
    end
end

wire test_cmt_is_st_first = rob_op_is_store[cmt_rob_index_first];
wire [PHY_REG_ADDR_WIDTH-1:0] test_cmt_st_source_first = rob_rs2[cmt_rob_index_first];
wire [XLEN-1:0] test_cmt_st_data_first = rob_test_st_data[cmt_rob_index_first];
wire [XLEN-1:0] rob_test_st_addr_first = rob_test_st_addr[cmt_rob_index_first];

wire test_cmt_is_st_second = rob_op_is_store[cmt_rob_index_second];
wire [PHY_REG_ADDR_WIDTH-1:0] test_cmt_st_source_second = rob_rs2[cmt_rob_index_second];
wire [XLEN-1:0] test_cmt_st_data_second = rob_test_st_data[cmt_rob_index_second];
wire [XLEN-1:0] rob_test_st_addr_second = rob_test_st_addr[cmt_rob_index_second];
`endif


//csru pipeline reg
always @ (posedge clk) begin
    csr_valid <= compress_select_first_valid & select_is_csr & !rst & !global_speculate_fault;;
    if (compress_select_first_valid & select_is_csr) begin
        csr_rob_index   <= select_first_rob_index     ;
        csr_prd_address <= select_first_prd_address   ;
        csr_func3       <= select_first_func3         ;
        csr_rs1_data    <= select_first_rs1_data      ;
        csr_imm_data    <= select_first_imm           ;
        csr_address     <= select_csr_address         ;
        csr_do_read     <= select_do_csr_read         ;
        csr_do_write    <= select_do_csr_write        ;
    end
end
assign rcu_csr_req_valid_o   = csr_valid         ;
assign rcu_csr_rob_index_o   = csr_rob_index     ;
assign rcu_csr_prd_address_o = csr_prd_address   ;
assign rcu_csr_func3_o       = csr_func3         ;
assign rcu_csr_rs1_data_o    = csr_rs1_data      ;
assign rcu_csr_imm_data_o    = csr_imm_data      ;
assign rcu_csr_address_o     = csr_address       ;
assign rcu_csr_do_read_o     = csr_do_read       ;
assign rcu_csr_do_write_o    = csr_do_write      ;
//: csru pipeline reg


endmodule : rcu
`endif // _RCU_V_
