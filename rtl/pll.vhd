library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pll is
    port (
        i_clk        : in  std_logic;
        i_rst        : in  std_logic;
        o_led        : out std_logic
    );
end pll;

architecture bhv of pll is
    signal led : std_logic := '0';
begin
    o_led <= led;
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            led <= '0';
        elsif rising_edge(i_clk) then
            led <= not led;
        end if;
    end process;
end bhv;
