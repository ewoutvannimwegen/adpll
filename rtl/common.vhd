library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package common is
    type natural_vector is array (natural range <>) of natural; 
    constant DBG         : std_logic := '0'; -- Debug mode
    constant CC_MAX_LEN  : integer := 150; -- Max length CARRY4 chain
    constant CARRY4_PDLY : natural := 187; -- Propegation delay CARRY4 in ps
    constant T_CLK       : natural := 20000; -- Period system clock in ps
	function to_string (a : std_logic_vector) return string;
    function cnt_ones  (s : std_logic_vector) return natural;
    function get_off   (mid : std_logic_vector; cs : natural_vector) return natural;
    function f_log2 (x : positive) return natural;
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

    -- Synthesis friendly log2 function
    function f_log2 (x : positive) return natural is
      variable i : natural := x;
      variable n : natural := 0;
    begin
        -- n < 31 Avoid elab error about loop not constraint for converging
        while (i > 1 and n < 31) loop
            i := i / 2;
            n := n + 1;
        end loop;
        if x > 2**n then
            return n + 1;
        else
            return n;
        end if;
   end function;
end common;
