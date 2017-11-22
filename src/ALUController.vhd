----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    20:18:20 11/19/2017
-- Design Name:
-- Module Name:    ALUController - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALUController is
	Port (Instruction : in STD_LOGIC_VECTOR(15 downto 0);
			ALUop : out STD_LOGIC_VECTOR(3 downto 0));
end ALUController;

architecture Behavioral of ALUController is

	signal first5 : STD_LOGIC_VECTOR(4 downto 0);
	signal first8 : STD_LOGIC_VECTOR(7 downto 0);
	signal last2 : STD_LOGIC_VECTOR(1 downto 0);
	signal last5 : STD_LOGIC_VECTOR(4 downto 0);
	signal last8 : STD_LOGIC_VECTOR(7 downto 0);

begin

	first5 <= Instruction(15 downto 11);
	first8 <= Instruction(15 downto 8);
	last2 <= Instruction(1 downto 0);
	last5 <= Instruction(4 downto 0);
	last8 <= Instruction(7 downto 0);

	ALUop <= "0000" when first5 = "01001"
							or first5 = "01000" and Instruction(4) = '0'
							or first8 = "01100011"
							or first5 = "11100" and last2 = "01"
							or first5 = "01101"
							or first5 = "10011"
							or first5 = "10010"
							or first5 = "11110" and last8 = "00000000"
							or first5 = "11101" and last8 = "01000000"
							or first5 = "11110" and last8 = "00000001"
							or first8 = "01100100" and last5 = "00000"
							or first5 = "11011"
							or first5 = "11010" else
				"0001" when first5 = "11101" and last = "01011"
							or first5 = "11100" and last2 = "11" else
				"0010" when first5 = "11101" and last5 = "01100" else
				"0011" when first5 = "11101" and last5 = "01101" else
				"0100" when first5 = "00110" and last2 = "00" else
				"0101" when first5 = "11101" and last5 = "00110" else
				"0110" when first5 = "00110" and last2 = "11" else
				"0111" when first5 = "11101" and last5 = "01010" else
				"1000" when first5 = "01010" else
				"1001" when first5 = "01011" else
				"1111";

end Behavioral;
