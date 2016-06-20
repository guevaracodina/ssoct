package require ::quartus::project


set project_name NiosII_stratixII_2s60_RoHS_TSE_SGDMA
set current_revision [get_current_revision $project_name]


project_open -revision $current_revision $project_name

#SourceList
source verify_timing_for_ddr_sdram_0.tcl
#EndSourceList
