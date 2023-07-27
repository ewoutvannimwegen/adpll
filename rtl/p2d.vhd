library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Phase to Digital
entity p2d is
    generic (
        R : natural := 8 -- Resolution error
    );
    port (
        i_clk : in  std_logic;                     -- System clock
        i_rf  : in  std_logic;                     -- Reference clock
        i_fb  : in  std_logic;                     -- Feedback clock
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
        i_rf : in  std_logic; -- Reference clock
        i_fb : in  std_logic; -- Feedback clock
        o_up : out std_logic; -- Up pulse
        o_dn : out std_logic  -- Down pulse
    );
    end component;
   
    -- Time Digital Converter
    component tdc is
    generic (
        L : natural := 7 -- Resolution absolute error 
    );
    port (
        i_rf : in std_logic;                      -- Reference clock
        i_ep : in std_logic;                      -- Error pulse
        o_ab : out std_logic_vector(L-1 downto 0) -- Absolute error 
    );
    end component;

    signal up   : std_logic := '0';                                  -- Up pulse
    signal dn   : std_logic := '0';                                  -- Down pulse
    signal sign : std_logic := '0';                                  -- Error sign
    signal ep   : std_logic := '0';                                  -- Error pulse
    signal ab   : std_logic_vector(R-2 downto 0) := (others => '0'); -- Absolute error

begin

    -- Phase Frequency Detector
    pfd_0 : pfd
    port map(
        i_rf => i_rf,
        i_fb => i_fb,
        o_up => up,
        o_dn => dn
    );

    -- Time Digital Converter
    tdc_0 : tdc
    generic map(
        L => R-1
    )
    port map(
        i_rf => i_clk,
        i_ep => ep,
        o_ab => ab    
    );

    ep <= up or dn; -- Construct the error pulse 

    -- Determine the sign of the error
    process(dn) 
    begin
        if rising_edge(dn) then
            sign <= up;
        end if;
    end process;

    -- Construct the digital error value
    process(sign, ab) 
        variable er : std_logic_vector(R-1 downto 0) := (others => '0'); -- Error
    begin
        er(R-2 downto 0) := ab;
        if sign = '1' then
            -- Negative number 
            er := std_logic_vector(signed(not er) + 1); -- 2's comp inverse
        end if;
        o_er <= er;
    end process;

end bhv;
