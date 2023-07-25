library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pfd is
    port (
        i_ref : in  std_logic;                   
        i_fb  : in  std_logic; 
        o_up  : out std_logic;
        o_dn  : out std_logic
    );
end pfd;

architecture bhv of pfd is
    signal up_cnt : std_logic := '0';
    signal dn_cnt : std_logic := '0';
    signal rst    : std_logic := '0';
begin
    o_up <= up_cnt;
    o_dn <= dn_cnt;
    rst  <= up_cnt and dn_cnt;
    process(rst, i_ref, i_fb)
    begin
        if rst = '1' then
            up_cnt <= '0';
            dn_cnt <= '0';
        else 
            if rising_edge(i_ref) then
                up_cnt <= '1';
            end if;
            if rising_edge(i_fb) then 
                dn_cnt <= '1';
            end if;
        end if;
    end process;
end bhv;
