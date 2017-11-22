----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    23:52:37 11/19/2017
-- Design Name:
-- Module Name:    EXMEM - Behavioral
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

entity EXMEM is
	Port (Clock : in STD_LOGIC;
			Reset : in STD_LOGIC;
			Clear : in STD_LOGIC;
			WriteEN : in STD_LOGIC;
			RegWriteInput : in STD_LOGIC;
			MemReadInput : in STD_LOGIC;
			MemWriteInput : in STD_LOGIC;
			RegDestInput : in STD_LOGIC_VECTOR(3 downto 0);
			MemToRegInput : in STD_LOGIC;
			EXResultInput : in STD_LOGIC_VECTOR(15 downto 0);
			RegDataBInput : in STD_LOGIC_VECTOR(15 downto 0);
			RegWriteOutput : out STD_LOGIC;
			MemReadOutput : out STD_LOGIC;
			MemWriteOutput : out STD_LOGIC;
			RegDestOutput : out STD_LOGIC_VECTOR(3 downto 0);
			MemToRegOutput : out STD_LOGIC;
			EXResultOutput : out STD_LOGIC_VECTOR(15 downto 0);
			RegDataBOutput : out STD_LOGIC_VECTOR(15 downto 0));
end EXMEM;

architecture Behavioral of EXMEM is

	RegWrite : STD_LOGIC;
	MemRead : STD_LOGIC;
	MemWrite : STD_LOGIC;
	RegDest : STD_LOGIC_VECTOR(3 downto 0);
	MemToReg : STD_LOGIC;
	EXResult : STD_LOGIC_VECTOR(15 downto 0);
	RegDataB : STD_LOGIC_VECTOR(15 downto 0);

begin

	RegWriteOutput <= RegWrite;
	MemReadOutput <= MemRead;
	MemWriteOutput <= MemWrite;
	RegDestOutput <= RegDest;
	MemToRegOutput <= MemToReg;
	EXResultOutput <= EXResult;
	RegDataBOutput <= RegDataB;

	Update : process (Reset, Clock)
	begin
		if (Reset = '1') then
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			RegDest <= (others => '0');
			MemToReg <= '0';
			EXResult <= (others => '0');
			RegDataB <= (others => '0');
		elsif (RISING_EDGE(Clock)) then
			if (Clear = '1') then
				RegWrite <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				RegDest <= (others => '0');
				MemToReg <= '0';
				EXResult <= (others => '0');
				RegDataB <= (others => '0');
			elsif (WriteEN = '1') then
				RegWrite <= RegWriteInput;
				MemRead <= MemReadInput;
				MemWrite <= MemWriteInput;
				RegDest <= RegDestInput;
				MemToReg <= MemToRegInput;
				EXResult <= EXResultInput;
				RegDataB <= RegDataBInput;
			end if;
		end if;
	end process Update;

end Behavioral;
