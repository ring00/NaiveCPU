----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    13:55:45 11/22/2017
-- Design Name:
-- Module Name:    PC - Behavioral
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

entity PC is
	Port (Clock : in STD_LOGIC;
			Reset : in STD_LOGIC;
			Clear : in STD_LOGIC;
			WriteEN : in STD_LOGIC;
			PCInput : in STD_LOGIC_VECTOR(15 downto 0);
			PCOutput : out STD_LOGIC_VECTOR(15 downto 0));
end PC;

architecture Behavioral of PC is

	signal PC : STD_LOGIC_VECTOR(15 downto 0);

begin

	PCOutput <= PC;

	Update : process (Reset, Clock)
	begin
		if (Reset = '1') then
			PC <= (others => '0');
		elsif (RISING_EDGE(Clock)) then
			if (Clear = '1') then
				PC <= (others => '0');
			elsif (WriteEN = '1') then
				PC <= PCInput;
			end if;
		end if;
	end process Update;

end Behavioral;
