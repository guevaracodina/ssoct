# TimeQuest constraints to cut all false timing paths across async clock domains

# 
# clock_adapter_set_false_path:
#   Find and cut any paths from a selected source (from_filter) to a selected
#   register destination (default: *).
#   Path sources are found either as "pins" or "keepers".
#   Path matching is case-insensitive.  No-path-found warnings are suppressed.
#
proc clock_adapter_set_false_path {from_filter {to_registers * }} {
  set sources [ get_pins -nowarn -nocase -compatibility_mode $from_filter ] 
  set pinlist [ query_collection -list_format -limit 1 $sources ]
  if { [ llength $pinlist ] > 0 } {
    set_false_path \
      -from $sources \
      -to [get_registers $to_registers] 

  }

  set sources [ get_keepers -nowarn -nocase $from_filter ] 
  set keeperlist [ query_collection -list_format -limit 1 $sources ]
  if { [ llength $keeperlist ] > 0 } {
    set_false_path \
      -from $sources \
      -to [get_registers $to_registers] 
  }
}

clock_adapter_set_false_path *the*clock*\|slave_writedata_d1*\|*
clock_adapter_set_false_path *the*clock*\|slave_address*\|*
clock_adapter_set_false_path *the*clock*\|slave_byteenable*\|*
clock_adapter_set_false_path *the*clock*\|slave_nativeaddress_d1*\|*
clock_adapter_set_false_path *the*clock*\|slave_readdata_p1*

