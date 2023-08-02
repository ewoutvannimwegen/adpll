`timescale 1ns / 1ps // Step of 1ns

module adpll_tb();

    localparam T_CLK = 20; // 50MHz
    localparam T_RF = 1200; // 833kHz
    integer i, j;

    reg i_clk = 1'b0;
    reg i_rf = 1'b0;
    reg i_rst = 1'b0;

    wire o_gen;
    
    adpll adpll_0 (
        .i_clk(i_clk),
        .i_rf(i_rf),
        .i_rst(i_rst),
        .o_gen(o_gen)
    );

    always begin
        for(i = 0; i < 50*100; i=i+1) begin
            #(T_CLK/2);
            i_clk = ~i_clk;
        end
    end
    
    always begin
        for(j = 0; j < 100; j=j+1) begin
            #(T_RF/2);
            i_rf = ~i_rf;
        end 
    end

    initial begin
        i_rst = 1'b1;
        #1000;
        i_rst = 1'b0;
    end 
endmodule
