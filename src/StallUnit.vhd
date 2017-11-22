----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    14:22:29 11/22/2017
-- Design Name:
-- Module Name:    StallUnit - Behavioral
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

entity StallUnit is
	Port (DataHazard : in STD_LOGIC;
			Misprediction : in STD_LOGIC;
			PCWriteEN : out STD_LOGIC;
			IFIDWriteEN : out STD_LOGIC;
			IDEXWriteEN : out STD_LOGIC;
			EXMEMWriteEN : out STD_LOGIC;
			MEMWBWriteEN : out STD_LOGIC;
			PCClear : out STD_LOGIC;
			IFIDClear : out STD_LOGIC;
			IDEXClear : out STD_LOGIC;
			EXMEMClear : out STD_LOGIC;
			MEMWBClear : out STD_LOGIC);
end StallUnit;

architecture Behavioral of StallUnit is
begin

	PCWriteEN <= '0' when DataHazard = '1' else
					 '1';

	IFIDWriteEN <= '0' when DataHazard = '1' else
						'1';

	IDEXWriteEN <= '1';

	EXMEMWriteEN <= '1';

	MEMWBWriteEN <= '1';

	PCClear <= '0';

	IFIDClear <= '1' when Misprediction = '1' else
					 '0';

	IDEXClear <= '1' when DataHazard = '1' else
					 '0';

	EXMEMClear <= '0';

	MEMWBClear <= '0';

end Behavioral;
