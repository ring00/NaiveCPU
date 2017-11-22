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

entity RegisterFile is
	Port (Clock : in STD_LOGIC;
			Reset : in STD_LOGIC;
			Clear : in STD_LOGIC;
			WriteEN : in STD_LOGIC;
			ReadRegA : in STD_LOGIC_VECTOR(3 downto 0);
			ReadRegB : in STD_LOGIC_VECTOR(3 downto 0);
			WriteReg : in STD_LOGIC_VECTOR(3 downto 0);
			WriteData : in STD_LOGIC_VECTOR(15 downto 0);
			PCInput : in STD_LOGIC_VECTOR(15 downto 0);
			ReadDataA : out STD_LOGIC_VECTOR(15 downto 0);
			ReadDataB : out STD_LOGIC_VECTOR(15 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is

	type RegisterArray is array(0 to 11) of STD_LOGIC_VECTOR(15 downto 0);
	signal Registers : RegisterArray;

begin

	with ReadRegA select ReadDataA <=
		(others => '0') when "0000",
		PCInput when "0001",
		Registers(to_integer(unsigned(ReadRegA))) when others;

	with ReadRegB select ReadDataB <=
		(others => '0') when "0000",
		PCInput when "0001",
		Registers(to_integer(unsigned(ReadRegA))) when others;

	Update : process (Reset, Clock)
	begin
		if (Reset = '1') then
			Registers <= (others => (others => '0'));
		elsif (FALLING_EDGE(Clock)) then -- TODO: Should I use FALLING_EDGE here?
			if (Clear = '1') then
				Registers <= (others => (others => '0'));
			elsif (WriteEN = '1') then
				Registers(to_integer(unsigned(WriteReg))) <= WriteData;
			end if;
		end if;
	end process Update;

end Behavioral;
