library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pll is
    generic (
        RES : natural := 8
    );
    port (
        i_clk        : in  std_logic;                    -- System clock
        i_rst        : in  std_logic;                    -- Reset
        i_in         : in  std_logic;                    -- Ref input clock
        i_step       : in  std_logic_vector(7 downto 0); -- Step size
        i_lgcoef     : in  std_logic_vector(3 downto 0); -- Loop gain coefficient
        o_out        : out std_logic                     -- Gen output clock
    );
end pll;

architecture bhv of pll is
    signal cnt  : std_logic_vector(RES-1 downto 0)             := (others => '0'); -- Internal counter
    signal msb  : std_logic                                    := '0'; -- MSB internal counter
    signal lvl  : std_logic                                    := '0'; -- 0 : low, 1 : high
    signal lead : std_logic                                    := '0'; -- 0 : lag, 1 : lead
    signal err  : std_logic                                    := '0'; -- Phase error
    signal corr : std_logic_vector(i_lgcoef'length-1 downto 0) := (others => '0'); -- Correction  
begin
    msb   <= cnt(RES-1);
    err   <= i_in xor msb; -- 0 : coincide, 1 : leading or lagging
    o_out <= msb;

    -- Track clock level at coincide 
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            lvl <= '0';
        elsif rising_edge(i_clk) then
            if i_in = '1' and msb = '1' then
                -- Coincide high
                lvl <= '1';
            elsif i_in = '0' and msb = '0' then
                -- Coincide low 
                lvl <= '0';
            else
                -- Leading or lagging
                null;
            end if;
        end if;
    end process;

    -- Track leading or lagging
    process(i_in, msb, lvl)
    begin
        if lvl = '1' then 
            -- Last coincided high
            lead <= i_in and (not msb);
        else              
            -- Last coincided low
            lead <= (not i_in) and msb;
        end if;
    end process;

    -- Reduce lead or lag 
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            cnt <= (others => '0');
            corr <= (others => '0');
        elsif rising_edge(i_clk) then

            corr <= std_logic_vector(shift_left(to_unsigned(1, i_lgcoef'length), 
                    to_integer(unsigned(i_lgcoef))));

            if err = '0' then
                -- Coincide
                cnt <= std_logic_vector(signed(cnt) + signed(i_step));
            elsif err = '1' and lead = '1' then
                -- Leading 
                cnt <= std_logic_vector(signed(cnt) + signed(i_step) - signed(corr));
            elsif err = '1' and lead = '0' then
                -- Lagging
                cnt <= std_logic_vector(signed(cnt) + signed(i_step) + signed(corr));
            else
                null;
            end if; 
        end if;
    end process;
end bhv;
