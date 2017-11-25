----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    01:13:23 11/27/2015
-- Design Name:
-- Module Name:    FlashAdapter - Behavioral
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

entity FlashAdapter is
	port (
		Clock : in STD_LOGIC;
		Reset : in STD_LOGIC;
		Address : in STD_LOGIC_VECTOR(22 downto 0);
		OutputData : out STD_LOGIC_VECTOR(15 downto 0);
		ctl_read : in STD_LOGIC;

		FlashByte : out STD_LOGIC;
		FlashVpen : out STD_LOGIC;
		FlashCE : out STD_LOGIC;
		FlashOE : out STD_LOGIC;
		FlashWE : out STD_LOGIC;
		FlashRP : out STD_LOGIC;

		FlashAddr : out STD_LOGIC_VECTOR(22 downto 0);
		FlashData : inout STD_LOGIC_VECTOR(15 downto 0)
	);
end FlashAdapter;

architecture Behavioral of FlashAdapter is
	type STATE_TYPE is (INIT, READ1, READ2, READ3, READ4);
	signal state : STATE_TYPE;
	signal ctl_read_last : STD_LOGIC;
begin

	FlashByte <= '1';
	FlashVpen <= '1';
	FlashRP <= '1';
	FlashCE <= '0';

	process(Clock, Reset)
	begin
		if Reset = '1' then
			state <= INIT;
			FlashWE <= '1';
			FlashOE <= '1';
			FlashData <= (others => 'Z');
			ctl_read_last <= ctl_read;
		elsif RISING_EDGE(Clock) then
			case state is
				when INIT =>
					if ctl_read_last /= ctl_read then
						state <= READ1;
						FlashWE <= '0';
					else
						state <= INIT;
					end if;
				when READ1 =>
					state <= READ2;
					FlashData <= x"00FF";
				when READ2 =>
					state <= READ3;
					FlashWE <= '1';
				when READ3 =>
					state <= READ4;
					FlashOE <= '0';
					FlashAddr <= Address;
					FlashData <= (others => 'Z');
				when READ4 =>
					state <= INIT;
					OutputData <= FlashData;
				when others =>
					FlashWE <= '1';
					FlashOE <= '1';
					FlashData <= (others => 'Z');
					state <= INIT;
			end case;
		end if;
	end process;

end Behavioral;

