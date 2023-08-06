`timescale 1ns / 1ps // Step of 1ns

module cntr_tb();

    localparam T = 5; // 200MHz
    integer i;

    reg i_clk = 1'b0;
    reg i_rst = 1'b0;
    reg i_in  = 1'b0;

    wire [6:0] o_out;
    
    scntr scntr_0 (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_in(i_in),
        .o_out(o_out)
    );

    always begin
        #(T/2);
        i_clk = ~i_clk;
    end

    initial begin
        // Wait till all D-FF's are set to initial value
        #100;

        @(posedge i_clk);
        i_in = 1'b1;

        for (i = 0; i < 10; i = i + 1) begin
            @(posedge i_clk);
        end 
       
        i_in = 1'b0;

        // Allow chain to clear its self
        // FF's clear quick, but MUX chain takes quiet a while!
        #200;

        for (i = 5; i < 10; i = i + 1) begin
            #(i);
            i_in = ~i_in;
        end 
      
        i_in = 1'b0;

        #20;
        $stop; 
    end 
endmodule
