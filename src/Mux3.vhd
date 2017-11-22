----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    13:15:20 11/22/2017
-- Design Name:
-- Module Name:    Mux3 - Behavioral
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

entity Mux3 is
	Port (Sel : in STD_LOGIC;
			InputA : in STD_LOGIC_VECTOR(15 downto 0);
			InputB : in STD_LOGIC_VECTOR(15 downto 0);
			InputC : in STD_LOGIC_VECTOR(15 downto 0);
			Output : out STD_LOGIC_VECTOR(15 downto 0));
end Mux3;

architecture Behavioral of Mux3 is
begin

	with Sel select Output <=
		InputA when "00",
		InputB when "01",
		InputC when "10",
		(others => '0') when others;

end Behavioral;
