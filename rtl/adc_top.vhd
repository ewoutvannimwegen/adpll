library IEEE;
library unisim;
use IEEE.STD_LOGIC_1164.ALL;
use unisim.vcomponents.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.common.all;

-- Analog Digital Converter Top Level
entity adc_top is
    generic (
        R : natural := 8;
        N : natural := 3 -- Number of 7-segment displays
    );
    port (
        i_clk : in  std_logic;                     -- System clock
        i_in  : in  std_logic;                     -- Input signal
        i_rf  : in  std_logic;                     -- Reference clock 
        i_rst : in  std_logic;                     -- Reset
        o_rf  : out std_logic;                     -- Reference clock
        o_seg : out std_logic_vector(7*N-1 downto 0) -- Digital output
    );
end adc_top;

architecture bhv of adc_top is
    attribute dont_touch : string;

    -- Analog to Digital Converter
    component adc
        generic (
            R : natural := 8;
            N : natural := 128
        );
        port (
            i_clk : in  std_logic;
            i_in  : in  std_logic;
            i_rf  : in  std_logic;
            i_rst : in  std_logic;
            o_rf  : out std_logic;
            o_out : out std_logic_vector(R-1 downto 0)
        );
    end component;

    -- Display driver
    component disp_drv is
    generic (
        R : natural := 8;
        N : natural := 3 -- Number of 7-segment displays
    );
    port (
        i_clk : in  std_logic;                       -- System clock
        i_rst : in  std_logic;                       -- Reset
        i_dec : in  std_logic_vector(R-1 downto 0);    -- Input data
        o_seg : out std_logic_vector(7*N-1 downto 0) -- 7-segment output
    );
    end component;

    signal dec : std_logic_vector(R-1 downto 0) := (others => '0');

begin

    adc_inst : adc
    generic map (
        R => R,
        N => 128
    )
    port map
    (
        i_clk => i_clk,
        i_in => i_in,
        i_rf => i_rf,
        i_rst => i_rst,
        o_rf => o_rf,
        o_out => dec
    );

    disp_drv_inst : disp_drv 
    generic map (
        R => R,
        N => 3
    )
    port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_dec => dec,
        o_seg => o_seg
    );

end bhv;
