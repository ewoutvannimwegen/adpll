library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all; -- ceil() & log2()
use ieee.numeric_std.all; -- to_unsigned()
use work.common.all; -- cnt_ones() 

-- Shift to Binary counting
-- NOTE: currently only works for R=15, find better way to pre-calc col size & offsets 
entity s2b is
    generic (
        R : natural := 15 -- Resolution (uneven)
    );
	port (
		i_clk : in  std_logic;                     -- System clock
        i_rst : in  std_logic;                     -- Reset
		i_in  : in  std_logic_vector(R-1 downto 0); -- Input data
		o_out : out std_logic_vector(natural(ceil(log2(real(R+1))))-1 downto 0) -- Output data
	);
end s2b;

architecture bhv of s2b is
    -- R + 1 to create even number for the log2 
    constant B  : natural := natural(ceil(log2(real(R+1)))); -- Binary resolution
    constant c0 : natural := (R-1)/2; -- Length column 0
    constant c1 : natural := (c0-1)/2; -- Length column 1

    signal mo0 : std_logic_vector(c0-1 downto 0) := (others => '0'); -- MUX outputs column 0
    signal mo1 : std_logic_vector(c1-1 downto 0) := (others => '0'); -- MUX outputs column 1
begin
    gen_c0 : for i in 0 to c0-1 generate
        mo0(i) <= i_in(c0+1+i) when i_in(c0) = '1' else i_in(i);
    end generate;
    
    gen_c1 : for i in 0 to c1-1 generate
        mo1(i) <= mo0(c1+1+i) when i_in(c1) = '1' else mo0(i);
    end generate;

    process(i_rst, i_clk) 
    begin
        if i_rst = '1' then
            o_out <= (others => '0');
        elsif rising_edge(i_clk) then
            if i_in(c0) = '1' and i_in(c1) = '1' then
                o_out <= std_logic_vector(to_unsigned(cnt_ones(mo1), o_out'length) + 12);
            elsif  i_in(c0) = '1' and i_in(c1) = '0' then
                o_out <= std_logic_vector(to_unsigned(cnt_ones(mo1), o_out'length) + 7);
            elsif  i_in(c0) = '0' and i_in(c1) = '1' then
                o_out <= std_logic_vector(to_unsigned(cnt_ones(mo1), o_out'length) + 4);
            elsif  i_in(c0) = '0' and i_in(c1) = '0' then
                o_out <= std_logic_vector(to_unsigned(cnt_ones(mo1), o_out'length));
            end if;
        end if;
    end process;
end bhv;
