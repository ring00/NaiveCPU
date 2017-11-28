----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    23:47:20 11/27/2017
-- Design Name:
-- Module Name:    Keyboard - Behavioral
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

entity Keyboard is
	Port (Clock : in STD_LOGIC; -- 50~71MHz Clock
			Reset : in STD_LOGIC;
			PS2Clock : in STD_LOGIC; -- U6, PS2 clock
			PS2Data : in STD_LOGIC; -- V6, PS2 data
			DataReady : out STD_LOGIC; -- Keyboard data ready for retriving
			Output : out STD_LOGIC_VECTOR(7 downto 0)); -- ASCII code
end Keyboard;

architecture Behavioral of Keyboard is

begin

end Behavioral;
