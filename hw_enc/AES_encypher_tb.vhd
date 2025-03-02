library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------------

entity AES_encypher_tb is
end entity;

--------------------------------------------------------------------------------------

architecture a_AES_encypher_tb of AES_encypher_tb is

--------------------------------------------------------------------------------------

component AES_encypher is
   port(
		clock       : in std_logic;
		reset       : in std_logic;
		key         : in std_logic_vector (127 downto 0);
		input_text  : in std_logic_vector (127 downto 0);
		output_text : out std_logic_vector (127 downto 0);
		finished    : out std_logic
	); 
end component;

--------------------------------------------------------------------------------------

signal clock, reset	: std_logic;
signal key 				: std_logic_vector (127 downto 0);
signal input_text		: std_logic_vector (127 downto 0);
signal output_text 	: std_logic_vector (127 downto 0);
signal finished   	: std_logic;

constant clk_period : time := 40 ns;


--------------------------------------------------------------------------------------

begin

DUT: AES_encypher
	port map(
	   clock       => clock,
		reset       => reset,
		key         => key,
		input_text  => input_text,
		output_text => output_text,
		finished    => finished
	);

--------------------------------------------------------------------------------------

process
	begin
		input_text <= x"340737e0a29831318d305a88a8f64332";
		
		key <= x"3c4fcf098815f7aba6d2ae2816157e2b";
		
		reset <= '1';
		
		wait for clk_period;
		
		reset <= '0';
		
		wait until finished = '1';
		
		wait for clk_period/2;
		
		if (output_text = x"320b6a19978511dcfb09dc021d842539") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		
		report "---------- Output must be: -------";
		
		report "320b6a19978511dcfb09dc021d842539";
		
		input_text <= x"00000000000000000000000000000000";
		
		key <= x"00000000000000000000000000000000";
		
		reset <= '1';
		
		wait for clk_period * 1;
		
		reset <= '0';
		
		wait until finished = '1';
		
		wait for clk_period/2;
		
		if (output_text = x"2e2b34ca59fa4c883b2c8aefd44be966") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		
		report "---------- Output must be: -------";
		
		report "2e2b34ca59fa4c883b2c8aefd44be966";

		input_text <= x"2a179373117e3de9969f402ee2bec16b";
		
		key <= x"3c4fcf098815f7aba6d2ae2816157e2b";
		
		reset <= '1';

		wait for clk_period * 1;
		
		reset <= '0';
		
		wait until finished = '1';
		
		wait for clk_period/2;	
		
		if (output_text = x"97ef6624f3ca9ea860367a0db47bd73a") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		
		report "---------- Output must be: -------";
		
		report "97ef6624f3ca9ea860367a0db47bd73a";
		
		wait;
end process;

clk_gen: process
begin 
	clock <= '0';
	wait for clk_period/2;
	clock <= '1';
	wait for clk_period/2;
end process;

end architecture a_AES_encypher_tb;