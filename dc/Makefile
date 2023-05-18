## prefered path: proj_root/syn/dc/


export TIMESTAMP=$(shell date +%Y%m%d%H%M%S)
export PROJ_ROOT=/work/stu/lijiaao/dc_check/GreenRio2chip/dc
export DESIGN_NAME=core_top

all:
	export TIMESTAMP=$(shell date +%Y%m%d%H%M%S)
	export PROJ_ROOT=/work/stu/lijiaao/dc_check/GreenRio2chip/dc
	export DESIGN_NAME=core_top

	mkdir ./$(TIMESTAMP)_run && cd ./$(TIMESTAMP)_run && mkdir rpt && mkdir output

	/opt/cad/synopsys/installs/syn/Q-2019.12-SP5-1/bin/dc_shell-t -checkout DesignWare -f tcl_scripts/synth_lfl.tcl | tee $(TIMESTAMP)_run/$(DESIGN_NAME)_by_Guohua.log

PHONY:
clean:
	rm -rf *_run
	rm *.log


# -topographical_mode means using physical constraints on your design, this will allow you to 
# accurately predict post-layout timing, area, and power during synthesis without the need for 
# timing approximations based on wire load models. It uses placement and optimization 
# technologies to drive accurate timing prediction within synthesis and automatically performs 
# leakage power optimization, ensuring better correlation with the final physical design.

  
