library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity adpll_tb is
end adpll_tb;

architecture tb of adpll_tb is
    constant R : natural := 9;

    signal i_clk : std_logic := '0';
    signal i_rf  : std_logic := '0';
    signal i_rst : std_logic := '0';
    signal o_gen : std_logic := '0';
begin
    adpll_0 : entity work.adpll
    generic map (
        R => R
    )
    port map(
        i_clk => i_clk,
        i_rf  => i_rf,
        i_rst => i_rst,
        o_gen => o_gen
    );

    i_clk_proc : process
        constant T : time := 20 ns; -- 50MHz
    begin
        for i in 0 to 50*100 loop
            wait for (T/2); 
            i_clk <= '1';
            wait for (T/2); 
            i_clk <= '0';
        end loop;
        wait;
    end process;

    i_rf_proc : process
        constant T : time := 1200 ns; -- 833kHz
    begin
        wait for (T/4);
        for i in 0 to 100 loop
            wait for (T/2); 
            i_rf <= '1';
            wait for (T/2); 
            i_rf <= '0';
        end loop;
        wait;
    end process;
END tb;
