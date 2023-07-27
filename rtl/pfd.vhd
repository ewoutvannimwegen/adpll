library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Phase Frequency Detector
entity pfd is
    port (
        i_rf  : in  std_logic; -- Reference clock
        i_fb  : in  std_logic; -- Feedback clock
        i_rst : in  std_logic; -- Reset
        o_up  : out std_logic; -- Up pulse 
        o_dn  : out std_logic  -- Down pulse
    );
end pfd;

-- Produces up/dn pulse with logic high duration proportional to phase difference
-- Period of produced pulse corresponds to the period of the reference & feedback clock
-- Either up/dn goes high first, reveals if leading/lagging
-- The lead/lag pulse stays at '1' till rising edge other clock
-- At coincide a reset is applied & the pulse returns to '0'
architecture bhv of pfd is
    signal up  : std_logic := '0';
    signal dn  : std_logic := '0';
    signal rst : std_logic := '0';
begin
    o_up <= up;
    o_dn <= dn;
    rst  <= up and dn; -- Reset if rf & fb coincide at logic high
    process(i_rst, rst, i_rf, i_fb)
    begin
        if i_rst = '1' or rst = '1' then
            up <= '0';
            dn <= '0';
        else 
            if rising_edge(i_rf) then
                up <= '1';
            end if;
            if rising_edge(i_fb) then 
                dn <= '1';
            end if;
        end if;
    end process;
end bhv;
