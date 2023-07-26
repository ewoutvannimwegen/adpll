library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity pfdv2_tb is
end pfdv2_tb;

architecture tb of pfdv2_tb is
    constant RES : natural := 8;
    signal i_clk : std_logic := '0';
    signal i_ref : std_logic := '0';
    signal i_fb  : std_logic := '0';
    signal o_up  : std_logic_vector(RES-1 downto 0) := (others => '0');
    signal o_dn  : std_logic_vector(RES-1 downto 0) := (others => '0');
begin
    pfdv2_0 : entity work.pfdv2
    generic map(
        RES => RES
    )
    port map(
        i_clk => i_clk,
        i_rst => '0',
        i_ref => i_ref,
        i_fb  => i_fb,
        o_up  => o_up,
        o_dn  => o_dn
    );
    
    i_clk_proc : process
        constant T : time := 20 ns; -- 50MHz
    begin
        wait for (T/2); 
        i_clk <= '1';
        wait for (T/2); 
        i_clk <= '0';
    end process;

    i_ref_proc : process
        constant T : time := 1 us; -- 1MHz 
    begin
        wait for (T/2); 
        i_ref <= '1';
        wait for (T/2); 
        i_ref <= '0';
    end process;
    
    i_fb_proc : process
        constant T : time := 1 us; -- 1MHz 
    begin
        wait for (T/2); 
        i_fb <= '0';
        wait for (T/2); 
        i_fb <= '1';
    end process;
END tb;
