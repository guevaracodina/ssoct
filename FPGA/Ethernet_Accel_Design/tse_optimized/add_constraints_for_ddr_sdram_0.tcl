#
# Auto-generated DDR & DDR2 SDRAM Controller Compiler Constraint Script 
#
# (C) COPYRIGHT 2005 ALTERA CORPORATION 
# ALL RIGHTS RESERVED 
#
#------------------------------------------------------------------------
# This script will apply various placement, I/O standard and other		
# constraints to the current project. It is generated for a specific		
# instance of the DDR & DDR2 SDRAM Controller. It will apply constraints 
# according to the settings that were chosen in the MegaWizard and can	
# only be used to constrain this particular instance.					
#------------------------------------------------------------------------



###########################################################################
#					  Loading the required TCL packages		   
###########################################################################

	 package require ::quartus::project
	 package require ::quartus::flow
	 package require ::quartus::report

###########################################################################
#		Checking if a remove_add_constrints script exist				 #
#		if so run it else run the add_constrints script					 #
###########################################################################

	 set run_var 0
	 set remove_file "remove_add_constraints_for_ddr_sdram_0.tcl"
	 if {![file exists $remove_file]} {
	 	 set run_var 1
	 } else {
	 	 if {![info exists add_remove_string]} { 
	 	 	 source $remove_file
	 	 	 set run_var 1
	 	 } else {
	 	 	 set run_var 1
	 	 }
	 }

############################################################################
#	 In this section you can set all the pin names, hierarchy and top level	 #
############################################################################
	 set wizard_top_level				   ddr_sdram_0_debug_design; # this should be extracted automatically. If it fails use this setting
	 set wizard_hier_path				   "Automatically extracted by Quartus synthesis|" ; # REMEMBER TO FINISH THE PATH WITH A | (ie a vertical bar)

	 set prefix_name						   ddr_

	 set cas_n_pin_name                     cas_n
	 set clock_neg_pin_name                 clk_to_sdram_n
	 set clockfeedback_in_pin_name          fedback_clk_in
	 set bank_address_pin_name              ba
	 set dm_pin_name                        dm
	 set clock_enable_pin_name              cke
	 set cs_n_pin_name                      cs_n
	 set ras_n_pin_name                     ras_n
	 set clock_source_pin_name              clock_source
	 set dq_pin_name                        dq
	 set clock_pos_pin_name                 clk_to_sdram
	 set address_pin_name                   a
	 set write_enable_n_pin_name            we_n
	 set clockfeedback_out_pin_name         fedback_clk_out
	 set dqs_pin_name                       dqs
	 set do_analysis						   1 ; # only set this to 0 if you already have run analysis on your project. It can stay set to 1.
	 set check_path_from_report			   1 ; # only set this to 0 if you already have run analysis on your project. It can stay set to 1.
	 ###########################################################################

