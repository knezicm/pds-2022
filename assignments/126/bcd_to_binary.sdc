## Generated SDC file "bcd_to_binary.sdc"

## Copyright (C) 2016  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Intel and sold by Intel or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"

## DATE    "Thu Dec 29 16:56:10 2022"

##
## DEVICE  "5CSEMA5F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************


create_clock -name clk_i -period 10.000 [get_ports {clk_i}]
create_clock -name clk_virt -period 10.000
#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -clock clk_virt -max 0.550 [get_ports {start_i}]
set_input_delay -clock clk_virt -min 0.350 [get_ports {start_i}]

set_input_delay -clock clk_virt -max 0.550 [get_ports {bcd1_i[*]}]
set_input_delay -clock clk_virt -min 0.350 [get_ports {bcd1_i[*]}]

set_input_delay -clock clk_virt -max 0.550 [get_ports {bcd2_i[*]}]
set_input_delay -clock clk_virt -min 0.350 [get_ports {bcd2_i[*]}]

#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -clock clk_virt -max 0.550 [get_ports {ready_o}]
set_output_delay -clock clk_virt -min 0.350 [get_ports {ready_o}]

set_output_delay -clock clk_virt -max 0.550 [get_ports {binary_o[*]}]
set_output_delay -clock clk_virt -min 0.350 [get_ports {binary_o[*]}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************
set_false_path -from [get_ports {rst_i}] -to [all_registers]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

