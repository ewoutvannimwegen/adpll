library ieee;
use ieee.std_logic_1164.all;

-- D-Flipflop
entity dff is
	port (
		i_clk : in  std_logic; -- System clock
        i_rst : in  std_logic; -- Reset
		i_in  : in  std_logic; -- Input data
		o_out : out std_logic  -- Output data
	);
end dff;

architecture bhv of dff is
begin
	process (i_rst, i_clk)
	begin
        if i_rst = '1' then
            o_out <= '0';
        elsif rising_edge(i_clk) then
            o_out <= i_in;
        end if;
    end process;
end bhv;
