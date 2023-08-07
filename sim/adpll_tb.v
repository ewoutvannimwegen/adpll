`timescale 1ns / 1ps // Step of 1ns

module adpll_tb();

    localparam T_CLK = 20; // 50MHz
    localparam T_RF = 630; 
    integer i, j;

    reg i_clk = 1'b0;
    reg i_rf = 1'b0;
    reg i_rst = 1'b0;

    wire o_gen;
    
    adpll adpll_0 (
        .i_clk(i_clk),
        .i_rf(i_rf),
        .i_rst(i_rst),
        .i_step(8'h3),
        .o_gen(o_gen)
    );

    initial begin
        #1000;
        for(i = 0; i < T_RF/T_CLK*200; i=i+1) begin
            #(T_CLK/2);
            i_clk = ~i_clk;
        end
    end
    
    initial begin
        #1000;
        #(T_RF/4);
        for(j = 0; j < 200; j=j+1) begin
            #(T_RF/2);
            i_rf = ~i_rf;
        end 
    end

    initial begin
        i_rst = 1'b1;
        #500;
        i_rst = 1'b0;
        #500;
    end 
endmodule
