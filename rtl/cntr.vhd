library ieee;
use ieee.std_logic_1164.all;

-- Counter
-- https://www.fpga4fun.com/Counters4.html
entity cntr is
    generic (
        R : natural := 16 -- Resolution
    );
	port (
		i_clk : in  std_logic;                     -- System clock
        i_rst : in  std_logic;                     -- Reset
		i_in  : in  std_logic;                     -- Input data
		o_out : out std_logic_vector(R-1 downto 0) -- Output data
	);
end cntr;

architecture bhv of cntr is
    component tff
        port (
            i_clk : in  std_logic;
            i_rst : in  std_logic;
            i_in  : in  std_logic;
            o_out : out std_logic
        );
    end component;

    signal di : std_logic_vector(R-1 downto 0) := (others => '0'); -- Data in
    signal do : std_logic_vector(R-1 downto 0) := (others => '0'); -- Data out
begin
    tff_inst : for i in 0 to R-1 generate

        tff_i : tff
        port map (
            i_clk => i_clk,
            i_rst => i_rst,
            i_in  => di(i),
            o_out => do(i) 
        );

        i_1 : if i = 1 generate
            di(1) <= do(0);
        end generate;

        i_2 : if i = 2 generate
            di(2) <= do(0) and do(1);
        end generate;

        carry_chain : if i >= 3 generate
            di(i) <= do(i-1) and di(i-1);
        end generate;
    end generate;

    di(0) <= i_in;
    o_out <= do;
end bhv;
