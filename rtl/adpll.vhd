library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- All Digital Phase Lock Loop
entity adpll is
    generic (
        R : natural := 8 -- Resolution error
    );
    port (
        i_clk : in  std_logic; -- System clock
        i_rf  : in  std_logic; -- Reference clock
        i_rst : in  std_logic; -- Reset
        i_step : in std_logic_vector(R-1 downto 0); -- Step coefficient
        o_gen : out std_logic  -- Generated clock
    );
end adpll;

architecture bhv of adpll is

    -- Phase to Digital
    component p2d is
    generic (
        R : natural := 8 -- Resolution error
    );
    port (
        i_clk : in  std_logic;                      -- System clock
        i_rf  : in  std_logic;                      -- Reference clock
        i_fb  : in  std_logic;                      -- Feedback clock
        i_rst : in  std_logic;                      -- Reset
        o_vld : out std_logic;                      -- Valid error
        o_er  : out std_logic_vector(R-1 downto 0)  -- Error
    );
    end component;
   
    -- Digitally Controlled Oscillator
    component dco is
    generic (
        R : natural := 8; -- Resolution error
        TDLM : std_logic := '1' -- Tapped Delay Line Mode
    );
    port (
        i_clk  : in  std_logic;                      -- System clock
        i_rst  : in  std_logic;                      -- Reset
        i_step : in  std_logic_vector(R-1 downto 0);   -- Step size
        i_pe   : in  std_logic_vector(R-1 downto 0); -- Phase error
        i_vld  : in  std_logic;                      -- Valid error
        o_gen  : out std_logic                       -- Generated clock
    );
    end component;

    signal fb : std_logic := '0'; -- Feedback clock 
    signal pe : std_logic_vector(R-1 downto 0) := (others => '0'); -- Phase error
    signal vld : std_logic := '0'; -- Valid phase error

begin

    -- Phase to Digital
    p2d_0 : p2d
    generic map(
        R => R
    )
    port map(
        i_clk  => i_clk,
        i_rf   => i_rf,
        i_fb   => fb,
        i_rst  => i_rst,
        o_vld  => vld,
        o_er   => pe
    );

    -- Digitally Controlled Oscillator
    dco_0 : dco 
    generic map(
        R => R,
        TDLM => '1'
    )
    port map(
        i_clk  => i_clk,
        i_rst  => i_rst,
        i_step => i_step,
        i_pe   => pe,
        i_vld  => vld,
        o_gen  => fb
    );

    o_gen <= fb;

end bhv;
