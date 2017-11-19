----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    23:52:37 11/19/2017
-- Design Name:
-- Module Name:    IFID - Behavioral
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

entity IFID is
	Port (Clock : in  STD_LOGIC;
			Reset : in  STD_LOGIC;
			Clear : in  STD_LOGIC;
			WriteEN : in  STD_LOGIC;

			InstructionInput : in  STD_LOGIC_VECTOR(15 downto 0);
			PCInput : in  STD_LOGIC_VECTOR(15 downto 0);

			InstructionOutput : out  STD_LOGIC_VECTOR(15 downto 0);
			PCOutput : out  STD_LOGIC_VECTOR(15 downto 0));
end IFID;

architecture Behavioral of IFID is

	signal Instruction : STD_LOGIC_VECTOR(15 downto 0);
	signal PC : STD_LOGIC_VECTOR(15 downto 0);

begin

	InstructionOutput <= Instruction;

	PCOutput <= PC;

	Update : process (Reset, Clock)
	begin
		if (Reset = '1') then
			Instruction <= (others => '0');
			PC <= (others => '0');
		elsif (RISING_EDGE(Clock)) then
			if (Clear = '1') then
				Instruction <= (others => '0');
				PC <= (others => '0');
			elsif (WriteEN = '1') then
				Instruction <= InstructionInput;
				PC <= PCInput;
			end if;
		end if;
	end process Update;

end Behavioral;
