----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:05:13 11/30/2017
-- Design Name:
-- Module Name:    KeyboardToAscii - Behavioral
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

entity KeyboardToAscii is
	Port (Data : in STD_LOGIC_VECTOR(7 downto 0);
			Output : out STD_LOGIC_VECTOR(7 downto 0));
end entity; -- KeyboardToAscii

architecture Behavioral of KeyboardToAscii is
begin
	Output <=
		X"41" when Data = X"1C" else -- A
		X"42" when Data = X"32" else -- B
		X"43" when Data = X"21" else -- C
		X"44" when Data = X"23" else -- D
		X"45" when Data = X"24" else -- E
		X"46" when Data = X"2B" else -- F
		X"47" when Data = X"34" else -- G
		X"48" when Data = X"33" else -- H
		X"49" when Data = X"43" else -- I
		X"4A" when Data = X"3B" else -- J
		X"4B" when Data = X"42" else -- K
		X"4C" when Data = X"4B" else -- L
		X"4D" when Data = X"3A" else -- M
		X"4E" when Data = X"31" else -- N
		X"4F" when Data = X"44" else -- O
		X"50" when Data = X"4D" else -- P
		X"51" when Data = X"15" else -- Q
		X"52" when Data = X"2D" else -- R
		X"53" when Data = X"1B" else -- S
		X"54" when Data = X"2C" else -- T
		X"55" when Data = X"3C" else -- U
		X"56" when Data = X"2A" else -- V
		X"57" when Data = X"1D" else -- W
		X"58" when Data = X"22" else -- X
		X"59" when Data = X"35" else -- Y
		X"5A" when Data = X"1A" else -- Z
		X"30" when Data = X"45" else -- 0
		X"31" when Data = X"16" else -- 1
		X"32" when Data = X"1E" else -- 2
		X"33" when Data = X"26" else -- 3
		X"34" when Data = X"25" else -- 4
		X"35" when Data = X"2E" else -- 5
		X"36" when Data = X"36" else -- 6
		X"37" when Data = X"3D" else -- 7
		X"38" when Data = X"3E" else -- 8
		X"39" when Data = X"46" else -- 9
		X"2D" when Data = X"4E" else -- -
		X"3D" when Data = X"55" else -- =
		X"5C" when Data = X"5D" else -- \
		X"08" when Data = X"66" else -- BKSP
		X"20" when Data = X"29" else -- SPACE
		X"09" when Data = X"0D" else -- TAB
		X"25" when Data = X"58" else -- CAPS
		X"00" when Data = X"12" else -- L SHFT
		X"01" when Data = X"14" else -- L CTRL
		X"02" when Data = X"11" else -- L ALT
		X"12" when Data = X"5A" else -- ENTER
		X"1B" when Data = X"76" else -- ESC
		X"5B" when Data = X"54" else -- [
		X"21" when Data = X"75" else -- U ARROW
		X"22" when Data = X"6B" else -- L ARROW
		X"23" when Data = X"72" else -- D ARROW
		X"24" when Data = X"74" else -- R ARROW
		X"5D" when Data = X"5B" else -- ]
		X"3B" when Data = X"4C" else -- ;
		X"27" when Data = X"52" else -- '
		X"2C" when Data = X"41" else -- ,
		X"2E" when Data = X"49" else -- .
		X"2F" when Data = X"4A" else -- /
		X"00";

end architecture; -- Behavioral
