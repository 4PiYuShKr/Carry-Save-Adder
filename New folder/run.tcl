# ======================================================
# Cadence Genus Synthesis Script
# ======================================================

# -------- Library Setup --------
set_db lib_search_path {/home/install/FOUNDRY/digital/90nm/dig/lib}
set_db library {slow.lib}


# 2. Read RTL
# Make sure csa_kogge_16bit.v is in the same directory, or provide the full path
read_hdl csa_kogge_16bit.v
read_hdl full_adder.v
read_hdl kogge_stone_18bit.v
# 3. Elaborate Design
# This builds the generic structural representation of your top module
elaborate csa_kogge_16bit

# Check for any unresolved module references (like missing full_adders)
check_design -unresolved

# 4. Read Constraints
# Apply the SDC file created above
read_sdc constrain.sdc

# 5. Synthesis Steps
# Generic synthesis (technology independent)
syn_generic

# Map to standard cells (technology dependent)
syn_map

# Optimize for timing, area, and power
syn_opt

# 6. Generate Reports
# Save the results to text files for review
report_timing > report_timing.rpt
report_area   > report_area.rpt
report_power  > report_power.rpt
report_gates  > report_gates.rpt

# 7. Write Outputs
# Generate the synthesized mapped netlist and the final constraints
write_hdl > csa_kogge_16bit_netlist.v
write_sdc > csa_kogge_16bit_mapped.sdc

# Exit Genus
gui_show
