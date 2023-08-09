onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /disp_drv_tb/i_clk
add wave -noupdate /disp_drv_tb/i_rst
add wave -noupdate -radix unsigned /disp_drv_tb/i_dec
add wave -noupdate /disp_drv_tb/o_seg
add wave -noupdate /disp_drv_tb/disp_drv_0/bcd
add wave -noupdate -radix unsigned /disp_drv_tb/disp_drv_0/dig
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {57525 ps} 0}
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
WaveRestoreZoom {0 ps} {512 ns}
