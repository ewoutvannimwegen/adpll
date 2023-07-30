`timescale 1ns / 1ps

module dff (
    input wire i_clk,        // System clock
    input wire i_rst,        // Reset
    input wire i_in,         // Input data
    output reg o_out    // Output data
);

    always @(posedge i_clk or posedge i_rst)
    begin
        if (i_rst)
            o_out <= 1'b0;
        else
            o_out <= i_in;
        end
endmodule
