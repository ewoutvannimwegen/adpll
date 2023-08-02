library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- Phase to Digital
entity p2d is
    generic (
        R : natural := 8; -- Resolution error
        N : natural := 16 -- Number of FF's
    );
    port (
        i_clk : in  std_logic;                     -- System clock
        i_rf  : in  std_logic;                     -- Reference clock
        i_fb  : in  std_logic;                     -- Feedback clock
        i_rst : in  std_logic;                     -- Reset
        o_vld : out std_logic;                     -- Valid error
        o_er  : out std_logic_vector(R-1 downto 0) -- Error
    );
end p2d;

-- The phase/frequency error is processed by 2 subsystems
-- The sign of the error is determined by the first system
-- The absolute value of the error by the second
architecture bhv of p2d is

    -- Phase Frequency Detector
    component pfd is
    port (
        i_rf  : in  std_logic; -- Reference clock
        i_fb  : in  std_logic; -- Feedback clock
        i_rst : in  std_logic; -- Reset
        o_up  : out std_logic; -- Up pulse
        o_dn  : out std_logic  -- Down pulse
    );
    end component;
   
    -- Time Digital Converter
    component tdc is
    generic (
        L : natural := 7 -- Resolution absolute error 
    );
    port (
        i_rf  : in  std_logic;                     -- Reference clock
        i_rst : in  std_logic;                     -- Reset
        i_ep  : in  std_logic;                     -- Error pulse
        o_vld : out std_logic;                     -- Valid error
        o_ab  : out std_logic_vector(L-1 downto 0) -- Absolute error 
    );
    end component;
    
    -- Shift counter
    component scntr is
    generic (
        L : natural := 512; -- Length carry chain
        N : natural := N   -- Number of FF's; Currently only 16 is supported!
    );
    port (
        i_clk  : in  std_logic;                     -- Reference clock
        i_rst : in  std_logic;                     -- Reset
        i_in  : in  std_logic;                     -- Input data
        i_en : in std_logic;                     -- Enable
        o_out  : out std_logic_vector(natural(ceil(log2(real(N))))-1 downto 0); -- Absolute error 
        o_flw : out std_logic  -- Overflow
    );
    end component;

    signal up   : std_logic := '0';                                  -- Up pulse
    signal dn   : std_logic := '0';                                  -- Down pulse
    signal sign : std_logic := '0';                                  -- Error sign
    signal ep   : std_logic := '0';                                  -- Error pulse
    signal ab   : std_logic_vector(R-2 downto 0) := (others => '0'); -- Absolute error
    signal vld  : std_logic := '0';
    
    signal en   : std_logic := '0';

begin

    -- Phase Frequency Detector
    pfd_0 : pfd
    port map(
        i_rf  => i_rf,
        i_fb  => i_fb,
        i_rst => i_rst,
        o_up  => up,
        o_dn  => dn
    );

    -- Time Digital Converter
    tdc_0 : tdc
    generic map(
        L => R-1
    )
    port map(
        i_rf  => i_clk,
        i_rst => i_rst,
        i_ep  => ep,
        o_vld => vld
    );
    
    scntr_0 : scntr
    generic map(
        L => 512,
        N => N 
    )
    port map(
        i_clk  => i_clk,
        i_rst => i_rst,
        i_in  => ep,
        i_en => en,
        o_out  => ab(natural(ceil(log2(real(N))))-1 downto 0)
    );

    ep <= up or dn; -- Construct the error pulse 

    en <= not vld; -- Keep chain enabled till coinciding clocks

    o_vld <= vld;

    -- Determine the sign of the error
    process(i_rst, dn) 
    begin
        if i_rst = '1' then
            sign <= '0';
        elsif rising_edge(dn) then
            sign <= up;
        else
            sign <= sign;
        end if;
    end process;

    -- Construct the digital error value
    process(sign, ab) 
    begin
        if sign = '1' then
            -- Negative 
            o_er <= std_logic_vector(signed(not std_logic_vector(resize(unsigned(ab), o_er'length))) + 1); -- 2's comp inverse
        else 
            -- Positive
            o_er <= std_logic_vector(resize(unsigned(ab), o_er'length));
        end if;
    end process;

end bhv;
