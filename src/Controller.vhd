----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    23:07:10 11/21/2017
-- Design Name:
-- Module Name:    Controller - Behavioral
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

entity Controller is
	 Port(Instruction : in STD_LOGIC_VECTOR(15 downto 0);
			RegWrite : out STD_LOGIC;
			MemRead : out STD_LOGIC;
			MemWrite : out STD_LOGIC;
			BranchType : out STD_LOGIC_VECTOR(2 downto 0);
			RegSrcA : out STD_LOGIC_VECTOR(3 downto 0);
			RegSrcB : out STD_LOGIC_VECTOR(3 downto 0);
			RegDest : out STD_LOGIC_VECTOR(3 downto 0);
			UseImm : out STD_LOGIC;
			MemToReg : out STD_LOGIC);
end Controller;

architecture Behavioral of Controller is

	signal first5 : STD_LOGIC_VECTOR(4 downto 0);
	signal first8 : STD_LOGIC_VECTOR(7 downto 0);
	signal last5 : STD_LOGIC_VECTOR(4 downto 0);
	signal last8 : STD_LOGIC_VECTOR(7 downto 0);
	signal rx : STD_LOGIC_VECTOR(2 downto 0);
	signal ry : STD_LOGIC_VECTOR(2 downto 0);
	signal rz : STD_LOGIC_VECTOR(2 downto 0);

	constant ZERO : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

begin

	first5 <= Instruction(15 downto 11);
	first8 <= Instruction(15 downto 8);
	last5 <= Instruction(4 downto 0);
	last8 <= Instruction(7 downto 0);

	rx <= '1' & Instruction(10 downto 8);
	ry <= '1' & Instruction(7 downto 5);
	rz <= '1' & Instruction(4 downto 2);

	RegWrite <= first5 = "01001" -- ADDIU
				or first5 = "01000" and Instruction(4) = '0' -- ADDIU3
				or first8 = "01100011" -- ADDSP
				or first5 = "11100" and last2 = "01" -- ADDU
				or first5 = "11101" and last5 = "01100" -- AND
				or first5 = "01101" -- LI
				or first5 = "10011" -- LW
				or first5 = "10010" -- LW_SP
				or first5 = "11110" and last8 = "00000000" -- MFIH
				or first5 = "11101" and last8 = "01000000" -- MFPC
				or first5 = "11110" and last8 = "00000001" -- MTIH
				or first8 = "01100100" and last5 = "00000" -- MTSP
				or first5 = "11101" and last5 = "01011" -- NEG
				or first5 = "11101" and last5 = "01101" -- OR
				or first5 = "00110" and last2 = "01101" -- SLL
				or first5 = "01010" -- SLTI
				or first5 = "01011" -- SLTUI
				or first5 = "00110" and last2 = "11" -- SRA
				or first5 = "11101" and last5 = "00110" -- SRLV
				or first5 = "11100" and last2 = "11"; -- SUBU

	MemRead <= first5 = "10011" -- LW
			  or first5 = "10010"; -- LW_SP

	MemWrite <= first5 = "11011" -- SW
				or first5 = "11010"; -- SW_SP

	BranchType <= "001" when first5 = "00010" else -- B
					  "011" when first5 = "00100" else -- BEQZ
					  "100" when first5 = "00101" else -- BNEZ
					  "011" when first8 = "01100000" else -- BTEQZ
					  "100" when first8 = "01100001" else -- BTNEZ
					  "010" when first5 = "11101" and last8 = "00000000" else -- JR
					  "000";

	RegSrcA <= rx when first5 = "01001"
						 or first5 = "01000" and Instruction(4) = '0'
						 or first5 = "11100" and last2 = "01"
						 or first5 = "11101" and last5 = "01100"
						 or first5 = "00100"
						 or first5 = "00101"
						 or first5 = "11101" and last5 = "01010"
						 or first5 = "11101" and last8 = "00000000"
						 or first5 = "10011"
						 or first5 = "11110" and last8 = "00000001"
						 or first5 = "11101" and last5 = "01101"
						 or first5 = "01010"
						 or first5 = "01011"
						 or first5 = "11100" and last2 = "11"
						 or first5 = "11011" else
				  ry when first8 = "01100100" and last5 = "00000"
						 or first5 = "00110" and last2 = "00"
						 or first5 = "00110" and last2 = "11"
						 or first5 = "11101" and last5 = "00110" else
			 "0010" when first8 = "01100011"
						 or first5 = "10010"
			 			 or first5 = "11010" else
			 "0101" when first8 = "01100000"
						 or first8 = "01100001" else
			 "0010" when first5 = "10010"
						 or first5 = "11010" else
			 "0011" when first5 = "11110" and last8 = "00000000" else
			 "0001" when first5 = "11101" and last8 = "01000000" else
			 "0000";

	RegSrcB <= rx when first5 = "11101" and last = "01011"
						 or first5 = "11101" and last5 = "00110"
						 or first5 = "11010" else
				  ry when first5 = "11100" and last2 = "01"
						 or first5 = "11101" and last5 = "01100"
						 or first5 = "11101" and last5 = "01010"
						 or first5 = "11101" and last5 = "01101"
						 or first5 = "11100" and last2 = "11"
						 or first5 = "11011" else
				  "0000";

	RegDest <= rx when first5 = "01001"
						 or first5 = "11101" and last5 = "01100"
						 or first5 = "01101"
						 or first5 = "10010"
						 or first5 = "11110" and last8 = "00000000"
						 or first5 = "11101" and last8 = "01000000"
						 or first5 = "11101" and last5 = "01101"
						 or first5 = "00110" and last2 = "00"
						 or first5 = "00110" and last2 = "11" else
				  ry when first5 = "01000" and Instruction(4) = '0'
						 or first5 = "10011"
						 or first5 = "11101" and last = "01011"
						 or first5 = "11101" and last5 = "00110" else
				  rz when first5 = "11100" and last2 = "01"
						 or first5 = "11100" and last2 = "11" else
			 "0010" when first8 = "01100011"
						 or first8 = "01100100" and last5 = "00000" else
			 "0011" when first5 = "11110" and last8 = "00000001" else
			 "0101" when first5 = "01010"
						 or first5 = "01011" else
			 "0000";

	UseImm <= first5 = "01001"
			 or first5 = "01000" and Instruction(4) = '0'
			 or first8 = "01100011"
			 or first5 = "01101"
			 or first5 = "10011"
			 or first5 = "10010"
			 or first5 = "00110" and last2 = "00"
			 or first5 = "01010"
			 or first5 = "01011"
			 or first5 = "00110" and last2 = "11"
			 or first5 = "11011"
			 or first5 = "11010";

	MemToReg <= first5 = "10011" -- LW
				or first5 = "10010"; -- LW_SP

end Behavioral;
