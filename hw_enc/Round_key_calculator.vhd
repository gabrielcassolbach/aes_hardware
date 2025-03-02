library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------------

entity Round_key_calculator is
   port(
		input_key      : in  std_logic_vector (127 downto 0);
		round_constant : in std_logic_vector(7 downto 0);
		output_key     : out std_logic_vector (127 downto 0)
	); 
end entity;

--------------------------------------------------------------------------------------

architecture a_Round_key_calculator of Round_key_calculator is

--------------------------------------------------------------------------------------

component Sbox is
   port(
		input_byte  : in  std_logic_vector (7 downto 0);
		output_byte : out std_logic_vector (7 downto 0)
	); 
end component;

--------------------------------------------------------------------------------------

signal sub_word_key: std_logic_vector (31 downto 0);
signal rot_word_key: std_logic_vector(31 downto 0);
signal w7, w6, w5, w4 : std_logic_vector(31 downto 0);

--------------------------------------------------------------------------------------

begin
	
	rot_word_key <= input_key(103 downto 96) & input_key(127 downto 104);
	
	generate_sboxes:
    for i in 0 to 4 - 1 generate
        sbox_x: Sbox
        port map(input_byte => rot_word_key((8*(i+1))-1 downto 8*i), output_byte => sub_word_key((8*(i+1))-1 downto 8*i));
    end generate generate_sboxes;
	
	w4(31 downto 8) <= input_key(31 downto 8) xor sub_word_key(31 downto 8);
	w4(7 downto 0)  <= input_key(7 downto 0) xor round_constant xor sub_word_key(7 downto 0);
	w5 <= w4 xor input_key(63 downto 32);
	w6 <= w5 xor input_key(95 downto 64);
	w7 <= w6 xor input_key(127 downto 96);
	
	output_key <= w7 & w6 & w5 & w4;
	
end architecture a_Round_key_calculator;