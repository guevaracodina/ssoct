# make sure the DDR Megawizard path is on auto_path
set ddr_lib_path "/tools/altera/9.0/132/linux64/ip/altera/ddr_ddr2_sdram/lib/tcl"
if { [lsearch -exact $auto_path $ddr_lib_path] == -1 } {
	lappend auto_path $ddr_lib_path
}
return
