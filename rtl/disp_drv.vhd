library IEEE;
library unisim;
use IEEE.STD_LOGIC_1164.ALL;
use unisim.vcomponents.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.common.all;

-- Display
entity disp_drv is
    generic (
        N : natural := 3 -- Number of 7-segment displays
    );
    port (
        i_clk : in  std_logic;                    -- System clock
        i_rst : in  std_logic;                    -- Reset
        i_dec : in  std_logic_vector(6 downto 0); -- Decimal in
        o_seg : out std_logic_vector(7*N-1 downto 0) -- Segment out
    );
end disp_drv;

architecture bhv of disp_drv is
    attribute dont_touch : string;

    -- Digits array
    signal bcd : std_logic_vector(4*N-1 downto 0) := (others => '0');

    -- Binary to Segment
    component bin2seg is
    port (
        i_bcd : in  std_logic_vector(3 downto 0);
        o_seg : out std_logic_vector(6 downto 0)
    );
    end component;

begin
    bin2seg_gen : for i in 0 to N-1 generate
        bin2seg_i : bin2seg
        port map(
            i_bcd => bcd(4*i+4-1 downto 4*i),
            o_seg => o_seg(7*i+7-1 downto 7*i)
        );
    end generate;

    process(i_rst, i_clk) 
    begin
        if i_rst = '1' then
            bcd <= (others => '0');
        elsif rising_edge(i_clk) then
            if to_integer(unsigned(i_dec)) > 0 then
                bcd <= std_logic_vector(resize(unsigned(work.common.dec2bcd(i_dec)), bcd'length));
            end if;
        end if;
    end process;

end bhv;
