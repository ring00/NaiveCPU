----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    23:52:37 11/19/2017
-- Design Name:
-- Module Name:    MEMWB - Behavioral
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

entity MEMWB is
	Port (Clock : in STD_LOGIC;
			Reset : in STD_LOGIC;
			Clear : in STD_LOGIC;
			WriteEN : in STD_LOGIC;
			RegWriteInput : in STD_LOGIC;
			RegDestInput : in STD_LOGIC_VECTOR(3 downto 0);
			MemToRegInput : in STD_LOGIC;
			EXResultInput : in STD_LOGIC_VECTOR(15 downto 0);
			MemDataBInput : in STD_LOGIC_VECTOR(15 downto 0);
			RegWriteOutput : in STD_LOGIC;
			RegDestOutput : in STD_LOGIC_VECTOR(3 downto 0);
			MemToRegOutput : in STD_LOGIC;
			EXResultOutput : in STD_LOGIC_VECTOR(15 downto 0);
			MemDataBOutput : in STD_LOGIC_VECTOR(15 downto 0));
end MEMWB;

architecture Behavioral of MEMWB is

	signal RegWrite : STD_LOGIC;
	signal RegDest : STD_LOGIC_VECTOR(3 downto 0);
	signal MemToReg : STD_LOGIC;
	signal EXResult : STD_LOGIC_VECTOR(15 downto 0);
	signal MemDataB : STD_LOGIC_VECTOR(15 downto 0);

begin

	RegWriteOutput <= RegWrite;
	RegDestOutput <= RegDest;
	MemToRegOutput <= MemToReg;
	EXResultOutput <= EXResult;
	MemDataBOutput <= MemDataB;

	Update : process (Reset, Clock)
	begin
		if (Reset = '1') then
			RegWrite <= '0';
			RegDest <= '0';
			MemToReg <= '0';
			EXResult <= (others => '0');
			MemDataB <= (others => '0');
		elsif (RISING_EDGE(Clock)) then
			if (Clear = '1') then
				RegWrite <= '0';
				RegDest <= '0';
				MemToReg <= '0';
				EXResult <= (others => '0');
				MemDataB <= (others => '0');
			elsif (WriteEN = '1') then
				RegWrite <= RegWriteInput;
				RegDest <= RegDestInput;
				MemToReg <= MemToRegInput;
				EXResult <= EXResultInput;
				MemDataB <= MemDataBInput;
			end if;
		end if;
	end process Update;

end Behavioral;