puts "\n*********************************************************************"
puts "*				  DDR & DDR2 SDRAM Controller Compiler				  *"
puts "*	 Applying the constraints for the datapath in the your MegaCore	  *"
puts "*********************************************************************\n"
if { $run_var != 0 } {

###########################################################################
#	Procedure check_paths() will analyse the project and check		
#	that the paths match the ones that the user may have changed 
#	in the file or MegaWizard											  
###########################################################################

	   proc check_paths {given_datapath_name do_analysis} {
		puts					"\nNote: The add_constraints script is searching the correct path to the datapath in your MegaCore"
		if {$do_analysis} {puts "	   Analysis and Elaboration will be run and will take some time...\n"}

		set top_level ""

		if {$do_analysis} {

			set err [catch {execute_flow -analysis_and_elaboration } result]
			if {$err} {
				post_message -type error "Analysis and Elaboration failed. The constraints script will not be able to add any constraints."
				puts "ERROR: Analysis and Elaboration failed. The constraints script will not be able to add any constraints."
				error $result
			} else {
				puts "Analysis and Elaboration was successful.\n"

				# get the top level name from Quartus
				set top_level [get_name_info -info entity_name [get_top_level_entity]]
				#puts "Top level name				 = $top_level\n"
			}
		}

		set num_matches 0;
		set datapath_name_list ""
		array set datapath_hier_path {}


		# This get_names will return all the datapaths and their submodules - we'll extract just the datapath tops later
		set err [catch {set datapath_names [get_names -filter *auk_ddr_datapath* -node_type hierarchy]} msg]
		if {$err} { puts "ERROR: $msg\n"}

		foreach_in_collection found_datapath $datapath_names {

			set item_to_test [get_name_info -info full_path $found_datapath]

			# Extract just the datapath top levels (ie not all their submodule) by looking for instance name are at the end of the string
			if {[regexp -nocase {^(.*\|)(\S+)_auk_ddr_datapath:\w+$} $item_to_test dummy hier_path datapath_name]} {

				# ok, so we found one. Add it to the list but check that we haven't already found it
				if {[info exists datapath_hier_path($datapath_name)]} {
					if {$datapath_hier_path($datapath_name) != $hier_path} {
						puts "ERROR : You have instantiated the same datapath more than once in the same design. You cannot instantiate the same datapath"
						puts "		  more than once since the constraints are location specific. Please modify the design so that each datapath is unique."
					}
				}
				if {[lsearch $datapath_name_list $datapath_name] < 0} {
					lappend datapath_name_list $datapath_name
					#puts $datapath_name_list
					set datapath_hier_path($datapath_name) $hier_path
					incr num_matches;
				}

				#puts "Full path to datapath module	 = $hier_path"
				#puts "Found datapath instance		 = $datapath_name\n"
			}
		}


		if {[lsearch $datapath_name_list $given_datapath_name] < 0} {
			set warn_str "The datapath name (${given_datapath_name}_auk_ddr_datapath) doesn't match the name(s) found in the project (${datapath_name_list}) so this script will not add any constraints.\n"
			puts "CRITICAL WARNING: $warn_str"; post_message -type critical_warning $warn_str
			set warn_str "This may be caused by redundant entries in the auto_add_ddr_constraints.tcl script or you may have renamed the entity or module containing the datapath.\n"
			puts "CRITICAL WARNING: $warn_str"; post_message -type critical_warning $warn_str
			
			set returned_path "ERROR"
			set path_correct 0
		} else {
			set path_correct 1
			set returned_path $datapath_hier_path($given_datapath_name)
			puts "Note: found ${given_datapath_name}_auk_ddr_datapath in $datapath_hier_path($given_datapath_name)"
		}

		if {($num_matches > 1)} {
			puts "Note: found $num_matches datapath modules in top level entity \"$top_level\"\n";
		}

		set return_list ""
		lappend return_list $path_correct $top_level $returned_path

		return $return_list
	}
	

###########################################################################
#	 Get paths and check them	
###########################################################################

	 if {![info exists add_remove_string]} {set	 add_remove_string ""} 
	 set wrapper_name		 ddr_sdram_0 

###########################################################################
#					 Check that the device is correct		 
###########################################################################

	 set current_project_device [get_global_assignment -name DEVICE]
	 set current_project_device [string tolower $current_project_device]
if {$add_remove_string == ""} {
	 if {[regexp -nocase ep2s60f672 $current_project_device] == 0 && [regexp -nocase nonenone $current_project_device] == 0} {
	 	 puts  "*********************************************************************"
	 	 puts  " WARNING: The device used by the MegaWizard no longer matches the	  "
	 	 puts  " device selected in Quartus II. Please run the MegaWizard again to	  "
	 	 puts  " ensure your constraints are correct for your chosen device.		  "
	 	 puts  "*********************************************************************"
	 	 post_message -type error "The device expected by the constraint script (ep2s60f672) does not match the device currently selected in Quartus II."
	  }
}
	 set disableLogicPlacement ""
	 if { [regexp -nocase hc $current_project_device] == 1} {
	 	 set disableLogicPlacement "-disable"
	 }
	if {$add_remove_string == ""} {


		if {$check_path_from_report} {
			set post_analysis_variables [check_paths $wrapper_name $do_analysis]
			if {[lindex $post_analysis_variables 0] == 0} {
				set datapath_not_found 1
				puts "Error. Either Analysis & Elaboration failed or the script could not find your variation, check your Processing report panel for information. This script will now end without adding any constraints.";
				#error		 "Either Analysis & Elaboration failed or the script could not find your variation, check your Processing report panel for information. This script will now end without adding any constraints."
			}
			set top_level				   [lindex $post_analysis_variables 1]
			set hierarchy_path_to_instance [lindex $post_analysis_variables 2]
		} else {
			# don't extract path from report so use wizard entry for the path to the datapath
			if {![info exists hierarchy_path_to_instance]} {
				set hierarchy_path_to_instance		   $wizard_hier_path

				set warn_str "The constraints script did not extract the path automatically. The entry you entered in the MegaWizard will be used ($hierarchy_path_to_instance)."
				puts "WARNING: $warn_str"; post_message -type warning $warn_str
			}

			# don't extract path from report so use wizard entry for the top level
			if {![info exists top_level]} {
				set top_level						   $wizard_top_level

				set warn_str "The constraints script did not extract the top level automatically. The entry detected by the MegaWizard will be used ($top_level)."
				puts "WARNING: $warn_str"; post_message -type warning $warn_str
			}
		}
	}

###########################################################################
# 
#	Actually apply the constraints		   
# 
###########################################################################

if {![info exists datapath_not_found]} {
	   if {$add_remove_string == "-remove"} {set apply_remove_string "Removing"} else {set apply_remove_string "Applying"}
	   puts "---------------------------------------------------------------------"
	   puts "-	$apply_remove_string constraints to datapath ${wrapper_name}_auk_ddr_sdram "
	   puts "-	Path to the datapath: ${hierarchy_path_to_instance}	 "
	   puts "---------------------------------------------------------------------\n"
	 puts "$apply_remove_string DQS pins as clocks for ${top_level}"	  
	 eval [concat set_instance_assignment -name \"OUTPUT_ENABLE_GROUP\" -to \"${prefix_name}${dm_pin_name}\" -entity \"${top_level}\" \"1\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_ENABLE_GROUP\" -to \"${prefix_name}${dqs_pin_name}\" -entity \"${top_level}\" \"1\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_ENABLE_GROUP\" -to \"${prefix_name}${dq_pin_name}\" -entity \"${top_level}\" \"1\" $add_remove_string]
	 puts "Turning off netlist optimisation for the DDR Datapath logic "	
	 puts "$apply_remove_string IO standard assignment for SSTL-2 Class II"
	 eval [concat set_instance_assignment -name \"IO_STANDARD\"  -to \"${prefix_name}${ras_n_pin_name}\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\"  -to \"${prefix_name}${cas_n_pin_name}\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\"  -to \"${prefix_name}${write_enable_n_pin_name}\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${clock_enable_pin_name}\\\[0\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[0\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[1\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[2\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[3\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[4\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[5\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[6\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[7\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[8\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[9\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[10\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[11\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${address_pin_name}\\\[12\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${bank_address_pin_name}\\\[0\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${bank_address_pin_name}\\\[1\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${cs_n_pin_name}\\\[0\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dm_pin_name}\\\[0\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dm_pin_name}\\\[1\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[0\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[1\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[2\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[3\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[4\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[5\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[6\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[7\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[8\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[9\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[10\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[11\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[12\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[13\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[14\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dq_pin_name}\\\[15\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dqs_pin_name}\\\[0\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${prefix_name}${dqs_pin_name}\\\[1\\\]\"  \"SSTL-2 CLASS II\" $add_remove_string]
	 puts "$apply_remove_string clock IO standard assignment for SSTL-2 Class I"
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${clock_pos_pin_name}\\\[0\\\]\"  \"SSTL-2 CLASS I\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"IO_STANDARD\" -to \"${clock_neg_pin_name}\\\[0\\\]\"  \"SSTL-2 CLASS I\" $add_remove_string]
	 puts "$apply_remove_string Fast output register assignments (addr/cmd) .."
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\"  -to \"${prefix_name}${ras_n_pin_name}\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\"  -to \"${prefix_name}${cas_n_pin_name}\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\"  -to \"${prefix_name}${write_enable_n_pin_name}\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${clock_enable_pin_name}\\\[0\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[0\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[1\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[2\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[3\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[4\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[5\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[6\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[7\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[8\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[9\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[10\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[11\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${address_pin_name}\\\[12\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${bank_address_pin_name}\\\[0\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${bank_address_pin_name}\\\[1\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"FAST_OUTPUT_REGISTER\" -to \"${prefix_name}${cs_n_pin_name}\\\[0\\\]\" -entity \"${top_level}\" \"ON\" $add_remove_string]
	 puts "$apply_remove_string 4pf load to DQ, DQS and DM pins"
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dm_pin_name}\\\[0\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dm_pin_name}\\\[1\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[0\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[1\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[2\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[3\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[4\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[5\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[6\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[7\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[8\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[9\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[10\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[11\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[12\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[13\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[14\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dq_pin_name}\\\[15\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dqs_pin_name}\\\[0\\\]\"  \"4\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${dqs_pin_name}\\\[1\\\]\"  \"4\" $add_remove_string]
	 puts "$apply_remove_string 2pf load to command pins"
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\"  -to \"${prefix_name}${ras_n_pin_name}\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\"  -to \"${prefix_name}${cas_n_pin_name}\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\"  -to \"${prefix_name}${write_enable_n_pin_name}\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${clock_enable_pin_name}\\\[0\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[0\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[1\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[2\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[3\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[4\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[5\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[6\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[7\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[8\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[9\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[10\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[11\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${address_pin_name}\\\[12\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${bank_address_pin_name}\\\[0\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${bank_address_pin_name}\\\[1\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${prefix_name}${cs_n_pin_name}\\\[0\\\]\"  \"2\" $add_remove_string]
	 puts "$apply_remove_string 2pf load to clocks pins"
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${clock_pos_pin_name}\\\[0\\\]\"  \"2\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"OUTPUT_PIN_LOAD\" -to \"${clock_neg_pin_name}\\\[0\\\]\"  \"2\" $add_remove_string]
	 puts "$apply_remove_string IO standard assignment for 2.5V clock inputs.."
	 eval [concat set_instance_assignment -name \"IO_STANDARD\"  -to \"${clock_source_pin_name}\"  \"2.5-V\" $add_remove_string]
	 puts "$apply_remove_string IO standard assignment for SSTL-2 Class II"
	 puts "$apply_remove_string clock IO standard assignment for SSTL-2 Class I"
	 puts "$apply_remove_string 4pf load to DQ, DQS and DM pins"
	 puts "$apply_remove_string 2pf load to command pins"
	 puts "$apply_remove_string 2pf load to clocks pins"
	 puts "$apply_remove_string Direction"
	 puts "$apply_remove_string Direction"
	 puts "$apply_remove_string CUT TIMING PATH assignment for DQS pins"
	 eval [concat set_instance_assignment -name \"CUT\" -from \"${prefix_name}${dqs_pin_name}\\\[0\\\]\" -to *  \"ON\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"CUT\" -from \"${prefix_name}${dqs_pin_name}\\\[1\\\]\" -to *  \"ON\" $add_remove_string]
	 puts ""
	 eval [concat set_global_assignment -name \"ASSIGNMENT_GROUP_MEMBER\" \"${clock_pos_pin_name}\" -section_id \"${wrapper_name}_clk_out_pair\" $add_remove_string]
	 eval [concat set_global_assignment -name \"ASSIGNMENT_GROUP_MEMBER\" \"${clock_neg_pin_name}\" -section_id \"${wrapper_name}_clk_out_pair\" $add_remove_string]
	 puts ""
	 eval [concat set_instance_assignment -name \"MAX_DATA_ARRIVAL_SKEW\" \"100 ps\" -from	\"ddr_pll_stratixii:g_stratixpll_ddr_pll_inst|altpll:altpll_component|_clk0\" -to \"${wrapper_name}_clk_out_pair\" $add_remove_string]
	eval [concat set_instance_assignment -name \"TPD_REQUIREMENT\" \"1.6ns\" -from	\"*captured_*\" -to \"*resynched_data*\" $add_remove_string]
	eval [concat set_instance_assignment -name \"TPD_REQUIREMENT\" \"1.6ns\" -from	\"*dq_enable_reset*\" -to \"*\" $add_remove_string]
	 eval [concat set_instance_assignment -name \"ADV_NETLIST_OPT_ALLOWED\" -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io\" -entity \"${top_level}\" \"Never Allow\"	$add_remove_string]
	 eval [concat set_instance_assignment -name \"REMOVE_DUPLICATE_REGISTERS\" -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io\" -entity \"${top_level}\" \"Off\"	$add_remove_string]
	 eval [concat set_instance_assignment -name \"AUTO_SHIFT_REGISTER_RECOGNITION\" \"OFF\" -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io\"    $add_remove_string]
	 eval [concat set_instance_assignment -name \"PRESERVE_FANOUT_FREE_NODE\" \"ON\" -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\"  $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[0\\\]\" \"Pin_D9\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[0\\\]\" \"LAB_X56_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[8\\\]\" \"LAB_X56_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|dq_enable_reset\\\[0\\\]\" \"LAB_X56_Y50\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[1\\\]\" \"Pin_D8\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[1\\\]\" \"LAB_X56_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[9\\\]\" \"LAB_X56_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[2\\\]\" \"Pin_C8\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[2\\\]\" \"LAB_X56_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[10\\\]\" \"LAB_X56_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[3\\\]\" \"Pin_A9\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[3\\\]\" \"LAB_X55_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[11\\\]\" \"LAB_X55_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[4\\\]\" \"Pin_B11\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[4\\\]\" \"LAB_X49_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[12\\\]\" \"LAB_X49_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[5\\\]\" \"Pin_C11\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[5\\\]\" \"LAB_X50_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[13\\\]\" \"LAB_X50_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[6\\\]\" \"Pin_A10\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[6\\\]\" \"LAB_X50_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[14\\\]\" \"LAB_X50_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[7\\\]\" \"Pin_D10\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[7\\\]\" \"LAB_X50_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:0:g_ddr_io|resynched_data\\\[15\\\]\" \"LAB_X50_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dqs_pin_name}\\\[0\\\]\" \"Pin_C9\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${prefix_name}${dm_pin_name}\\\[0\\\]\" \"Pin_C10\" $add_remove_string ]
	 eval [concat set_instance_assignment -name \"ADV_NETLIST_OPT_ALLOWED\" -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io\" -entity \"${top_level}\" \"Never Allow\"	$add_remove_string]
	 eval [concat set_instance_assignment -name \"REMOVE_DUPLICATE_REGISTERS\" -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io\" -entity \"${top_level}\" \"Off\"	$add_remove_string]
	 eval [concat set_instance_assignment -name \"AUTO_SHIFT_REGISTER_RECOGNITION\" \"OFF\" -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io\"    $add_remove_string]
	 eval [concat set_instance_assignment -name \"PRESERVE_FANOUT_FREE_NODE\" \"ON\" -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\"  $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[8\\\]\" \"Pin_A5\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[0\\\]\" \"LAB_X68_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[8\\\]\" \"LAB_X68_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|dq_enable_reset\\\[0\\\]\" \"LAB_X68_Y50\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[9\\\]\" \"Pin_B5\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[1\\\]\" \"LAB_X68_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[9\\\]\" \"LAB_X68_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[10\\\]\" \"Pin_D6\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[2\\\]\" \"LAB_X68_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[10\\\]\" \"LAB_X68_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[11\\\]\" \"Pin_A6\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[3\\\]\" \"LAB_X67_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[11\\\]\" \"LAB_X67_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[12\\\]\" \"Pin_A8\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[4\\\]\" \"LAB_X62_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[12\\\]\" \"LAB_X62_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[13\\\]\" \"Pin_A7\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[5\\\]\" \"LAB_X63_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[13\\\]\" \"LAB_X63_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[14\\\]\" \"Pin_C7\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[6\\\]\" \"LAB_X63_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[14\\\]\" \"LAB_X63_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dq_pin_name}\\\[15\\\]\" \"Pin_D7\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[7\\\]\" \"LAB_X63_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${hierarchy_path_to_instance}ddr_sdram_0_auk_ddr_datapath:ddr_io|ddr_sdram_0_auk_ddr_dqs_group:\\\\g_datapath:1:g_ddr_io|resynched_data\\\[15\\\]\" \"LAB_X63_Y51\" $disableLogicPlacement $add_remove_string]
	 eval [concat set_location_assignment -to \"${prefix_name}${dqs_pin_name}\\\[1\\\]\" \"Pin_C6\" $add_remove_string ]
	 eval [concat set_location_assignment -to \"${prefix_name}${dm_pin_name}\\\[1\\\]\" \"Pin_B7\" $add_remove_string ]
	 # -------------------------------------------------------------------------------------------------
	 #			create the remove script
	 # -------------------------------------------------------------------------------------------------
	if {$add_remove_string == ""} {
		set this_script_name [file tail [info script]]
		
		set fileid [open [info script] r]
		set str ""
		append str "set add_remove_string \"-remove\"\n"
		append str "set do_analysis 0\n"
		append str "set check_path_from_report 0\n"
		append str "set hierarchy_path_to_instance $hierarchy_path_to_instance\n"
		append str "set top_level $top_level\n"
		while {[gets $fileid line] >= 0} {
			append str "$line\n"
		}
		close $fileid

		append str "\n\nset add_remove_string \"\"\n"
		append str "set do_analysis 1\n\n"
		
		set output_script_name "remove_[file rootname $this_script_name][file extension $this_script_name]"
		set fileid [open $output_script_name w]
		puts $fileid $str
		close $fileid
	}
	 # unset some variable so they don't stick around for the next script!
	 unset hierarchy_path_to_instance
	 unset top_level
	 puts " - All Done"	   
	 puts "---------------------------------------------------------------------
"
	 }
}
