onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /p2d_tb/p2d_0/i_clk
add wave -noupdate /p2d_tb/p2d_0/i_rf
add wave -noupdate /p2d_tb/p2d_0/i_fb
add wave -noupdate /p2d_tb/p2d_0/up
add wave -noupdate /p2d_tb/p2d_0/dn
add wave -noupdate /p2d_tb/p2d_0/ep
add wave -noupdate -radix binary /p2d_tb/p2d_0/sign
add wave -noupdate -radix unsigned /p2d_tb/p2d_0/ab
add wave -noupdate -radix decimal /p2d_tb/p2d_0/o_er
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {49361145 ps} 0}
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
WaveRestoreZoom {48146546 ps} {71381106 ps}
