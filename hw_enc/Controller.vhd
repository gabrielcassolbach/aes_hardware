library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------------

entity Controller is
   port(
		clock : in std_logic;
		reset : in std_logic;
		round_constant : out std_logic_vector(7 downto 0);
		final_round: out std_logic;
		finished: out std_logic
	); 
end entity;

--------------------------------------------------------------------------------------

architecture a_Controller of Controller is

--------------------------------------------------------------------------------------

component Reg is
    generic (
        size: positive
    );
    port (
        clock: in std_logic;
		  enable: in std_logic;
        input: in std_logic_vector(size - 1 downto 0);
        output: out std_logic_vector(size - 1 downto 0)
    );
end component;

component Gf_mult_2 is
	port (
		input_byte : in std_logic_vector(7 downto 0);
		output_byte : out std_logic_vector(7 downto 0)
	);
end component;

--------------------------------------------------------------------------------------

signal reg_input : std_logic_vector(7 downto 0);
signal reg_output: std_logic_vector(7 downto 0);
signal current_round_constant: std_logic_vector(7 downto 0);

signal permanent_enable : std_logic;
--------------------------------------------------------------------------------------

begin

permanent_enable <= '1';

reg_input <= x"01" when reset = '1' else current_round_constant;

Gf_mult_2_inst : Gf_mult_2
	port map(
		input_byte  => reg_output,
		output_byte => current_round_constant
);

reg_inst : reg
generic map(
	size => 8
)
port map(
	clock  => clock,
	enable => permanent_enable,
	input  => reg_input,
	output => reg_output
);	

round_constant <= reg_output;
final_round <= '1' when reg_output = x"36" else '0';
finished <= '1' when reg_output = x"6c" else '0';

end architecture a_Controller;