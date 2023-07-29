library ieee;
use ieee.std_logic_1164.all;

-- CARRY4 component
library unisim;
use unisim.vcomponents.all;

-- Shift Counter
-- Tracks the distance i_in can travel in the phase difference
-- NOTE: Uses the prop. delay through the MUX as delay. Gate level sim required
-- CARRY4 : https://docs.xilinx.com/r/en-US/ug953-vivado-7series-libraries/CARRY4
entity scntr is
    generic (
        R : natural := 16 -- Resolution
    );
	port (
		i_clk : in  std_logic;                     -- System clock
        i_rst : in  std_logic;                     -- Reset
		i_in  : in  std_logic;                     -- Input data
		o_out : out std_logic_vector(R-1 downto 0) -- Output data
	);
end scntr;

architecture bhv of scntr is
    component dff
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
    dff_inst : for i in 0 to R-1 generate
        dff_inst_i : dff
        port map (
            i_clk => i_clk,
            i_rst => i_rst,
            i_in  => di(i),
            o_out => do(i) 
        );
    end generate;
   
    cc_inst : for i in 0 to R/4-1 generate

        first_cc : if i = 0 generate
            cc_inst_i : CARRY4
            port map (
                CO     => di(3 downto 0),
                CI     => '0',
                CYINIT => i_in,
                DI     => "0000",
                S      => "1111"
            );
        end generate;

        other_cc : if i > 0 generate
            cc_inst_i : CARRY4
            port map (
                CO     => di(4*(i+1)-1 downto 4*i),
                CI     => di(4*i-1),
                CYINIT => i_in,
                DI     => "0000",
                S      => "1111"
            );
        end generate;

    end generate;

    o_out <= do;
end bhv;
