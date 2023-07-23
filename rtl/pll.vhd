library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pll is
    generic (
        RES : natural := 4
    );
    port (
        i_clk        : in  std_logic;
        i_rst        : in  std_logic;
        i_in         : in  std_logic;
        i_step       : in  std_logic_vector(3 downto 0); 
        o_out        : out std_logic  
    );
end pll;

architecture bhv of pll is
    signal cnt : std_logic_vector (RES-1 downto 0):= (others => '0');
    signal msb : std_logic := '0';
    signal lvl : std_logic := '0'; 
    signal lead : std_logic := '0';
    signal err : std_logic := '0';
begin
    msb <= cnt(RES-1);
    o_out <= msb;
    err <= i_in xor msb; 

    process(lvl) 
    begin
        if lvl = '1' then
            -- Leading if cnt goes low before i_in
            lead <= i_in and (not msb);
        else
            -- Leading if cnt goes high before i_in
            lead <= (not i_in) and msb;
        end if;
    end process;

    process(i_clk, i_rst, i_in, msb, lead, err)
    begin
        if i_rst = '1' then
            cnt <= (others => '0');
            lead <= '0';
            lvl <= '0';
        elsif rising_edge(i_clk) then
            if i_in = '1' and msb = '1' then
                -- I_in & cnt coincide high
                lvl <= '1';
            elsif i_in = '0' and msb = '0' then
                -- I_in & cnt coincide low
                lvl <= '0';
            else
                -- Cnt is leading or lagging i_in
                null;
            end if;
            
            -- Use signed counting as cheap 50% duty cycle
            if err = '0' then
                -- I_in & cnt coincide
                cnt <= std_logic_vector(signed(cnt) + signed(i_step));
            elsif err = '1' and lead = '1' then
                -- Cnt is leading i_in; Decrease speed
                cnt <= std_logic_vector(signed(cnt) + signed(i_step) - 1);
            elsif err = '1' and lead = '0' then
                -- Cnt is lagging behind i_in; Increase speed
                cnt <= std_logic_vector(signed(cnt) + signed(i_step) + 1);
            else
                null;
            end if; 
        end if;
    end process;
end bhv;
