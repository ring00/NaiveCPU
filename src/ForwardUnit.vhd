----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    13:44:10 11/22/2017
-- Design Name:
-- Module Name:    ForwardUnit - Behavioral
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

entity ForwardUnit is
	Port (EXMEMRegWrite : in STD_LOGIC;
			MEMWBRegWrite : in STD_LOGIC;
			EXMEMRegDest : in STD_LOGIC_VECTOR(3 downto 0);
			MEMWBRegDest : in STD_LOGIC_VECTOR(3 downto 0);
			IDEXRegSrcA : in STD_LOGIC_VECTOR(3 downto 0);
			IDEXRegSrcB : in STD_LOGIC_VECTOR(3 downto 0);
			ForwardA : out STD_LOGIC_VECTOR(1 downto 0);
			ForwardB : out STD_LOGIC_VECTOR(1 downto 0));
end ForwardUnit;

architecture Behavioral of ForwardUnit is
begin

	ForwardA <= "01" when (EXMEMRegWrite = '1') and (EXMEMRegDest = IDEXRegSrcA) else
					"10" when (EXMEMRegWrite = '1') and (MEMWBRegDest = IDEXRegSrcA) and not (EXMEMRegWrite = '1' and EXMEMRegDest = IDEXERegSrcA) else
					"00";

	ForwardB <= "01" when (EXMEMRegWrite = '1') and (EXMEMRegDest = IDEXRegSrcB) else
					"10" when (EXMEMRegWrite = '1') and (MEMWBRegDest = IDEXRegSrcB) and not (EXMEMRegWrite = '1' and EXMEMRegDest = IDEXERegSrcB) else
					"00";

end Behavioral;
