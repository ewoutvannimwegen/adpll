onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pfdv2_tb/pfdv2_0/RES
add wave -noupdate /pfdv2_tb/pfdv2_0/i_rst
add wave -noupdate /pfdv2_tb/pfdv2_0/i_clk
add wave -noupdate /pfdv2_tb/pfdv2_0/i_ref
add wave -noupdate /pfdv2_tb/pfdv2_0/i_fb
add wave -noupdate /pfdv2_tb/pfdv2_0/rst
add wave -noupdate -radix unsigned /pfdv2_tb/pfdv2_0/o_up
add wave -noupdate -radix unsigned /pfdv2_tb/pfdv2_0/o_dn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {134763306 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {131962584 ps} {155197144 ps}
