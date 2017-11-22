----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    20:18:20 11/19/2017
-- Design Name:
-- Module Name:    ALU - Behavioral
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

entity ALU is
	Port (ALUop : in STD_LOGIC_VECTOR(3 downto 0);
			InputA : in STD_LOGIC_VECTOR(15 downto 0);
			InputB : in STD_LOGIC_VECTOR(15 downto 0);
			Output : out STD_LOGIC_VECTOR(15 downto 0));
end ALU;

architecture Behavioral of ALU is

	signal ShiftLeftFillZero : STD_LOGIC_VECTOR(15 downto 0);
	signal ShiftRightFillZero : STD_LOGIC_VECTOR(15 downto 0);
	signal ShiftRightFillOne : STD_LOGIC_VECTOR(15 downto 0);

	signal Equal : BOOLEAN;
	signal SignedLessThan : BOOLEAN;
	signal UnsignedLessThan : BOOLEAN;

	constant ZERO : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
	constant ONE : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000001";

begin

	with InputB(2 downto 0) select ShiftLeftFillZero <=
		InputA(14 downto 0) & "0" when "001",
		InputA(13 downto 0) & "00" when "010",
		InputA(12 downto 0) & "000" when "011",
		InputA(11 downto 0) & "0000" when "100",
		InputA(10 downto 0) & "00000" when "101",
		InputA( 9 downto 0) & "000000" when "110",
		InputA( 8 downto 0) & "0000000" when "111",
		InputA( 7 downto 0) & "00000000" when "000",
		ZERO when others;

	with InputB(2 downto 0) select ShiftRightFillZero <=
		"0" & InputA(15 downto 1) when "001",
		"00" & InputA(15 downto 2) when "010",
		"000" & InputA(15 downto 3) when "011",
		"0000" & InputA(15 downto 4) when "100",
		"00000" & InputA(15 downto 5) when "101",
		"000000" & InputA(15 downto 6) when "110",
		"0000000" & InputA(15 downto 7) when "111",
		"00000000" & InputA(15 downto 8) when "000",
		ZERO when others;

	with InputB(2 downto 0) select ShiftRightFillOne <=
		"1" & InputA(15 downto 1) when "001",
		"11" & InputA(15 downto 2) when "010",
		"111" & InputA(15 downto 3) when "011",
		"1111" & InputA(15 downto 4) when "100",
		"11111" & InputA(15 downto 5) when "101",
		"111111" & InputA(15 downto 6) when "110",
		"1111111" & InputA(15 downto 7) when "111",
		"11111111" & InputA(15 downto 8) when "000",
		ZERO when others;

	Equal <= InputA = InputB;

	SignedLessThan <= SIGNED(InputA) < SIGNED(InputB);

	UnsignedLessThan <= UNSIGNED(InputA) < UNSIGNED(InputB);

	Output <= STD_LOGIC_VECTOR(UNSIGNED(InputA) + UNSIGNED(InputB)) when ALUop = "0000" else
				 STD_LOGIC_VECTOR(UNSIGNED(InputA) - UNSIGNED(InputB)) when ALUop = "0001" else
				 InputA and InputB when ALUop = "0010" else
				 InputA or InputB when ALUop = "0011" else
				 ShiftLeftFillZero when ALUop = "0100" else
				 ShiftRightFillZero when ALUop = "0101" else
				 ShiftRightFillZero when (ALUop = "0110" and InputA(15) = '0') else
				 ShiftRightFillOne when (ALUop = "0110" and InputA(15) = '1') else
				 ZERO when (ALUop = "0111" and Equal) else
				 ONE when (ALUop = "0111" and not Equal) else
				 ZERO when (ALUop = "1000" and not SignedLessThan) else
				 ONE when (ALUop = "1000" and SignedLessThan) else
				 ZERO when (ALUop = "1001" and not UnsignedLessThan) else
				 ONE when (ALUop = "1001" and UnsignedLessThan) else
				 ZERO;

end Behavioral;
