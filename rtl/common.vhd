library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package common is
    type natural_vector is array (natural range <>) of natural; 
    constant CC_MAX_LEN : integer := 150;
	function to_string (a : std_logic_vector) return string;
    function cnt_ones  (s : std_logic_vector) return natural;
    function get_off   (mid : std_logic_vector; cs : natural_vector) return natural;
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
                off := off + cs(i) + 1;
            end if;
        end loop;
        assert false report "mid: " & to_string(mid) & ", off: " & natural'image(off) severity note;
        return off;
    end function;
end common;
