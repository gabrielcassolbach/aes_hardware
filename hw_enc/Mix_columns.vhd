library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------------

entity Mix_columns is
   port(
		input_block  : in  std_logic_vector (127 downto 0);
		output_block : out std_logic_vector (127 downto 0)
	); 
end entity;

--------------------------------------------------------------------------------------

architecture a_Mix_columns of Mix_columns is

--------------------------------------------------------------------------------------

component Column_operator is
	port (
		input_column : in std_logic_vector(31 downto 0);
		output_column: out std_logic_vector(31 downto 0)
	);
end component;

--------------------------------------------------------------------------------------

begin

generate_column_operators:
    for i in 0 to 4 - 1 generate
        column_operator_x: Column_operator
        port map(input_column => input_block((32*(i+1))-1 downto 32*i), output_column => output_block((32*(i+1))-1 downto 32*i));
    end generate generate_column_operators;

end architecture a_Mix_columns;