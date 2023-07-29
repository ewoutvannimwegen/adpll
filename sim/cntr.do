onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cntr_tb/i_clk
add wave -noupdate /cntr_tb/i_rst
add wave -noupdate -radix unsigned /cntr_tb/R
add wave -noupdate -expand -group cntr /cntr_tb/cntr_0/i_in
add wave -noupdate -expand -group cntr -radix unsigned /cntr_tb/cntr_o_out
add wave -noupdate -expand -group scntr /cntr_tb/scntr_0/i_in
add wave -noupdate -expand -group scntr -radix unsigned /cntr_tb/scntr_o_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1484832 ps} 0}
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
WaveRestoreZoom {0 ps} {8192 ns}
