onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /s2b_tb/s2b_0/R
add wave -noupdate -radix unsigned /s2b_tb/s2b_0/B
add wave -noupdate /s2b_tb/i_clk
add wave -noupdate /s2b_tb/i_rst
add wave -noupdate -radix binary /s2b_tb/i_in
add wave -noupdate -radix unsigned /s2b_tb/o_out
add wave -noupdate -radix binary /s2b_tb/s2b_0/mo0
add wave -noupdate -radix binary /s2b_tb/s2b_0/mo1
add wave -noupdate -radix unsigned /s2b_tb/s2b_0/c0
add wave -noupdate -radix unsigned /s2b_tb/s2b_0/c1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2006543 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 151
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
configure wave -timelineunits ns
update
WaveRestoreZoom {1691730 ps} {2395036 ps}
