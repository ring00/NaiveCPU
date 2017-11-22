----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    23:50:45 11/22/2017
-- Design Name:
-- Module Name:    HazardUnit - Behavioral
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

entity HazardUnit is
	Port (IDEXMemRead : in STD_LOGIC;
			IDEXRegDest : in STD_LOGIC_VECTOR(3 downto 0);
			RegSrcA : in STD_LOGIC_VECTOR(3 downto 0);
			RegSrcB : in STD_LOGIC_VECTOR(3 downto 0);
			DataHazard : out STD_LOGIC);
end HazardUnit;

architecture Behavioral of HazardUnit is
begin

	DataHazard <= '1' when IDEXMemRead = '1' and (IDEXRegDest = RegSrcA or IDEXRegDest = RegSrcB) else '0';

end Behavioral;
