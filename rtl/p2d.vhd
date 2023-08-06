library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.common.all;
-- Phase to Digital
entity p2d is
    generic (
        R : natural := 8; -- Resolution error
        N : natural := 128 -- Number of FF's
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
    attribute dont_touch : string;

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
   
    -- Shift counter
    component scntr is
    generic (
        L : natural := 4*work.common.CC_MAX_LEN; -- Length carry chain
        N : natural := N   
    );
    port (
        i_trg : in  std_logic;                     -- Trigger
        i_clk : in  std_logic;                     -- System clock
        i_rst : in  std_logic;                     -- Reset
        i_in  : in  std_logic;                     -- Input data
        o_out : out std_logic_vector(R-2 downto 0) -- Absolute error 
    );
    end component;

    signal up   : std_logic := '0'; -- Up pulse
    signal dn   : std_logic := '0'; -- Down pulse
    signal sign : std_logic := '0'; -- Error sign
    signal ep   : std_logic := '0'; -- Error pulse
    signal lvl  : std_logic := '0'; -- Logic level last coincide
    signal vld  : std_logic_vector(5 downto 0)   := (others => '0'); -- Valid 
    attribute dont_touch of vld : signal is "true";
    signal ab   : std_logic_vector(R-2 downto 0) := (others => '0'); -- Absolute phase error
    attribute dont_touch of ab : signal is "true";
    signal trg : std_logic := '0'; -- Trigger
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

    -- Shift counter (carry chain)
    scntr_0 : scntr
    generic map(
        L => 512,
        N => N 
    )
    port map(
        i_trg => trg,
        i_clk => i_clk,
        i_rst => i_rst,
        i_in  => ep,
        o_out => ab
    );

    ep     <= up or dn; -- Construct the error pulse 
    o_vld  <= vld(vld'length-1);

    -- Determine the sign of the error
    process(i_rst, dn) 
    begin
        if i_rst = '1' then
            sign <= '0';
        elsif rising_edge(dn) then
            sign <= up;
        end if;
    end process;

    -- Construct the digital error value
    process(sign, ab) 
    begin
        if sign = '1' then
            -- Negative 
            o_er <= std_logic_vector(signed(not ('0' & ab)) + 1); -- 2's comp inverse
        else 
            -- Positive
            o_er <= '0' & ab;
        end if;
    end process;

    -- Track logic level of last coincide & trigger the tapped delay line
    process(i_rst, i_clk) begin
        if i_rst = '1' then
            lvl <= '0';
            trg <= '0'; 
            vld <= (others => '0'); 
        elsif rising_edge(i_clk) then
            vld(0) <= trg;
            for i in 1 to vld'length-1 loop
                vld(i) <= vld(i-1);
            end loop;

            if lvl = '0' then
                if ep = '1' then
                    -- Lead/lag detected
                    trg <= '0';
                    lvl <= '1';
                else
                    -- Wait for lead/lag
                    null;
                end if;
            elsif lvl = '1' then
                if ep = '0' then
                    -- Coincided
                    trg <= '1';
                    lvl <= '0';
                else 
                    -- Leading/lagging
                    null;
                end if;
            end if; 
        end if;
    end process;
end bhv;
