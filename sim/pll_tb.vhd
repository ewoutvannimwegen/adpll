library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity pll_tb is
end pll_tb;

architecture tb of pll_tb is

    signal i_clk : std_logic := '0';
    signal i_in : std_logic := '0';
    signal o_led : std_logic := '0';
begin
    i_clk_proc : process
        constant SYSCLK_PERIOD  : time := 500 ns; -- 2MHz
    begin
        wait for (SYSCLK_PERIOD/2); 
        i_clk <= '1';
        wait for (SYSCLK_PERIOD/2); 
        i_clk <= '0';
    end process;
    
    i_in_proc : process
        constant CLK_PERIOD  : time := 10 us; -- 100kHz
    begin
        wait for (CLK_PERIOD/2); 
        i_in <= '1';
        wait for (CLK_PERIOD/2); 
        i_in <= '0';
    end process;
    
    pll_0 : entity work.pll
    port map(
        i_clk => i_clk,
        i_rst => '0',
        i_in  => i_in,
        i_step => "0001",
        o_out => o_led 
    );
   
END tb;
