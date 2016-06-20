##
##
##  Run this TCL script after successfully compiling
##  your DDR/DDR2-SDRAM v9.0 Project in QUARTUS-II
##
##  THIS MAY TAKE SOME TIME!
##
##
##
##
##
##
##Legal Notice: (C)2006 Altera Corporation. All rights reserved. Your
##use of Altera Corporation's design tools, logic functions and other
##software and tools, and its AMPP partner logic functions, and any
##output files any of the foregoing (including device programming or
##simulation files), and any associated documentation or information are
##expressly subject to the terms and conditions of the Altera Program
##License Subscription Agreement or other applicable license agreement,
##including, without limitation, that your use is for the sole purpose
##of programming logic devices manufactured by Altera and sold by Altera
##or its authorized distributors. Please refer to the applicable
##agreement for further details. 



















set actual_pwd [file normalize [pwd]]
set correct_pwd [file normalize [file dirname [info script]]]
if { $actual_pwd != $correct_pwd } {

post_message -type warning "[info script] is not being run from the directory it resides in. Should be run from $correct_pwd not $actual_pwd"
post_message -type warning "Changing to $correct_pwd in order to continue."
cd $correct_pwd
}


source ddr_lib_path.tcl
package require ::ddr::settings



global variation_name 
if { [regexp {^verify_timing_for_([\w\d\-_]+).tcl$} [file tail [info script]]  x variation_name] != 1} {
error "Couldn't extract variation name from [file tail [info script]]"
}

puts "Detected variation name: $variation_name"


::ddr::settings::read "${variation_name}_ddr_settings.txt" settings_array
puts "Running verify_ddr_timing_main.tcl from $settings_array(current_script_working_dir)"


set gen_pwd $settings_array(wrapper_path)

if { [file normalize $correct_pwd] != [file normalize $gen_pwd] } {
post_message -type critical_warning "DDR Post Compile timing verification has detected a change in project path from [file normalize $gen_pwd] to  [file normalize $correct_pwd]."
post_message -type critical_warning "This is likely to cause timing verification to fail. Regenerate DDR Megacore and recompile."
}




set res [catch {
source [file join $settings_array(current_script_working_dir) verify_ddr_timing_main.tcl]
} err]

if { $actual_pwd != [pwd] } {
post_message -type info "Changing working directory back to $actual_pwd from [pwd]"
cd $actual_pwd
}


if { $res } { error $err } 


