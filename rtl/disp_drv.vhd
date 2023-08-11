library IEEE;
library unisim;
use IEEE.STD_LOGIC_1164.ALL;
use unisim.vcomponents.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.common.all;

-- Display Driver
-- Very basic implementation for now, not scalable at all
entity disp_drv is
    generic (
        R : natural := 8; -- Resolution input
        N : natural := 3 -- Number of 7-segment displays
    );
    port (
        i_clk : in  std_logic;                    -- System clock
        i_rst : in  std_logic;                    -- Reset
        i_dec : in  std_logic_vector(R-1 downto 0); -- Decimal in
        o_seg : out std_logic_vector(7*N-1 downto 0) -- Segment out
    );
end disp_drv;

architecture bhv of disp_drv is
    attribute dont_touch : string;

    -- Digits array
    signal bcd : std_logic_vector(4*N-1 downto 0) := (others => '0');

    -- Binary to Segment
    component bin2seg is
    generic (
        M : std_logic := '0' -- Mode 0: cathode, 1: anode
    );
    port (
        i_bcd : in  std_logic_vector(3 downto 0);
        o_seg : out std_logic_vector(6 downto 0)
    );
    end component;

begin
    gen_bin2seg : for i in 0 to N-1 generate
        bin2seg_i : bin2seg
        generic map(
            M => '0'
        )
        port map(
            i_bcd => bcd(4*i+4-1 downto 4*i),
            o_seg => o_seg(7*i+7-1 downto 7*i)
        );
    end generate gen_bin2seg;

    gen_seg_1 : if N = 1 generate
        process(i_rst, i_clk) 
        begin
            if i_rst = '1' then
                bcd <= (others => '0');
            elsif rising_edge(i_clk) then
                bcd(3 downto 0) <= std_logic_vector(resize(
                    unsigned(i_dec) - unsigned(i_dec) / 100 * 100, 4));
            end if;
        end process;
    end generate gen_seg_1;
    gen_seg_2 : if N = 2 generate
        process(i_rst, i_clk) 
        begin
            if i_rst = '1' then
                bcd <= (others => '0');
            elsif rising_edge(i_clk) then
                bcd(7 downto 4) <= std_logic_vector(resize(
                    (unsigned(i_dec) - unsigned(i_dec) / 100 * 100) / 10, 4));
                bcd(3 downto 0) <= std_logic_vector(resize(
                    unsigned(i_dec) - unsigned(i_dec) / 100 * 100, 4));
            end if;
        end process;
    end generate gen_seg_2;
    gen_seg_3 : if N = 3 generate
        process(i_rst, i_clk) 
        begin
            if i_rst = '1' then
                bcd <= (others => '0');
            elsif rising_edge(i_clk) then
                bcd(11 downto 8) <= std_logic_vector(resize(unsigned(i_dec) / 100, 4));
                bcd(7 downto 4) <= std_logic_vector(resize(
                    (unsigned(i_dec) - unsigned(i_dec) / 100 * 100) / 10, 4));
                bcd(3 downto 0) <= std_logic_vector(resize(
                    unsigned(i_dec) - unsigned(i_dec) / 100 * 100, 4));
            end if;
        end process;
    end generate gen_seg_3;
end bhv;
