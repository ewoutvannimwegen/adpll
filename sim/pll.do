onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pll_tb/pll_0/i_clk
add wave -noupdate /pll_tb/pll_0/i_rst
add wave -noupdate /pll_tb/pll_0/i_in
add wave -noupdate -radix binary /pll_tb/pll_0/cnt
add wave -noupdate /pll_tb/pll_0/lvl
add wave -noupdate /pll_tb/pll_0/lead
add wave -noupdate /pll_tb/pll_0/o_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {211750000 ps} 1} {{Cursor 2} {215750000 ps} 1} {{Cursor 3} {219750000 ps} 1} {{Cursor 4} {40261191 ps} 0}
quietly wave cursor active 4
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
WaveRestoreZoom {31872583 ps} {48649799 ps}
