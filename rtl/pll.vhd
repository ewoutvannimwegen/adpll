library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pll is
    generic (
        RES : natural := 4
    );
    port (
        i_clk        : in  std_logic;
        i_rst        : in  std_logic;
        i_in         : in  std_logic;
        i_step       : in  std_logic_vector(3 downto 0); 
        o_out        : out std_logic  
    );
end pll;

architecture bhv of pll is
    signal cnt : std_logic_vector (RES-1 downto 0):= (others => '0');
    signal lead : std_logic := '0';
begin
    o_out <= cnt(RES-1);

    process(i_in, cnt(RES-1)) 
    begin
        if i_in = '1' and cnt(RES-1) = '0' then
             
        elsif i_in = '0' and cnt(RES-1) = '1' then

        end if
    end process;

    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            cnt <= (others => '0');
            lead <= '0';
        elsif rising_edge(i_clk) then
            -- Use signed counting as cheap 50% duty cycle
            cnt <= std_logic_vector(signed(cnt) + signed(i_step));
        end if;
    end process;
end bhv;
