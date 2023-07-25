library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity pfd_tb is
end pfd_tb;

architecture tb of pfd_tb is
    signal i_ref : std_logic := '0';
    signal i_fb  : std_logic := '0';
    signal o_up  : std_logic := '0';
    signal o_dn  : std_logic := '0';
begin
    pfd_0 : entity work.pfd
    port map(
        i_ref => i_ref,
        i_fb  => i_fb,
        o_up  => o_up,
        o_dn  => o_dn
    );

    i_ref_proc : process
        constant T : time := 20 ns; -- 50MHz
    begin
        wait for (T/2); 
        i_ref <= '1';
        wait for (T/2); 
        i_ref <= '0';
    end process;
    
    i_fb_proc : process
        constant T : time := 20 ns; -- 50MHz
    begin
        wait for (T/2); 
        i_fb <= '0';
        wait for (T/2); 
        i_fb <= '1';
    end process;
END tb;
