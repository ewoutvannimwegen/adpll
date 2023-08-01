`timescale 1ns / 1ps

(* KEEP_HIERARCHY = "yes" *) 
module scntr #(
    parameter R = 1000 // Resolution
) (
    input wire i_clk,                                     // System clock
    input wire i_rst,                                     // Reset
    input wire i_in,                                      // Input data
    output wire [R-1:0] o_out                          // Output data
);

    wire [R-1:0] di;
    wire [R-1:0] do;

    genvar i;

    generate
        for (i = 0; i < R/4; i = i + 1)
        begin
            if (i == 0) begin : gen_zero
                (* dont_touch = "TRUE" *) 
                // https://docs.xilinx.com/r/en-US/ug953-vivado-7series-libraries/CARRY4
                CARRY4 c4_inst_0 (
                    .CO(di[3:0]), // 4-bit carry out
                    .CI(i_in),    // 1-bit carry cascade input 
                    .CYINIT(1'b0), // 1-bit carry initialization
                    .DI(4'b0000), // 4-bit carry-MUX data in
                    .S(4'b1111), // 4-bit carry-MUX select input
                    .O() // 4-bit carry chain XOR data out
                );
            end 
            else begin 
                (* dont_touch = "TRUE" *) 
                CARRY4 c4_inst_i (
                    .CO(di[i*4 +: 4]),
                    .CI(di[i*4 - 1]),
                    .CYINIT(1'b0),
                    .DI(4'b0000),
                    .S(4'b1111),
                    .O()
                );
            end 
        end
       
        for (i = 0; i < R; i = i + 1)
        begin
            (* dont_touch = "TRUE" *) 
            FDCE #(
                .INIT(1'b0)
            ) fdce_inst_i (
                .C(i_clk),
                .CLR(i_rst),
                .D(di[i]),
                .Q(do[i]),
                .CE(1'b1)
            );
        end

    endgenerate

    assign o_out = do;
endmodule

