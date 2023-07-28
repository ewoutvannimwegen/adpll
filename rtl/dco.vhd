library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Digital Controlled Oscillator
entity dco is
    generic(
        R : natural := 8 -- Resolution error
    );
    port (
        i_clk  : in  std_logic;                      -- System clock
        i_rst  : in  std_logic;                      -- Reset
        i_step : in  std_logic_vector(3 downto 0);   -- Step size
        i_pe   : in  std_logic_vector(R-1 downto 0); -- Phase error
        i_vld  : in  std_logic;                      -- Valid error
        o_gen  : out std_logic                       -- Generated clock
    );
end dco;

architecture bhv of dco is
    signal cnt : std_logic_vector(R-1 downto 0) := (others => '0');
    signal ab  : std_logic_vector(R-1 downto 0) := (others => '0');
    signal cor : std_logic := '0'; -- Phase correction 
begin
    o_gen <= cnt(R-1); -- Generate clock based on MSB of internal counter

    -- Absolute of phase error
    -- Phase error is in cycles, multiply by steps per cycle!
    process(i_pe) 
    begin
        if i_pe(R-1) = '1' then
            -- Negative
            ab <= std_logic_vector(resize(unsigned(
                  std_logic_vector(signed(not i_pe) + 1) -- 2's comp inverse
              ) * unsigned(i_step), ab'length));         -- Cycles * step size
        else 
            -- Positive
            ab <= std_logic_vector(resize(unsigned(i_pe) * unsigned(i_step), ab'length)); -- Cycles * step size
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
                    -- Correct phase
                    if i_pe(R-1) = '1' then
                        -- Lagging; Speed up
                        cnt <= std_logic_vector(unsigned(cnt) + unsigned(ab) + unsigned(i_step));
                        cor <= '0'; 
                    else
                        -- Leading; Slow down
                        if unsigned(cnt) < unsigned(ab) then
                            -- Clock glitch
                            cnt <= cnt;
                        else
                            cnt <= std_logic_vector(unsigned(cnt) - unsigned(ab) + unsigned(i_step));
                            cor <= '0'; 
                        end if;
                    end if;
                else
                    -- Phase already corrected
                    cnt <= std_logic_vector(unsigned(cnt) + unsigned(i_step));
                end if;
            else
                -- Phase error invalid
                cnt <= std_logic_vector(unsigned(cnt) + unsigned(i_step));
                cor <= '1'; -- Allow new phase correction
            end if;
        end if;
    end process;
end bhv;
