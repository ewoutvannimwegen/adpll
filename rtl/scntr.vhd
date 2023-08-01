library ieee;
library unisim;
use ieee.std_logic_1164.all;
use unisim.vcomponents.all;

-- Shift Counter
-- Tracks the distance i_in can travel in the phase difference
-- NOTE: Uses the prop. delay through the MUX as delay. Gate level sim required
entity scntr is
    generic (
        R : natural := 512 -- Resolution
    );
	port (
		i_clk : in  std_logic;                     -- System clock
        i_rst : in  std_logic;                     -- Reset
		i_in  : in  std_logic;                     -- Input data
		o_out : out std_logic_vector(R-1 downto 0) -- Output data
	);
end scntr;

architecture bhv of scntr is

	ATTRIBUTE keep_hierarchy 	    : string;
	ATTRIBUTE keep_hierarchy OF bhv : ARCHITECTURE IS "true";

    signal di : std_logic_vector(R-1 downto 0) := (others => '0'); -- Data in
    signal do : std_logic_vector(R-1 downto 0) := (others => '0'); -- Data out
begin
    gen_carry4_inst : for i in 0 to R/4-1 generate
        -- CARRY4 : https://docs.xilinx.com/r/en-US/ug953-vivado-7series-libraries/CARRY4
        gen_carry4_inst_0 : if i = 0 generate
            carry4_inst_0 : CARRY4
            port map (
                CO     => di(3 downto 0),
                CI     => i_in,
                CYINIT => '0',
                DI     => "0000",
                S      => "1111"
            );
        end generate;

        gen_carry4_inst_i : if i > 0 generate
            carry4_inst_i : CARRY4
            port map (
                CO     => di(4*(i+1)-1 downto 4*i),
                CI     => di(4*i-1),
                CYINIT => '0',
                DI     => "0000",
                S      => "1111"
            );
        end generate;
    end generate;
    
    gen_fdce_inst : for i in 0 to R-1 generate
        fdce_inst_i : FDCE
        generic map(
            INIT => '0' 
        )
        port map (
            C => i_clk,
            CLR => i_rst,
            D  => di(i),
            Q => do(i),
            CE => '1'
        );
    end generate;

    o_out <= do;
end bhv;
