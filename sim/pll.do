onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pll_tb/pll_0/i_clk
add wave -noupdate /pll_tb/pll_0/i_rst
add wave -noupdate -radix unsigned /pll_tb/pll_0/RES
add wave -noupdate -radix unsigned /pll_tb/pll_0/i_step
add wave -noupdate -radix unsigned /pll_tb/pll_0/i_lgcoef
add wave -noupdate -radix unsigned /pll_tb/pll_0/corr
add wave -noupdate /pll_tb/pll_0/lvl
add wave -noupdate /pll_tb/pll_0/lead
add wave -noupdate -radix unsigned /pll_tb/pll_0/cnt
add wave -noupdate /pll_tb/pll_0/err
add wave -noupdate /pll_tb/pll_0/i_in
add wave -noupdate /pll_tb/pll_0/o_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {4297430000 ps} 0}
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
WaveRestoreZoom {4237858559 ps} {4616242943 ps}
