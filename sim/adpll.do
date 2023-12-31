onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /adpll_tb/adpll_0/i_clk
add wave -noupdate /adpll_tb/adpll_0/i_rst
add wave -noupdate -radix unsigned /adpll_tb/adpll_0/dco_0/i_step
add wave -noupdate -radix unsigned /adpll_tb/adpll_0/dco_0/step
add wave -noupdate /adpll_tb/adpll_0/i_rf
add wave -noupdate /adpll_tb/adpll_0/o_gen
add wave -noupdate -radix decimal /adpll_tb/adpll_0/pe
add wave -noupdate -radix decimal /adpll_tb/adpll_0/dco_0/ab
add wave -noupdate -radix unsigned /adpll_tb/adpll_0/dco_0/cnt
add wave -noupdate /adpll_tb/adpll_0/vld
add wave -noupdate /adpll_tb/adpll_0/dco_0/cor
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7133993 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {32768 ns}
