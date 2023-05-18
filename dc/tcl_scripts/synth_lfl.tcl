echo "RUN STARTED AT [date]"
set DESIGN_NAME core_top
set FLIST "/work/stu/lijiaao/dc_check/GreenRio2chip/dc/flist.f"
set SDC_FILE /work/stu/lijiaao/dc_check/GreenRio2chip/dc/top.sdc

source ./.synopsys_dc.setup
source tcl_scripts/synth_init_lib.tcl
set_svf ./$env(TIMESTAMP)_run/output/${DESIGN_NAME}.synth.svf
# Tool settings
set_app_var sh_new_variable_message                     false
set_app_var report_default_significant_digits           3
set_app_var hdlin_infer_multibit                        default_all
set_app_var compile_clock_gating_through_hierarchy      true
set_app_var hdlin_enable_upf_compatible_naming          true
set_app_var compile_timing_high_effort_tns              true
set_app_var compile_clock_gating_through_hierarchy      true
set_app_var hdlin_enable_hier_map                       true

set_host_options -max_cores 10 
foreach mid [get_message_ids -type Warning] { set_message_info -id $mid -limit 10}
foreach mid [get_message_ids -type Info] { set_message_info -id $mid -limit 10}

###################################################################
#------------------------Specify the libraries---------------------#
set_app_var search_path "$search_path ."
set_app_var target_library [concat "$DB(fd_sc_hd__tt_025C_1v80)"]
set_app_var synthetic_library "dw_foundation.sldb"
set_app_var link_library "* $target_library $synthetic_library"

define_design_lib WORK -path ./$env(TIMESTAMP)_run/WORK

source tcl_scripts/file_to_list.tcl
analyze -format  sverilog [concat [expand_file_list $FLIST]]

#analyze HDL source code and save intermediate results named .syn in ./$env(TIMESTAMP)_run/work dir, which can be used by elaborate directly even without anlyzing; TODO: what does es1y_define.sv mean?#
elaborate  $DESIGN_NAME
# write_file -hierarchy -format verilog -output output/hehe.synth.elaborate.v
current_design $DESIGN_NAME
link

set_dp_smartgen_options -hierarchy -smart_compare true -tp_oper_sel auto -tp_opt_tree auto  -brent_kung_adder true -adder_radix auto -inv_out_adder_cell auto -mult_radix4 auto -sop2pos_transformation auto  -mult_arch auto -optimize_for area,speed 
#analyze_datapath_extraction -no_autoungroup
set_verification_top
uniquify

analyze_datapath_extraction -no_autoungroup

source $SDC_FILE

write_file -hierarchy -format verilog -output ./$env(TIMESTAMP)_run//output/${DESIGN_NAME}.synth.elaborate.tie.v
write -format ddc -hierarchy -output ./$env(TIMESTAMP)_run/output/${DESIGN_NAME}.synth.elab.tie.ddc


set_clock_transition 0.1 [all_clocks]
set_critical_range 10 [current_design]

group_path -weight 0.1 -name input_path  -from [all_inputs]
group_path -weight 0.1 -name output_path -to   [all_outputs]
group_path -weight 0.1 -name in2out  -from [all_inputs] -to  [all_outputs]

set_dynamic_optimization false
set_leakage_optimization false

set compile_timing_high_effort true
set placer_tns_driven true
set psynopt_tns_high_effort true
set compile_timing_high_effort_tns true
set_cost_priority -delay

set compile_final_drc_fix all
set compile_automatic_clock_phase_inference relaxed
set compile_enable_constant_propagation_with_no_boundary_opt true

set compile_advanced_fix_multiple_port_nets true
set compile_rewire_multiple_port_nets true


#--------------------- Define clock gating -------------------------#
#set_attribute [get_lib_cells fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__dlclkp*] clock_gating_integrated_cell latch_posedge_precontrol
#set_clock_gating_style -sequential_cell latch -positive_edge_logic {integrated} -negative_edge_logic {integrated} \
             -control_point before -control_signal scan_enable \
             -minimum_bitwidth 4 -observation_point false \
             -max_fanout 12

#set_clock_latency 0 [all_clocks]
#set_clock_gate_latency -overwrite -stage 0 -fanout_latency {1-inf 0}
#set_clock_gate_latency -overwrite -stage 1 -fanout_latency {1-inf -0.05}
#set_clock_gate_latency -overwrite -stage 2 -fanout_latency {1-inf -0.1}
#set_clock_gate_latency -overwrite -stage 3 -fanout_latency {1-inf -0.15}
#set_clock_gate_latency -overwrite -stage 4 -fanout_latency {1-inf -0.2}
#set_clock_gate_latency -overwrite -stage 5 -fanout_latency {1-inf -0.25}

#set ALL_INPUTS [all_inputs]
#foreach_in_collection INPUTS $ALL_INPUTS {
 #   append_to_collection -unique INPUT_REG [ filter_collection [all_fanout -from $INPUTS -flat -endpoints_only] "full_name =~ */synch_toggle || full_name =~ */synch_preset || full_name =~ */synch_enable || full_name =~ */synch_clear || full_name =~ */next_state "]
#}
#set_clock_gating_objects -exclude [get_cells -of_object $INPUT_REG]
set_dynamic_optimization true

    set_app_var compile_enable_constant_propagation_with_no_boundary_opt true; 
    current_design ${DESIGN_NAME}; 
#run 2 times        compile_ultra
compile_ultra -gate_clock -retime -no_autoungroup -no_boundary_optimization 
#compile_ultra (of DC Ultra) provides concurrent optimization of timing, area, power, and test for high performance designs#
#it also provides advanced delay and arithmetic optimization, advanced timing analysis, automatic leakage power optimization, and register retiming#

