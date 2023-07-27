library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity p2d_tb is
end p2d_tb;

architecture tb of p2d_tb is
    constant R : natural := 8;

    signal i_clk : std_logic := '0';
    signal i_rf  : std_logic := '0';
    signal i_fb  : std_logic := '0';
    signal o_er  : std_logic_vector(R-1 downto 0) := (others => '0');
begin
    p2d_0 : entity work.p2d
    generic map (
        R => R
    )
    port map(
        i_clk => i_clk,
        i_rf  => i_rf,
        i_fb  => i_fb,
        o_er  => o_er
    );

    i_clk_proc : process
        constant T : time := 20 ns; -- 50MHz
    begin
        for i in 0 to 50*100 loop
            wait for (T/2); 
            i_clk <= '0';
            wait for (T/2); 
            i_clk <= '1';
        end loop;
        wait;
    end process;

    i_rf_proc : process
        constant T : time := 1 us; -- 1MHz
    begin
        for i in 0 to 100 loop
            wait for (T/2); 
            i_rf <= '0';
            wait for (T/2); 
            i_rf <= '1';
        end loop;
        wait;
    end process;
    
    i_fb_proc : process
        constant T : time := 1 us; -- 1MHz
    begin
        wait for (T/4);
        for i in 0 to 100 loop
            wait for (T/2); 
            i_fb <= '0';
            wait for (T/2); 
            i_fb <= '1';
        end loop;
        wait;
    end process;
END tb;
