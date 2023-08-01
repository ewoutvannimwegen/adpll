library ieee;
library unisim;
use ieee.std_logic_1164.all;
use unisim.vcomponents.all;
use ieee.math_real.all;

-- Shift Counter
-- Tracks the distance i_in can travel in the phase difference
-- NOTE: Uses the prop. delay through the MUX as delay. Gate level sim required
entity scntr is
    generic (
        L : natural := 512; -- Lenght carry chain
        N : natural := 16   -- Number of FF
    );
	port (
		i_clk : in  std_logic;                    -- System clock
        i_rst : in  std_logic;                    -- Reset
		i_in  : in  std_logic;                    -- Input data
		o_out : out std_logic_vector(natural(ceil(log2(real(N))))-1 downto 0)  -- Output data
	);
end scntr;

-- Carry chain is implemented with Xilinx/AMD CARRY4 blocks
-- N carry chain outputs are attached to a FF
architecture bhv of scntr is

	attribute keep_hierarchy : string;
	attribute dont_touch : string;
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
    
    attribute dont_touch of CARRY4 : component is "true";

    component FDCE
        generic (
            INIT : std_logic := '0'
        );
        port (
            CLR : in std_logic;
            CE : in std_logic;
            D : in std_logic;
            C : in std_logic;
            Q : out std_logic
        );
    end component FDCE;

    attribute dont_touch of FDCE : component is "true";

    component s2b
        generic (
            R : natural := N-1
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

begin
    gen_carry4_inst : for i in 0 to L/4-1 generate
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

    
    gen_fdce_inst : for i in 0 to N-1 generate
        fdce_inst_i : FDCE
        generic map(
            INIT => '0' 
        )
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
        R => N-1
    )
    port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_in => do(N-1 downto 1),
        o_out => o_out 
    );

end bhv;
