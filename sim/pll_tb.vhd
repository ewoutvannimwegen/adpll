library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity pll_tb is
end pll_tb;

architecture tb of pll_tb is
    constant SYSCLK_PERIOD  : time    := 500 ns; -- 2MHz
    constant CYCLES         : natural := 500;

    signal clk : std_logic := '0';
    signal led : std_logic := '0';
begin
    clock : process
    begin
        -- Pick slowest
        for i in 0 to CYCLES-1 loop
            wait for (SYSCLK_PERIOD/2); 
            clk <= '1';
            wait for (SYSCLK_PERIOD/2); 
            clk <= '0';
        end loop;
        wait;
    end process;
    
    pll_0 : entity work.pll
    port map(
        i_clk => clk,
        i_rst => '0',
        i_in  => '0',
        i_step => "0010",
        o_out => led 
    );
   
END tb;