#--------------------- Analyze and debug the design/resolve design problems --------------------#

analyze_datapath > ./$env(TIMESTAMP)_run/rpt/datapath.compile.rpt
report_resources > ./$env(TIMESTAMP)_run/rpt/resources.compile.rpt
write_file -hierarchy -format verilog -output ./$env(TIMESTAMP)_run/output/hehe.synth.compile.v
write_sdc ./$env(TIMESTAMP)_run/output/hehe.synth.compile.sdc

update_timing
report_timing -nosplit > ./$env(TIMESTAMP)_run/rpt/timing.compile.rpt
report_area -nosplit -hier > ./$env(TIMESTAMP)_run/rpt/area.hier.compile.rpt

check_design > ./$env(TIMESTAMP)_run/rpt/check_design.preopt.rpt
optimize_netlist -area -no_boundary_optimization
check_design > ./$env(TIMESTAMP)_run/rpt/check_design.postopt.rpt

define_name_rules preserve_struct_bus_rule -preserve_struct_ports
define_name_rules ours_verilog_name_rule -allowed "a-z A-Z 0-9 _" \
  -check_internal_net_name \
  -case_insensitive

change_names -rules preserve_struct_bus_rule -hierarchy -log_changes ./$env(TIMESTAMP)_run/rpt/struct_name_change.log
change_names -rules ours_verilog_name_rule   -hierarchy -log_changes ./$env(TIMESTAMP)_run/rpt/legalize_name_change.log
write -format verilog -hierarchy -output ./$env(TIMESTAMP)_run/output/hehe.synth.final.v
write -format ddc -hierarchy -output ./$env(TIMESTAMP)_run/output/hehe.synth.final.ddc
write_sdc -nosplit ./$env(TIMESTAMP)_run/output/hehe.synth.final.sdc
report_clock_gating > ./$env(TIMESTAMP)_run/rpt/clock_gating.rpt
report_timing -tran -net -input -max_paths 500 -significant_digits 3 -nosplit > ./$env(TIMESTAMP)_run/rpt/synth.timing.rpt
report_timing -delay_type min -max_paths 500 -input_pins -nets -transition_time -capacitance -significant_digits 3 > ./$env(TIMESTAMP)_run/rpt/synth.min_delay.rpt
report_timing -delay_type max -max_paths 500 -input_pins -nets -transition_time -capacitance -significant_digits 3 > ./$env(TIMESTAMP)_run/rpt/synth.max_delay.rpt
report_constraint -all_violators -significant_digits 3 > ./$env(TIMESTAMP)_run/rpt/synth.all_viol_constraints.rpt
report_area -nosplit -hier > ./$env(TIMESTAMP)_run/rpt/synth.area.hier.rpt
report_resources -nosplit -hier > ./$env(TIMESTAMP)_run/rpt/synth.resources.rpt
report_timing_requirements > ./$env(TIMESTAMP)_run/rpt/synth.mulcycle.rpt
report_compile_options -nosplit > ./$env(TIMESTAMP)_run/rpt/synth.compile_options.rpt
#report_timing -tran -net -input -max_paths 1000 > ./$env(TIMESTAMP)_run/rpt/timing.rpt
report_clock_gating -nosplit -verbose -multi_stage > ./$env(TIMESTAMP)_run/rpt/clock_gating.rpt
report_clock_gating -gated -nosplit -verbose > ./$env(TIMESTAMP)_run/rpt/clock_gating_gated.rpt
report_clock_gating -ungated -nosplit -verbose > ./$env(TIMESTAMP)_run/rpt/clock_ungating_gated.rpt
report_power -nosplit > ./$env(TIMESTAMP)_run/rpt/power.rpt
report_qor > ./$env(TIMESTAMP)_run/rpt/qor.rpt
#report_area -hierarchy > ./$env(TIMESTAMP)_run/rpt/area.rpt
#report_constraint -all_violators -verbose -max_capacitance -max_transition ./$env(TIMESTAMP)_run/rpt/drc.rpt
report_clocks > ./$env(TIMESTAMP)_run/rpt/clock.rpt
check_design -unmapped ./$env(TIMESTAMP)_run/rpt/check_design.rpt
#check_timing -include {clock_no_period data_check_no_clock generated_clock generic} ./$env(TIMESTAMP)_run/rpt/check_timing.rpt
#--------------------- Save the design database ---------------------#
write_file -format ddc -hierarchy -output ./$env(TIMESTAMP)_run/output/${DESIGN_NAME}.ddc
#.ddc is the whole project, can be modified and checked#
write_file -format verilog -hierarchy -output ./$env(TIMESTAMP)_run/output/${DESIGN_NAME}_netlist.v
#netlist.v for P&R and sim#
#write_sdf ./$env(TIMESTAMP)_run/output/${DESIGN_NAME}_sdf
#recording the latency of std cells, also useful for post-sim#
#write_parasitics -output ./$env(TIMESTAMP)_run/output/${DESIGN_NAME}_parasitics
#Writes parasitics in SPEF format or as a Tcl script that contains set_load and set_resistance commands.#
# write_sdc sdc_file_name
#Writes out a script in Synopsys Design Constraints (SDC) format.#
#This script contains commands that can be used with PrimeTime or with Design Compiler. SDC is also licensed by external vendors through the Tap-in program. SDC-formatted script files are read into PrimeTime or Design Compiler using the read_sdc command.#
# write_floorplan -all ./$env(TIMESTAMP)_run/output/${DESIGN_NAME}_phys_cstr_file_name.tcl
#writes a Tcl script file that contains floorplan information for the current or user-specified design. writes commands relative to the top of the design, regardless of the current instance.#
#-------------------------------------------------------------------#
echo "RUN ENDED AT [date]"
