----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:05:13 11/30/2017
-- Design Name:
-- Module Name:    KeyboardTop - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KeyboardTop is
	Port (PS2Data : in STD_LOGIC; -- PS2 data
			PS2Clock : in STD_LOGIC; -- PS2 clk
			Clock : in STD_LOGIC;
			Reset : in STD_LOGIC;
			DataReceive : in STD_LOGIC;
			DataReady : out STD_LOGIC ;  -- data output enable signal
			Output : out STD_LOGIC_VECTOR(7 downto 0)); -- scan code signal output
end KeyboardTop;

architecture Behavioral of KeyboardTop is

	component Keyboard
		Port (PS2Data : in STD_LOGIC; -- PS2 data
				PS2Clock : in STD_LOGIC; -- PS2 clk
				Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;
				DataReceive : in STD_LOGIC;
				DataReady : out STD_LOGIC ;  -- data output enable signal
				Output : out STD_LOGIC_VECTOR(7 downto 0)); -- scan code signal output
	end component;

	component KeyboardToAscii
		Port (Data : in STD_LOGIC_VECTOR(7 downto 0);
				Output : out STD_LOGIC_VECTOR(7 downto 0));
	end component;

	signal KeyboardOutput : STD_LOGIC_VECTOR(7 downto 0);

begin

	KeyboardInstance : Keyboard port map (
		PS2Data => PS2Data,
		PS2Clock => PS2Clock,
		Clock => Clock,
		Reset => Reset,
		DataReceive => DataReceive,
		DataReady => DataReady,
		Output => KeyboardOutput
	);

	KeyboardToAsciiInstance : KeyboardToAscii port map (
		Data => KeyboardOutput,
		Output => Output
	);

end architecture; -- Behavioral
