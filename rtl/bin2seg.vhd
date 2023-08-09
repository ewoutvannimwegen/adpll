library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin2seg is
    Port (
        i_bcd : in std_logic_vector(3 downto 0);
        o_seg : out std_logic_vector(6 downto 0)
    );
end bin2seg;

architecture bhv of bin2seg is
begin
    process(i_bcd) begin
        case i_bcd is
            when "0001" => o_seg <= "1001111"; -- "1" 
            when "0010" => o_seg <= "0010010"; -- "2" 
            when "0011" => o_seg <= "0000110"; -- "3" 
            when "0100" => o_seg <= "1001100"; -- "4" 
            when "0101" => o_seg <= "0100100"; -- "5" 
            when "0110" => o_seg <= "0100000"; -- "6" 
            when "0111" => o_seg <= "0001111"; -- "7" 
            when "1000" => o_seg <= "0000000"; -- "8"     
            when "1001" => o_seg <= "0000100"; -- "9" 
            when others => o_seg <= "0000001"; -- "0"
        end case;
    end process;
end bhv;
