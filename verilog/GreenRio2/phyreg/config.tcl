set ::env(DESIGN_NAME) "physical_regfile"
set ::env(DESIGN_IS_CORE) 0
set ::env(CLOCK_PERIOD) "25"
set ::env(CLOCK_PORT) "clk"
set ::env(ROUTING_CORES) 8
set ::env(FP_CORE_UTIL) {26}
set ::env(PL_TARGET_DENSITY) 0.30
set ::env(DIODE_INSERTION_STRATEGY) 3
set ::env(SYNTH_MAX_FANOUT) 20
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(GRT_ALLOW_CONGESTION) 0
set script_dir $::env(DESIGN_DIR)
set ::env(VERILOG_FILES)  
	"$::env(DESIGN_DIR)/../rcu/unit/physical_regfile/physical_regfile.sv\
	 $::env(DESIGN_DIR)/../rcu/unit/physical_regfile/fp_physical_regfile.sv
 	"
set ::env(SDC_FILE) $::env(DESIGN_DIR)/base.sdc
set ::env(LEC_ENABLE) 0
set ::env(RUN_CVC) 0
set ::env(USE_ARC_ANTENNA_CHECK) "0"
set ::env(RT_MAX_LAYER) {met4}
set ::env(QUIT_ON_TIMING_VIOLATIONS) "0"
set ::env(QUIT_ON_MAGIC_DRC) "0"
set ::env(QUIT_ON_LVS_ERROR) "0"
set ::env(QUIT_ON_SLEW_VIOLATIONS) "0"
set ::env(RUN_KLAYOUT_XOR) "0"
set ::env(KLAYOUT_XOR_GDS) "0"
set ::env(KLAYOUT_XOR_XML) "0"
set ::env(RUN_KLAYOUT) "0"
set ::env(RUN_MAGIC_DRC) 0
set ::env(RUN_KLAYOUT_DRC) 0
