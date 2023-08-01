library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package common is
	function to_string (a : std_logic_vector) return string;
    function cnt_ones  (s : std_logic_vector) return integer;
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


    function cnt_ones (s : std_logic_vector) return integer is
        variable tmp : integer := 0;
    begin
        for i in s'range loop
            if s(i) = '1' then
                tmp := tmp + 1;
            end if;
        end loop;
        return tmp;
    end function;
end common;
