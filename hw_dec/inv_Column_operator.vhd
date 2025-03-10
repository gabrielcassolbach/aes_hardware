library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------------

entity inv_Column_operator is
	port (
		input_column : in std_logic_vector(31 downto 0);
		output_column: out std_logic_vector(31 downto 0)
	);
end entity;

--------------------------------------------------------------------------------------

architecture a_inv_Column_operator of inv_Column_operator is

--------------------------------------------------------------------------------------

component Gf_mult_2 is
	port (
		input_byte : in std_logic_vector(7 downto 0);
		output_byte : out std_logic_vector(7 downto 0)
	);
end component;

component Column_operator is
	port (
		input_column : in std_logic_vector(31 downto 0);
		output_column: out std_logic_vector(31 downto 0)
	);
end component;

--------------------------------------------------------------------------------------

	signal temp0 : std_logic_vector(7 downto 0);
	signal temp1 : std_logic_vector(7 downto 0);
	signal temp0x2 : std_logic_vector(7 downto 0);
	signal temp1x2 : std_logic_vector(7 downto 0);
	signal temp0x2x2 : std_logic_vector(7 downto 0);
	signal temp1x2x2 : std_logic_vector(7 downto 0);	
	signal column_operator_input: std_logic_vector(31 downto 0);
	
--------------------------------------------------------------------------------------
	
begin

	temp0 <= input_column(7 downto 0) xor input_column(23 downto 16);
	temp1 <= input_column(15 downto 8) xor input_column(31 downto 24);
	
	Gf_mult_2_inst0 : Gf_mult_2
		port map(
			input_byte  => temp0,
			output_byte => temp0x2
		);
	Gf_mult_2_inst1 : Gf_mult_2
		port map(
			input_byte  => temp1,
			output_byte => temp1x2
		);
	Gf_mult_2_inst2 : Gf_mult_2
		port map(
			input_byte  => temp0x2,
			output_byte => temp0x2x2
		);
	Gf_mult_2_inst3 : Gf_mult_2
		port map(
			input_byte  => temp1x2,
			output_byte => temp1x2x2
		);
		
	column_operator_input(7 downto 0)   <= input_column(7 downto 0)   xor temp0x2x2;
	column_operator_input(15 downto 8)  <= input_column(15 downto 8)  xor temp1x2x2;
	column_operator_input(23 downto 16) <= input_column(23 downto 16) xor temp0x2x2;
	column_operator_input(31 downto 24) <= input_column(31 downto 24) xor temp1x2x2;

	Column_operator_inst : Column_operator
		port map(
			input_column => column_operator_input,
			output_column => output_column
		);
		
	
end architecture a_inv_Column_operator;