library IEEE;
library unisim;
use IEEE.STD_LOGIC_1164.ALL;
use unisim.vcomponents.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.common.all;

-- Analog Digital Converter
entity adc is
    generic (
        R : natural := 8; -- Resolution error
        N : natural := 128 -- Number of FF's
    );
    port (
        i_clk : in  std_logic;                     -- System clock
        i_in  : in  std_logic;                     -- Input signal
        i_rf  : in  std_logic;                     -- Reference clock 
        i_rst : in  std_logic;                     -- Reset
        o_rf  : out std_logic;                     -- Reference clock
        o_out : out std_logic_vector(R-1 downto 0) -- Digital output
    );
end adc;

architecture bhv of adc is
    attribute dont_touch : string;

    -- Shift counter 
    component scntr is
    generic (
        L : natural := 4*work.common.CC_MAX_LEN; -- Length carry chain
        N : natural := N;
        X : integer := 0;
        Y : integer := 0
    );
    port (
        i_trg : in  std_logic;                     -- Trigger
        i_clk : in  std_logic;                     -- System clock
        i_rst : in  std_logic;                     -- Reset
        i_in  : in  std_logic;                     -- Input data
        o_out : out std_logic_vector(R-2 downto 0) -- Absolute error 
    );
    end component;

    signal rf           : std_logic := '0';
    signal lvds         : std_logic := '0';
    signal scntr_re_out : std_logic_vector(R-2 downto 0) := (others => '0');
    signal scntr_fe_trg : std_logic := '0';
    signal scntr_fe_in  : std_logic := '0';
    signal scntr_fe_out : std_logic_vector(R-2 downto 0) := (others => '0');

begin
    o_rf <= rf;
    rf   <= not i_clk; -- Apply inverter to create a 180 degree phase shift 
   
    -- Differential input buffer
    LVDS_0 : IBUFDS
    generic map (
       DIFF_TERM => FALSE, -- Differential Termination
       IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
       IOSTANDARD => "DEFAULT")
    port map (
       O => lvds,  -- Buffer output
       I => i_rf,  -- Diff_p buffer input (connect directly to top-level port)
       IB => i_in -- Diff_n buffer input (connect directly to top-level port)
    );

    -- Shift counter (carry chain) rising edge
    scntr_re : scntr
    generic map(
        L => 512,
        N => N,
        X => 60,
        Y => 0
    )
    port map(
        i_trg => rf,
        i_clk => i_clk,
        i_rst => i_rst,
        i_in  => lvds,
        o_out => scntr_re_out
    );

    scntr_fe_trg <= not rf;
    scntr_fe_in  <= not lvds;

    -- Shift counter (carry chain) falling edge
    scntr_fe : scntr
    generic map(
        L => 512,
        N => N,
        X => 61,
        Y => 0
    )
    port map(
        i_trg => scntr_fe_trg,
        i_clk => i_clk,
        i_rst => i_rst,
        i_in  => scntr_fe_in,
        o_out => scntr_fe_out 
    );

    -- Digital output is TDC rising edge minus TDC falling edge
    process(i_rst, i_clk) begin
        if i_rst = '1' then
            o_out <= (others => '0');
        elsif rising_edge(i_clk) then
            o_out <= std_logic_vector(resize(unsigned(scntr_re_out) + 
                     unsigned(signed(not scntr_fe_out) + 1), o_out'length)); -- 2's comp inverse
        end if;
    end process;

end bhv;
