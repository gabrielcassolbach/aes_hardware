library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------------

entity AES_encypher is
   port(
		clock       : in std_logic;
		reset       : in std_logic;
		key         : in std_logic_vector (127 downto 0);
		input_text  : in std_logic_vector (127 downto 0);
		output_text : out std_logic_vector (127 downto 0);
		finished    : out std_logic
	); 
end entity;

--------------------------------------------------------------------------------------

architecture a_AES_encypher of AES_encypher is

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

component Round_key_adder is
   port(
		input_block  : in  std_logic_vector (127 downto 0);
		round_key    : in  std_logic_vector	(127 downto 0);
		output_block : out std_logic_vector (127 downto 0)
	); 
end component;


component Sub_bytes is
   port(
		input_block  : in  std_logic_vector (127 downto 0);
		output_block : out std_logic_vector (127 downto 0)
	); 
end component;

component Shift_rows is
   port(
		input_block  : in  std_logic_vector (127 downto 0);
		output_block : out std_logic_vector (127 downto 0)
	); 
end component;

component Mix_columns is
   port(
		input_block  : in  std_logic_vector (127 downto 0);
		output_block : out std_logic_vector (127 downto 0)
	); 
end component;

component Key_scheduler is
   port(
		clock          : in  std_logic;
		reset          : in  std_logic;
		round_constant : in  std_logic_vector(7 downto 0);
		input_key      : in  std_logic_vector (127 downto 0);
		output_key     : out std_logic_vector (127 downto 0)
	); 
end component;

component Controller is
   port(
		clock 			: in std_logic;
		reset 			: in std_logic;
		round_constant : out std_logic_vector(7 downto 0);
		final_round		: out std_logic;
		finished			: out std_logic
	); 
end component;

--------------------------------------------------------------------------------------	

signal reg_input				   : std_logic_vector (127 downto 0);
signal reg_output					: std_logic_vector (127 downto 0);
signal round_key_adder_output : std_logic_vector (127 downto 0);
signal sub_bytes_output 		: std_logic_vector (127 downto 0);
signal shift_rows_output		: std_logic_vector (127 downto 0);
signal mix_columns_output		: std_logic_vector (127 downto 0);
signal round_key              : std_logic_vector (127 downto 0);
signal round_constant         : std_logic_vector (7   downto 0);
signal final_round_text			: std_logic_vector (127 downto 0);
signal final_round				: std_logic;

signal permanent_enable				 		 : std_logic;	

--------------------------------------------------------------------------------------	
	
begin

permanent_enable <= '1';

reg_input <= input_text when reset = '1' else final_round_text;

reg_inst : reg
	generic map (
		size => 128
	)
	port map (
		clock  => clock,
		enable => permanent_enable,
		input  => reg_input,
		output => reg_output
	);

round_key_adder_inst : round_key_adder
	port map (
		input_block  => reg_output,
		round_key    => round_key,
		output_block => round_key_adder_output
	);
	
sub_bytes_inst : sub_bytes
	port map (
		input_block  => round_key_adder_output,
		output_block => sub_bytes_output
	);

shift_rows_inst : shift_rows
	port map (
		input_block  => sub_bytes_output,
		output_block => shift_rows_output
	);	
	
mix_columns_inst : mix_columns
	port map (
		input_block  => shift_rows_output,
		output_block => mix_columns_output
	);	
	
final_round_text <= mix_columns_output when final_round = '0' else shift_rows_output;
output_text <= round_key_adder_output;

controller_inst : controller
	port map (
		clock  => clock,
		reset => reset,
		round_constant => round_constant,
		final_round => final_round,
		finished => finished
	);	

key_scheduler_inst : key_scheduler
	port map (
		clock  => clock,
		reset => reset,
		round_constant => round_constant,
		input_key => key,
		output_key => round_key
	);	

	
end architecture a_AES_encypher;