module physical_regfile #(
    parameter REG_SIZE = 36,
    parameter REG_SIZE_WIDTH = 6
)
(
    input clk,
    input rst,
    // from rcu (read ports)
    `ifdef REG_TEST
    input [REG_SIZE_WIDTH-1:0] test_prd_first_i ,
    input [REG_SIZE_WIDTH-1:0] test_prd_second_i,
    output [XLEN-1:0] test_rdata_first_o,
    output [XLEN-1:0] test_rdata_second_o,
    `endif
    input [REG_SIZE_WIDTH-1:0] prs1_address_first_i,
    input [REG_SIZE_WIDTH-1:0] prs2_address_first_i,
    input [REG_SIZE_WIDTH-1:0] prs3_address_first_i,
    input [REG_SIZE_WIDTH-1:0] prs1_address_second_i,
    input [REG_SIZE_WIDTH-1:0] prs2_address_second_i,
    input [REG_SIZE_WIDTH-1:0] prs3_address_second_i,
    // to rcu (read ports)
    output reg [63:0] prs1_data_first_o,
    output reg [63:0] prs2_data_first_o,
    output reg [63:0] prs3_data_first_o,
    output reg [63:0] prs1_data_second_o,
    output reg [63:0] prs2_data_second_o,
    output reg [63:0] prs3_data_second_o,
    // Quadruple write port
    input [REG_SIZE_WIDTH-1:0] alu1_wrb_address_i,
    input [REG_SIZE_WIDTH-1:0] alu2_wrb_address_i,
    input [REG_SIZE_WIDTH-1:0] falu1_wrb_address_i,
    input [REG_SIZE_WIDTH-1:0] falu2_wrb_address_i,
    input [REG_SIZE_WIDTH-1:0] lsu_wrb_address_i,
    input [REG_SIZE_WIDTH-1:0] md_wrb_address_i,
    input [63:0] alu1_wrb_data_i,
    input [63:0] alu2_wrb_data_i,
    input [63:0] falu1_wrb_data_i,
    input [63:0] falu2_wrb_data_i,
    input [63:0] lsu_wrb_data_i,
    input [63:0] md_wrb_data_i,
    input alu1_rcu_resp_valid_i,
    input alu2_rcu_resp_valid_i,
    input falu1_rcu_resp_valid_i,
    input falu1_rcu_resp_float_i,
    input falu2_rcu_resp_valid_i,
    input falu2_rcu_resp_float_i,
    input lsu_rcu_resp_valid_i,
    input lsu_rcu_resp_float_i,
    input md_rcu_resp_valid_i
);
    reg [63:0] registers [REG_SIZE-1:0];
    integer i;
    //P0 is always 0 and its finish bit is 1
    wire wr_first_valid;
    wire [REG_SIZE_WIDTH - 1 : 0] wr_first_address;
    wire [63:0] wr_first_data;

    wire wr_second_valid;
    wire [REG_SIZE_WIDTH - 1 : 0] wr_second_address;
    wire [63:0] wr_second_data;

    MultiWrite#(
	    .REG_ADDR_WIDTH(REG_SIZE_WIDTH),
	    .REG_DATA_WIDTH(64)
	    ) int_multiwrite(
		    .wr1_valid(alu1_rcu_resp_valid_i),
		    .wr1_address(alu1_wrb_address_i),
		    .wr1_data(alu1_wrb_data_i),
		    .wr2_valid(alu2_rcu_resp_valid_i),
		    .wr2_address(alu2_wrb_address_i),
		    .wr2_data(alu2_wrb_data_i),
		    .wr3_valid(falu1_rcu_resp_valid_i),
		    .wr3_address(falu1_wrb_address_i),
		    .wr3_data(falu1_wrb_data_i),
		    .wr4_valid(falu2_rcu_resp_valid_i),
		    .wr4_address(falu2_wrb_address_i),
		    .wr4_data(falu2_wrb_data_i),
		    .wr5_valid(lsu_rcu_resp_valid_i),
		    .wr5_address(lsu_wrb_address_i),
		    .wr5_data(lsu_wrb_data_i),
		    .wr6_valid(md_rcu_resp_valid_i),
		    .wr6_address(md_wrb_address_i),
		    .wr6_data(md_wrb_data_i),
		    .wr_first_valid(wr_first_valid),
		    .wr_first_address(wr_first_address),
		    .wr_first_data(wr_first_data),
		    .wr_second_valid(wr_second_valid),
		    .wr_second_address(wr_second_address),
		    .wr_second_data(wr_second_data)
    );

    //reg read
    always @(*) begin
        prs1_data_first_o = registers[prs1_address_first_i];
        prs2_data_first_o = registers[prs2_address_first_i];
        prs3_data_first_o = registers[prs3_address_first_i];
        prs1_data_second_o = registers[prs1_address_second_i];
        prs2_data_second_o = registers[prs2_address_second_i];
        prs3_data_second_o = registers[prs3_address_second_i];
    end

    //reg write
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < REG_SIZE; i = i + 1) begin
                registers[i] <= 0;
            end
        end else begin
            if (wr_first_valid) begin
                registers[wr_first_address] <= (wr_first_address == '0)? 64'b0 : wr_first_data;
            end
            if (wr_second_valid) begin
                registers[wr_second_address] <= (wr_second_address == '0)? 64'b0 : wr_second_data;
            end
        end
    end

    `ifdef REG_TEST
    assign test_rdata_first_o = registers[test_prd_first_i];
    assign test_rdata_second_o = registers[test_prd_second_i];
    `endif



endmodule : physical_regfile
