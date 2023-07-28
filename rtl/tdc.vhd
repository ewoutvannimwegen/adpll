library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Time Digital Conversion
entity tdc is
    generic(
        L : natural := 7 -- Resolution absolute error
    );
    port (
        i_rf  : in  std_logic;                     -- Reference clock
        i_rst : in  std_logic;                     -- Reset
        i_ep  : in  std_logic;                     -- Error pulse
        o_vld : out std_logic;                     -- Valid error
        o_ab  : out std_logic_vector(L-1 downto 0) -- Absolute error
    );
end tdc;

-- Counter is increased if error pulse is at logic high 
-- Counter is cleared if low-to-high transition occurs for error pulse
architecture bhv of tdc is
    signal lvl : std_logic                      := '0';
    signal cnt : std_logic_vector(L-1 downto 0) := (others => '0');
    signal vld : std_logic                      := '0';
begin
    o_ab  <= cnt;
    o_vld <= vld;
    process(i_rst, i_rf) begin
        if i_rst = '1' then
            cnt <= (others => '0');
            lvl <= '0';
            vld <= '0';
        elsif rising_edge(i_rf) then
            if lvl = '0' then
                if i_ep = '1' then
                    -- Lead/lag detected
                    vld               <= '0';
                    cnt(L-1 downto 1) <= (others => '0');
                    cnt(0)            <= '1';
                    lvl               <= '1';
                end if;
            elsif lvl = '1' then
                if i_ep = '0' then
                    -- Coincided
                    vld <= '1';
                    lvl <= '0';
                else 
                    -- Leading/lagging
                    cnt <= std_logic_vector(unsigned(cnt) + 1);
                end if;
            end if; 
        end if;
    end process;
end bhv;
