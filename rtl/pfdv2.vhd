library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pfdv2 is
    generic (
        RES : natural := 1
    );
    port (
        i_clk : in  std_logic;
        i_rst : in  std_logic;
        i_ref : in  std_logic;                   
        i_fb  : in  std_logic; 
        o_up  : out std_logic_vector(RES-1 downto 0);
        o_dn  : out std_logic_vector(RES-1 downto 0)
    );
end pfdv2;

architecture bhv of pfdv2 is
    signal rst     : std_logic;
    signal up_cnt  : std_logic_vector(RES-1 downto 0) := (others => '0');
    signal dn_cnt  : std_logic_vector(RES-1 downto 0) := (others => '0');
begin
    o_up <= up_cnt;
    o_dn <= dn_cnt;
   
    process(up_cnt, dn_cnt) 
    begin
        if (up_cnt = dn_cnt) and (to_integer(unsigned(up_cnt)) /= 0) then
            rst <= '1';
        else 
            rst <= '0';
        end if;
    end process;

    process(i_rst, i_clk)
    begin
        if i_rst = '1' then
            up_cnt <= (others => '0');
            dn_cnt <= (others => '0');
        elsif rising_edge(i_clk) then
            if rst = '1' then
                up_cnt <= (others => '0');
                dn_cnt <= (others => '0');
            elsif i_ref = '1' and i_fb = '0' then
                up_cnt <= std_logic_vector(unsigned(up_cnt) + 1);
            elsif i_ref = '0' and i_fb = '1' then
                dn_cnt <= std_logic_vector(unsigned(dn_cnt) + 1);
            end if;
        end if;
    end process;
end bhv;
