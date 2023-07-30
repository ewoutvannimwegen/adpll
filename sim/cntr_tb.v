`timescale 1ns / 1ps // Step of 1ns

module cntr_tb();

    localparam T = 20; // 50MHz

    reg i_clk = 1'b0;
    reg i_rst = 1'b0;
    reg i_in  = 1'b0;

    wire [1023:0] scntr_o_out;
    
    scntr scntr_0 (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_in(i_in),
        .o_out(scntr_o_out)
    );

    always begin
        #(T/2);
        i_clk = ~i_clk;
    end

    initial begin
        i_rst = 1'b1;
        i_in = 1'b0;
        @(posedge i_clk);
        i_rst = 1'b0;
        @(posedge i_clk);
        i_in = 1'b1;
    end 

endmodule
