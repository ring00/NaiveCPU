----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:46:21 11/24/2017 
-- Design Name: 
-- Module Name:    FrequencyDivider - Behavioral 
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

entity FrequencyDivider is
	Port (Reset : in STD_LOGIC;
			Clock11 : in  STD_LOGIC;
			Clock01 : out  STD_LOGIC);
end FrequencyDivider;

architecture Behavioral of FrequencyDivider is

	signal counter : integer range 0 to 900000;
	signal tmp : STD_LOGIC := '0';

begin

	Clock01 <= tmp;

	FrequencyDivider: process (Clock11, Reset) begin
		if Reset = '1' then
			tmp <= '0';
			counter <= 0;
		elsif RISING_EDGE(Clock11) then
			if (counter = 900000) then
				tmp <= not tmp;
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
		end if;
	 end process;

end Behavioral;

