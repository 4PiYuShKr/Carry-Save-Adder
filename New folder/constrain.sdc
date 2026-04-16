# ======================================================
# SDC File for Combinational Design (csa_kogge_16bit)
# ======================================================

# 1. Define a Virtual Clock
# Since there is no physical clock in the design, we create a virtual one
# to constrain the combinational delay from inputs to outputs.
create_clock -name vclk -period 10.0

# 2. Input Delays
# Assume 2.0ns is taken by logic outside the module before reaching the inputs
set_input_delay -clock vclk 2.0 [all_inputs]

# 3. Output Delays
# Assume 2.0ns is required by logic outside the module after the outputs
set_output_delay -clock vclk 2.0 [all_outputs]

# 4. Max Area
# Force the synthesizer to optimize for the smallest possible area
set_max_area 0

# 5. Environment Constraints (Optional but recommended)
# You can uncomment and modify these if you know your standard cell names
# set_driving_cell -lib_cell <YOUR_INV_CELL_NAME> [all_inputs]
# set_load 0.05 [all_outputs]
