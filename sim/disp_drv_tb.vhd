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
    signal i_dec : std_logic_vector(7 downto 0) := (others => '0');
    signal o_seg : std_logic_vector(3*7-1 downto 0) := (others => '0');
begin
    disp_drv_0 : entity work.disp_tst
    generic map(
        R => 8,
        N => 3
    )
    port map(
        i_clk => i_clk, 
        o_seg => o_seg
    );

    i_clk_proc : process
        constant T : time := 1 us; -- 1MHz
    begin
        for i in 0 to 10*(2**20)-1 loop
            wait for (T/2); 
            i_clk <= '1';
            wait for (T/2); 
            i_clk <= '0';
        end loop;
        wait;
    end process;
    
END tb;
