library ieee;
use ieee.std_logic_1164.all;

-- T-Flipflop
entity tff is
	port (
		i_clk : in  std_logic; -- System clock
        i_rst : in  std_logic; -- Reset
		i_in  : in  std_logic; -- Input data
		o_out : out std_logic  -- Output data
	);
end tff;

architecture bhv of tff is
    signal data : std_logic := '0';
begin
    o_out <= data;
	process (i_rst, i_clk)
	begin
        if i_rst = '1' then
            data <= '0';
        elsif rising_edge(i_clk) then
            if i_in = '0' then
                data <= data;
            else
                data <= not data;
            end if;
        end if;
    end process;
end bhv;
