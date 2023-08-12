# Everything on connector JC1 is put to 2.5V only possible diff. pair voltage
# for HR bank.

### JA1.5 (IO_L5P_T0_AD9P_35)
#set_property PACKAGE_PIN E18 [get_ports i_clk]
#set_property IOSTANDARD LVCMOS25 [get_ports i_clk]

# Create 50MHz system clock
#create_clock -period 20.000 -name i_clk -add [get_ports i_clk]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_clk_IBUF] 

##------------------------------------------------------------------------------
## JC1 Connector
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
## SEG0
##------------------------------------------------------------------------------
### JC1.4 (IO_L6N_T0_VREF_13)
set_property PACKAGE_PIN    V5          [get_ports {o_seg[5]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[5]}]
#
### JC1.5 (IO_L11P_T1_SRCC_13)
set_property PACKAGE_PIN    U7          [get_ports {o_seg[4]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[4]}]
#
### JC1.6 (IO_L12N_T1_MRCC_13)
set_property PACKAGE_PIN    U10         [get_ports {o_seg[6]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[6]}]
#
### JC1.7 (IO_L11N_T1_SRCC_13)
set_property PACKAGE_PIN    V7          [get_ports {o_seg[3]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[3]}]
#
### JC1.8 (IO_L12P_T1_MRCC_13)
set_property PACKAGE_PIN    T9          [get_ports {o_seg[1]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[1]}]
#
### JC1.11 (IO_L19P_T3_13)
set_property PACKAGE_PIN    T5          [get_ports {o_seg[2]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[2]}]
#
### JC1.12 (IO_L20N_T3_13)
set_property PACKAGE_PIN    Y13         [get_ports {o_seg[0]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[0]}]
##------------------------------------------------------------------------------
## SEG1
##------------------------------------------------------------------------------
### JC1.13 (IO_L19N_T3_VREF_13)
set_property PACKAGE_PIN    U5          [get_ports {o_seg[11]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[11]}]
#
### JC1.14 (IO_L20P_T3_13)
set_property PACKAGE_PIN    Y12         [get_ports {o_seg[12]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[12]}]
#
### JC1.17 (IO_L21P_T3_DQS_13)
set_property PACKAGE_PIN    V11         [get_ports {o_seg[10]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[10]}]
#
### JC1.18 (IO_L22N_T3_13)
set_property PACKAGE_PIN    W6          [get_ports {o_seg[13]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[13]}]
#
### JC1.19 (IO_L21N_T3_DQS_13)
set_property PACKAGE_PIN    V10         [get_ports {o_seg[9]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[9]}]
#
### JC1.20 (IO_L22P_T3_13)
set_property PACKAGE_PIN    V6          [get_ports {o_seg[8]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[8]}]
#
### JC1.23 (IO_L15P_T2_DQS_13)
#set_property PACKAGE_PIN    V8          [get_ports {o_seg[16]}]
#set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[16]}]
#
### JC1.24 (IO_L18N_T2_13)
set_property PACKAGE_PIN    Y11         [get_ports {o_seg[7]}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[7]}]
#
### JC1.25 (IO_L15N_T2_DQS_13)
#set_property PACKAGE_PIN    W8          [get_ports {o_seg[15]}]
#set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[15]}]
#
### JC1.26 (IO_L18P_T2_13)
#set_property PACKAGE_PIN    W11         [get_ports {o_seg[17]}]
#set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[17]}]
#
### JC1.29 (IO_L17P_T2_13)
#set_property PACKAGE_PIN    U9          [get_ports {o_seg[14]}]
#set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[14]}]
#
### JC1.30 (IO_L16N_T2_13)
#set_property PACKAGE_PIN    W9          [get_ports {o_seg[18]}]
#set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[18]}]
#
### JC1.31 (IO_L17N_T2_13)
#set_property PACKAGE_PIN    U8          [get_ports {i_btn}]
#set_property IOSTANDARD     LVCMOS25    [get_ports {i_btn}]
#
### JC1.32 (IO_L16P_T2_13)
#set_property PACKAGE_PIN    W10         [get_ports {o_seg[19]}]
#set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[19]}]
#
### JC1.35 (IO_L14P_T2_SRCC_13)
set_property PACKAGE_PIN    Y9           [get_ports {i_rf_P}]
set_property IOSTANDARD     LVDS_25      [get_ports {i_rf_P}]
#
#### JC1.36 (IO_L13N_T2_MRCC_13)
#set_property PACKAGE_PIN    Y6          [get_ports {o_seg[20]}]
#set_property IOSTANDARD     LVCMOS25    [get_ports {o_seg[20]}]

## JC1.37 (IO_L14N_T2_SRCC_13)
set_property PACKAGE_PIN    Y8           [get_ports {i_in_N}]
set_property IOSTANDARD     LVDS_25      [get_ports {i_in_N}]

## JC1.38 (IO_L13P_T2_MRCC_13)
set_property PACKAGE_PIN    Y7          [get_ports {o_rf}]
set_property IOSTANDARD     LVCMOS25    [get_ports {o_rf}]

