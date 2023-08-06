library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all; -- ceil() & log2()
use ieee.numeric_std.all; -- to_unsigned()
use work.common.all; -- cnt_ones() 

-- Shift (thermometer) to Binary counting
entity s2b is
    generic (
        R : natural := 7 -- Resolution output
    );
	port (
		i_clk : in  std_logic;                         -- System clock
        i_rst : in  std_logic;                         -- Reset
		i_in  : in  std_logic_vector(2**R-2 downto 0); -- Input data
		o_out : out std_logic_vector(R-1 downto 0)     -- Output data
	);
end s2b;

architecture bhv of s2b is
    attribute dont_touch : string;
    constant cs : work.common.natural_vector(R-3 downto 0) := (3, 7, 15, 31, 63);

    signal mo0 : std_logic_vector(cs(0)-1 downto 0) := (others => '0'); 
    attribute dont_touch of mo0 : signal is "true";
    signal mo1 : std_logic_vector(cs(1)-1 downto 0) := (others => '0'); 
    attribute dont_touch of mo1 : signal is "true";
    signal mo2 : std_logic_vector(cs(2)-1 downto 0) := (others => '0'); 
    attribute dont_touch of mo2 : signal is "true";
    signal mo3 : std_logic_vector(cs(3)-1 downto 0) := (others => '0'); 
    attribute dont_touch of mo3 : signal is "true";
    signal mo4 : std_logic_vector(cs(4)-1 downto 0) := (others => '0'); 
    attribute dont_touch of mo4 : signal is "true";
    signal mid : std_logic_vector(R-3 downto 0)     := (others => '0');
    attribute dont_touch of mid : signal is "true";
begin
    assert false report "Column sizes: " & 
        integer'image(cs(0)) & " " &
        integer'image(cs(1)) & " " & 
        integer'image(cs(2)) & " " & 
        integer'image(cs(3)) & " " &
        integer'image(cs(4)) severity note;

    mid <= i_in(cs(4)) & i_in(cs(3)) & i_in(cs(2)) & i_in(cs(1)) & i_in(cs(0));

    process(i_rst, i_clk) begin
        if i_rst = '1' then
            o_out <= (others => '0');
            mo0   <= (others => '0');
            mo1   <= (others => '0');
            mo2   <= (others => '0');
            mo3   <= (others => '0');
            mo4   <= (others => '0');
        elsif rising_edge(i_clk) then
            if i_in(cs(0)) = '1' then
                mo0 <= i_in(i_in'length-1 downto cs(0)+1);
            else
                mo0 <= i_in(cs(0)-1 downto 0);
            end if;

            if mo0(cs(1)) = '1' then
                mo1 <= mo0(mo0'length-1 downto cs(1)+1);
            else
                mo1 <= mo0(cs(1)-1 downto 0);
            end if;

            if mo1(cs(2)) = '1' then
                mo2 <= mo1(mo1'length-1 downto cs(2)+1);
            else
                mo2 <= mo1(cs(2)-1 downto 0);
            end if;

            if mo2(cs(3)) = '1' then
                mo3 <= mo2(mo2'length-1 downto cs(3)+1);
            else
                mo3 <= mo2(cs(3)-1 downto 0);
            end if;

            if mo3(cs(4)) = '1' then
                mo4 <= mo3(mo3'length-1 downto cs(4)+1);
            else
                mo4 <= mo3(cs(4)-1 downto 0);
            end if;

            o_out <= std_logic_vector(to_unsigned(get_off(mid, cs) + cnt_ones(mo4), o_out'length));
        end if;
    end process;

end bhv;
