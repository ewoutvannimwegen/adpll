library IEEE;
library unisim;
use IEEE.STD_LOGIC_1164.ALL;
use unisim.vcomponents.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.common.all;

-- Analog Digital Converter Top Level
entity disp_tst is
    generic (
        R : natural := 8; 
        N : natural := 3  
    );
    port (
        i_clk : in  std_logic;                       -- System clock
        i_nrst : in  std_logic;                      -- Reset
        o_seg : out std_logic_vector(7*N-1 downto 0) -- Digital output
    );
end disp_tst;

architecture bhv of disp_tst is
    attribute dont_touch : string;

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

    signal pre : std_logic_vector(26 downto 0) := (others => '0');
    signal cnt : std_logic_vector(R-1 downto 0) := (others => '0');
    signal rst : std_logic := '0';

begin
    
    rst <= not i_nrst;

    disp_drv_inst : disp_drv 
    generic map (
        R => R,
        N => N 
    )
    port map(
        i_clk => i_clk,
        i_rst => rst,
        i_dec => cnt,
        o_seg => o_seg
    );

    process(rst, i_clk) 
    begin
        if rst = '1' then
            pre <= (others => '0');
            cnt <= (others => '0');
        elsif rising_edge(i_clk) then
            pre <= std_logic_vector(unsigned(pre) + 1);
            -- 1MHz pre count so we count on 1 sec
            if pre(pre'high) = '1' then
                cnt <= std_logic_vector(unsigned(cnt) + 1);
                pre <= (others => '0');

                -- Only 1 7-seg connected so lets not go further than that one
                if cnt(3) = '1' and cnt(0) = '1' then
                    cnt <= (others => '0');
                end if;
            end if;
        end if;
    end process;
end bhv;
