library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package common is
    type natural_vector is array (natural range <>) of natural; 
    constant CC_MAX_LEN  : integer := 150; -- Max length CARRY4 chain
    constant CARRY4_PDLY : natural := 187; -- Propegation delay CARRY4 in ps
    constant T_CLK       : natural := 20000; -- Period system clock in ps
	function to_string (a : std_logic_vector) return string;
    function cnt_ones  (s : std_logic_vector) return natural;
    function get_off   (mid : std_logic_vector; cs : natural_vector) return natural;
    function dec2bcd   (dec : std_logic_vector) return std_logic_vector;
end common;

package body common is
	function to_string (a : std_logic_vector) return string is
		variable b            : string (1 to a'length) := (others => NUL);
		variable stri         : integer                := 1;
	begin
		for i in a'range loop
			b(stri) := std_logic'image(a((i)))(2);
			stri    := stri + 1;
		end loop;

		return b;
	end function;

    function cnt_ones (s : std_logic_vector) return natural is
        variable tmp : natural := 0;
    begin
        for i in s'range loop
            if s(i) = '1' then
                tmp := tmp + 1;
            end if; end loop;
        return tmp;
    end function;
    
    function get_off (mid : std_logic_vector; cs : natural_vector) return natural is
        variable off : natural := 0;
    begin
        for i in mid'range loop
            if mid(i) = '1' then
                if i = 0 then
                    off := off + cs(i) + 1;
                else
                    off := off + 4 + 1;
                end if;
            end if;
        end loop;
        assert false report "mid: " & to_string(mid) & ", off: " & natural'image(off) severity note;
        return off;
    end function;

    function dec2bcd (
        dec : std_logic_vector
    ) return std_logic_vector is 
        variable dig : natural := 0;
        variable tmp : unsigned(dec'length-1 downto 0) := (others => '0');
        variable bcd : std_logic_vector(dig*4-1 downto 0) := (others => '0');
    begin
        assert false report "dec: " & to_string(dec) severity note;

        dig := natural(ceil(
            log2(real(to_integer(unsigned(dec))))/log2(real(10))));
        assert false report "dig: " & natural'image(dig) severity note;

        for i in 0 to dig-1 loop
            if i = 0 then
                bcd(4*i+4-1 downto 4*i) := 
                    std_logic_vector(resize(tmp / (10**(dig-1-i)), 4));
                tmp := unsigned(dec) - 10**(dig-1-i);
            else
                bcd(4*i+4-1 downto 4*i) := std_logic_vector(resize(
                    tmp / (10**(dig-1-i)), 4));
                tmp := tmp - 10**(dig-1-i);
            end if;
            assert false report "bcd(" & natural'image(i) & "): " &
                to_string(bcd(4*i+4-1 downto 4*i)) severity note;
        end loop;
        return bcd;
    end function;
end common;
