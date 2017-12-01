----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    10:53:20 11/25/2017
-- Design Name:
-- Module Name:    Seg7 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Seg7 is
	Port (Number : in STD_LOGIC_VECTOR(3 downto 0);
			Display : out STD_LOGIC_VECTOR(6 downto 0));
end Seg7;

architecture Behavioral of Seg7 is
begin

	with Number select Display <=
		"1111110" when "0000", -- 0
		"0110000" when "0001", -- 1
		"1101101" when "0010", -- 2
		"1111001" when "0011", -- 3
		"0110011" when "0100", -- 4
		"1011011" when "0101", -- 5
		"1011111" when "0110", -- 6
		"1110000" when "0111", -- 7
		"1111111" when "1000", -- 8
		"1110011" when "1001", -- 9
		"1110111" when "1010", -- A
		"0011111" when "1011", -- B
		"1001110" when "1100", -- C
		"0111101" when "1101", -- D
		"1001111" when "1110", -- E
		"1000111" when "1111", -- F
		"0000000" when others;

end Behavioral;
