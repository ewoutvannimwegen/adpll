library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.common.all;
-- Digital Controlled Oscillator
entity dco is
    generic(
        R : natural := 8 -- Resolution error
    );
    port (
        i_clk  : in  std_logic;                      -- System clock
        i_rst  : in  std_logic;                      -- Reset
        i_step : in  std_logic_vector(3 downto 0);   -- Step coefficient
        i_pe   : in  std_logic_vector(R-1 downto 0); -- Phase error
        i_vld  : in  std_logic;                      -- Valid error
        o_gen  : out std_logic                       -- Generated clock
    );
end dco;

-- Use of the step coefficient instead of direct step size to avoid using mulitiplications
-- After finding a valid phase error the correction is only applied once.
architecture bhv of dco is
    signal cnt  : std_logic_vector(R-1 downto 0) := (others => '0'); -- Internal counter
    signal ab   : std_logic_vector(R-1 downto 0) := (others => '0'); -- Absolute phase error in steps
    signal cor  : std_logic := '0';                                  -- Phase correction flag
    signal step : std_logic_vector(3 downto 0) := (others => '0');   -- Step size 
begin
    o_gen <= cnt(R-1); -- Generate clock based on MSB of internal counter

    -- Step size = 1 << step coefficient
    step <= std_logic_vector(shift_left(to_unsigned(1, i_step'length), 
             to_integer(unsigned(i_step))));

    -- Convert phase error in cycles to ABS in steps
    -- Phase error is in cycles, multiply by steps per cycle!
    process(i_pe, i_step) 
    begin
        if i_pe(R-1) = '1' then
            -- Negative
            ab <= std_logic_vector(shift_left(unsigned(
                  std_logic_vector(signed(not i_pe) + 1) -- 2's comp inverse
              ), to_integer(unsigned(i_step))));         -- Cycles * step size
        else 
            -- Positive
            ab <= std_logic_vector(shift_left(unsigned(i_pe), 
                  to_integer(unsigned(i_step)))); -- Cycles * step cycles
        end if;
    end process;

    process(i_rst, i_clk) 
    begin
        if i_rst = '1' then
            cnt <= (others => '0');
            cor <= '1';
        elsif rising_edge(i_clk) then
            if i_vld = '1'  then
                -- Phase error valid
                if cor = '1' then
                    -- Phase not yet corrected 
                    if i_pe(R-1) = '1' then
                        -- Lagging; Speed up
                        cnt <= std_logic_vector(unsigned(cnt) + unsigned(ab) + 
                               unsigned(step));
                    else
                        -- Leading; Slow down
                        if cnt(R-1) = '1' and ((unsigned(cnt)-(2**cnt'length)/2) < unsigned(ab)) then
                            -- Clock glitch
                            cnt <= cnt;
                        elsif cnt(R-1) = '0' and (unsigned(cnt) < unsigned(ab)) then
                            -- Clock glitch
                            cnt <= cnt;
                        else
                            assert false report "cnt|" & to_string(cnt) & "|ab|" & 
                                to_string(ab) & "|cnt high|" & 
                                to_string(std_logic_vector(to_unsigned(
                                2**cnt'length-1, cnt'length))) severity note;
                            -- No clock glitch
                            cnt <= std_logic_vector(unsigned(cnt) - unsigned(ab) + 
                                   unsigned(step));
                        end if;
                    end if;
                    cor <= '0';
                else
                    -- Phase already corrected
                    cnt <= std_logic_vector(unsigned(cnt) + unsigned(step));
                end if;
            else
                -- Phase error invalid
                cnt <= std_logic_vector(unsigned(cnt) + unsigned(step));
                cor <= '1'; -- Allow new phase correction
            end if;
        end if;
    end process;
end bhv;
