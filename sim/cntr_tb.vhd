library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity cntr_tb is
end cntr_tb;

architecture tb of cntr_tb is
    signal i_clk : std_logic := '0';
    signal i_rst : std_logic := '0';
    signal i_in  : std_logic := '0';
    signal cntr_o_out : std_logic_vector(15 downto 0) := (others => '0');
    signal scntr_o_out : std_logic_vector(6 downto 0) := (others => '0');
begin
    cntr_0 : entity work.cntr
    port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_in  => '1',
        o_out => cntr_o_out
    );
    
    scntr_0 : entity work.scntr
    port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_in  => i_in,
        o_out => scntr_o_out
    );

    i_clk_proc : process
        constant T : time := 20 ns; -- 50MHz
    begin

        i_rst <= '1';
        wait for 1 us;
        i_rst <= '0';
        wait for 1 us;

        for i in 0 to 100 loop
            wait for (T/2); 
            i_clk <= '1';
            wait for (T/2); 
            i_clk <= '0';
        end loop;
        wait;
    end process;
   
    i_in_proc : process
    begin
        wait for 2 us; 
        i_in <= '1';
       
        for i in 0 to 4 loop
            wait for 10 us;
            i_in <= not i_in;
        end loop;
        
        wait;

    end process;
END tb;
