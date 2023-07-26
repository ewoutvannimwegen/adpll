onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pfd_tb/i_clk
add wave -noupdate /pfd_tb/i_ref
add wave -noupdate /pfd_tb/i_fb
add wave -noupdate -radix decimal /pfd_tb/o_up
add wave -noupdate -radix unsigned /pfd_tb/o_dn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2193141001 ps} 0}
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
WaveRestoreZoom {2079642 ns} {3128218 ns}
