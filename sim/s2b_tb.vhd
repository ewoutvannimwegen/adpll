library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity s2b_tb is
end s2b_tb;

architecture tb of s2b_tb is
    constant R : natural := 7; -- Resolution output
    signal i_clk : std_logic := '0';
    signal i_rst : std_logic := '0';
    signal i_in  : std_logic_vector(2**R-1 downto 0) := (others => '0');
    signal o_out : std_logic_vector(R-1 downto 0) := (others => '0');
begin
    s2b_0 : entity work.s2b
    generic map(
        R => R
    )
    port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_in  => i_in,
        o_out => o_out
    );
    
    i_clk_proc : process
        constant T : time := 20 ns; -- 50MHz
    begin
        for i in 0 to 500 loop
            wait for (T/2); 
            i_clk <= '1';
            wait for (T/2); 
            i_clk <= '0';
        end loop;
        wait;
    end process;

    i_in_proc : process
    begin
        i_rst <= '1';
        wait for 1 us;
        i_rst <= '0';
        wait for 1 us;

        wait until falling_edge(i_clk);

        i_in <= std_logic_vector(to_unsigned(13, i_in'length));
        wait until falling_edge(i_clk);
        
        i_in <= std_logic_vector(to_unsigned(3, i_in'length));
        wait until falling_edge(i_clk);

        wait;
    end process;
END tb;
