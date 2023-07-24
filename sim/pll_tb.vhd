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
    generic map(
        RES => 16
    )
    port map(
        i_clk => i_clk, 
        i_rst => i_rst,
        i_in  => i_in,
        i_step => std_logic_vector(to_unsigned(13, 8)),
        i_lgcoef => std_logic_vector(to_unsigned(0, 4)),
        o_out => o_led 
    );

    i_clk_proc : process
        constant T : time := 20 ns; -- 50MHz
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
        wait for 77 us;
        i_rst <= '0';
        wait for 77 us;
        wait;
    end process;
END tb;
