----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12:14:20 11/22/2017
-- Design Name:
-- Module Name:    Extender - Behavioral
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
use IEEE.STD_LOGIC_ARITH.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Extender is
	Port (Instruction : in STD_LOGIC_VECTOR(15 downto 0);
			Extended : out STD_LOGIC_VECTOR(15 downto 0));
end Extender;

architecture Behavioral of Extender is

	signal first5 : STD_LOGIC_VECTOR(4 downto 0);
	signal first8 : STD_LOGIC_VECTOR(7 downto 0);
	signal last2 : STD_LOGIC_VECTOR(1 downto 0);
	signal last4 : STD_LOGIC_VECTOR(3 downto 0);
	signal last5 : STD_LOGIC_VECTOR(4 downto 0);
	signal last8 : STD_LOGIC_VECTOR(7 downto 0);
	signal from4to2 : STD_LOGIC_VECTOR(2 downto 0);

	constant SIZE : INTEGER := 16;

begin

	first5 <= Instruction(15 downto 11);
	first8 <= Instruction(15 downto 8);
	last2 <= Instruction(1 downto 0);
	last4 <= Instruction(3 downto 0);
	last5 <= Instruction(4 downto 0);
	last8 <= Instruction(7 downto 0);
	from4to2 <= Instruction(4 downto 2);

	Extended <= SXT(last8, SIZE) when first5 = "01001"
											 or first8 = "01100011"
											 or first5 = "00100"
											 or first5 = "00101"
											 or first8 = "01100000"
											 or first8 = "01100001"
											 or first5 = "10010"
											 or first5 = "01010"
											 or first5 = "11010" else
					EXT(last8, SIZE) when first5 = "01101"
											 or first5 = "01011" else
					SXT(last4, SIZE) when first5 = "01000" and Instruction(4) = '0' else
					SXT(last5, SIZE) when first5 = "10011"
											 or first5 = "11011" else
					EXT(from4to2, SIZE) when first5 = "00110" and last2 = "00"
												 or first5 = "00110" and last2 = "11" else
					(others => '0');

end Behavioral;
