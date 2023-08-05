library ieee;
library unisim;
use ieee.std_logic_1164.all;
use unisim.vcomponents.all;
use ieee.math_real.all;
use work.common.all;
use ieee.numeric_std.all;

-- Shift Counter
-- Tracks the distance i_in can travel in the phase difference
-- NOTE: Uses the prop. delay through the MUX as delay. Gate level sim required
entity scntr is
    generic (
        L : natural := 4*work.common.CC_MAX_LEN; -- Lenght carry chain
        N : natural := 128   -- Number of FF
    );
	port (
		i_clk  : in  std_logic;                    -- System clock
        i_rst  : in  std_logic;                    -- Reset
		i_in   : in  std_logic;                    -- Input data
		o_out  : out std_logic_vector(natural(ceil(log2(real(N))))-1 downto 0)  -- Output data
	);
end scntr;

-- Carry chain is implemented with Xilinx/AMD CARRY4 blocks
-- N number of carry chain outputs which are 'measured' by a FF
architecture bhv of scntr is

	attribute keep_hierarchy : string;
	attribute dont_touch : string;
    attribute loc : string;

    -- Keep hierarchy to have the chain set up as a tower (not spread out by vivado), 
    -- this way the prop. delay is the same between each CARRY4 element
    attribute keep_hierarchy of bhv : architecture is "true";

    component CARRY4 
        port (
            CI : in std_logic;
            CYINIT : in std_logic;
            DI : in std_logic_vector(3 downto 0);
            S : in std_logic_vector(3 downto 0);
            CO : out std_logic_vector(3 downto 0);
            O : out std_logic_vector(3 downto 0)
        );
    end component CARRY4;
   
    -- Avoid optimizing the carries out, who are not attached to a FF
    attribute dont_touch of CARRY4 : component is "true";

    -- Data-FF with clock enable and async clear
    -- https://docs.xilinx.com/r/en-US/ug974-vivado-ultrascale-libraries/FDCE
    component FDCE
        port (
            CLR : in std_logic; -- Clear
            CE : in std_logic; -- Enable
            D : in std_logic; -- Data in
            C : in std_logic; -- Clock
            Q : out std_logic -- Data out
        );
    end component FDCE;

    attribute dont_touch of FDCE : component is "true";

    component s2b
        generic (
            R : natural := natural(log2(real(N)))
        );
        port (
            i_clk : in  std_logic;
            i_rst : in  std_logic;
            i_in  : in  std_logic_vector(N-2 downto 0);
            o_out : out std_logic_vector(natural(ceil(log2(real(N))))-1 downto 0)
        );
    end component s2b; 
    
    attribute dont_touch of s2b : component is "true";

    constant off : natural := L/N; -- Offset FF = Length chain / number of FF

    signal di : std_logic_vector(L-1 downto 0) := (others => '0'); -- MUX out
    signal do : std_logic_vector(N-1 downto 0) := (others => '0'); -- FF out

    -- Take a look at the 'device map' in Vivado after synthesis to find a good spot
    constant xoff : integer := 60; 
    constant yoff : integer := 0;
begin

    assert L/4 <= work.common.CC_MAX_LEN report "L:" & integer'image(L) severity error;

    gen_carry4_inst : for i in 0 to L/4-1 generate
        -- CARRY4 : https://docs.xilinx.com/r/en-US/ug953-vivado-7series-libraries/CARRY4
        -- Location constraint : https://www.xilinx.com/htmldocs/xilinx14_7/cgd.pdf
        gen_carry4_inst_0 : if i = 0 generate
            attribute loc of carry4_inst_0 : label is "SLICE_X" & 
                integer'image(xoff) & "Y" & integer'image(yoff);
        begin
            carry4_inst_0 : CARRY4
            port map (
                CO     => di(3 downto 0),
                CI     => i_in,
                CYINIT => '0',
                DI     => "0000",
                S      => "1111"
            );
        end generate;

        gen_carry4_inst_i : if i > 0 and i < L generate
            attribute loc of carry4_inst_i : label is "SLICE_X" & 
                integer'image(xoff) & "Y" & integer'image(yoff+i);
        begin
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

    gen_fdce_inst : for i in 0 to N-1 generate
        fdce_inst_i : FDCE
        port map (
            C => i_clk,
            CLR => i_rst,
            D  => di(i*off+off-1),
            Q => do(i),
            CE => '1'
        );
    end generate;
    
    s2b_inst : s2b
    generic map (
        R => natural(log2(real(N)))
    )
    port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_in => do(N-1 downto 1),
        o_out => o_out 
    );

end bhv;
