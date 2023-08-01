`timescale 1ns / 1ps // Step of 1ns

module cntr_tb();

    localparam T = 20; // 50MHz
    integer i;

    reg i_clk = 1'b0;
    reg i_rst = 1'b0;
    reg i_in  = 1'b0;

    wire [511:0] scntr_o_out;
    
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
        // Wait till all D-FF's are set to initial value
        #100;

        i_in = 1'b1;

        for (i = 0; i < 4; i = i + 1) begin
            @(posedge i_clk);
        end 
       
        i_in = 1'b0;
    end 
endmodule
