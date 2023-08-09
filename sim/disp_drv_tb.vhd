library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity disp_drv_tb is
end disp_drv_tb;

architecture tb of disp_drv_tb is
    signal i_clk : std_logic := '0';
    signal i_rst : std_logic := '0';
    signal i_dec : std_logic_vector(6 downto 0) := (others => '0');
    signal o_seg : std_logic_vector(3*7-1 downto 0) := (others => '0');
begin
    disp_drv_0 : entity work.disp_drv
    generic map(
        N => 3
    )
    port map(
        i_clk => i_clk, 
        i_rst => i_rst,
        i_dec  => i_dec,
        o_seg => o_seg
    );

    i_clk_proc : process
        constant T : time := 20 ns; -- 50MHz
    begin
        for i in 0 to 10-1 loop
            wait for (T/2); 
            i_clk <= '1';
            wait for (T/2); 
            i_clk <= '0';
        end loop;
        wait;
    end process;
    
    disp_drv_proc : process
    begin
        i_dec <= (others => '0');
        i_rst <= '1';
        wait for 1 ns;
        i_rst <= '0';
        wait for 1 ns;

        wait until falling_edge(i_clk);
        wait until falling_edge(i_clk);
        i_dec <= std_logic_vector(to_unsigned(102, i_dec'length));
        wait until falling_edge(i_clk);
        i_dec <= std_logic_vector(to_unsigned(52, i_dec'length));
        wait until falling_edge(i_clk);

        wait;
    end process;
END tb;
