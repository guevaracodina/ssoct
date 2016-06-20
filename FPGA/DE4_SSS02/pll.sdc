# Uncommenting one of the following derive_pll_clocks lines
# will instruct the TimeQuest Timing Analyzer to automatically
# create derived clocks for all PLL outputs for all PLLs in a
# Quartus design.

# If the PLL inputs are constrained elsewhere, uncomment the
# next line to automatically constrain all PLL output clocks.
# derive_pll_clocks

# If the PLL inputs are not constrained elsewhere, uncomment
# the next line to automatically constrain all PLL input and
# output clocks.
# derive_pll_clocks -create_base_clocks 