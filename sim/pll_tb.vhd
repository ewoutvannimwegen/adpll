library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity pll_tb is
end pll_tb;

architecture tb of pll_tb is
    signal i_clk : std_logic := '0';
    signal i_rst : std_logic := '0';
    signal i_in : std_logic := '0';
    signal o_led : std_logic := '0';
begin
    pll_0 : entity work.pll
    port map(
        i_clk => i_clk, 
        i_rst => i_rst,
        i_in  => i_in,
        i_step => "0001",
        o_out => o_led 
    );

    i_clk_proc : process
        constant T : time := 390.625 ns; -- 2.56MHz
    begin
        wait for (T/2); 
        i_clk <= '1';
        wait for (T/2); 
        i_clk <= '0';
    end process;
    
    i_in_proc : process
        constant T : time := 100 us; -- 10kHz
    begin
        wait for (T/2); 
        i_in <= '1';
        wait for (T/2); 
        i_in <= '0';
    end process;
  
    pll_proc : process
    begin
        i_rst <= '1';
        wait for 10 us;
        i_rst <= '0';
        wait for 10 us;
        wait;
    end process;
END tb;
