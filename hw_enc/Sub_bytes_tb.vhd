library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------------

entity Sub_bytes_tb is
end entity;

--------------------------------------------------------------------------------------

architecture a_Sub_bytes_tb of Sub_bytes_tb is

--------------------------------------------------------------------------------------

component Sub_bytes is
   port(
		input_block  : in  std_logic_vector (127 downto 0);
		output_block : out std_logic_vector (127 downto 0)
	); 
end component;

--------------------------------------------------------------------------------------

signal input_text, output_text: std_logic_vector (127 downto 0);

--------------------------------------------------------------------------------------

begin

DUT: Sub_bytes
	port map(
	   input_block => input_text,
	   output_block => output_text          

	);

--------------------------------------------------------------------------------------

process
	begin
	input_text <= x"340737e0a29831318d305a88a8f64332";
	wait for 100 ns;
	input_text <= x"340737e0a29831318d305a88a8f64331";
	wait for 100 ns;
	input_text <= x"340737e0a29831318d305a88a8f64330";
	wait;
end process;


end architecture a_Sub_bytes_tb;