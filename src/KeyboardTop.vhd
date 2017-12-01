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
		Port (PS2Data : in std_logic; -- PS2 data
				PS2Clock : in std_logic; -- PS2 clk
				Clock : in std_logic;
				Reset : in std_logic;
				DataReceive : in std_logic;
				DataReady : out std_logic ;  -- data output enable signal
				Output : out std_logic_vector (7 downto 0)); -- scan code signal output
	end component;

	component KeyboardToAscii
		Port (Data : in std_logic_vector (7 downto 0);
				Output : out std_logic_vector (7 downto 0));
	end component;

	signal PS2DataSignal : STD_LOGIC_VECTOR(7 downto 0);

begin

	KeyboardInstance : Keyboard port map (
		PS2Data => PS2Data,
		PS2Clock => PS2Clock,
		Clock => Clock,
		Reset => Reset,
		DataReceive => DataReceive,
		DataReady => DataReady,
		Output => PS2DataSignal
	);

	KeyboardToAsciiInstance : KeyboardToAscii port map (
		Data => PS2DataSignal,
		Output => Output
	);

end architecture; -- Behavioral
