----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12:01:00 11/22/2017
-- Design Name:
-- Module Name:    BranchSelector - Behavioral
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

entity BranchSelector is
	Port (BranchType : in STD_LOGIC_VECTOR(2 downto 0);
			BranchInput : in STD_LOGIC_VECTOR(15 downto 0);
			RegisterInput : in STD_LOGIC_VECTOR(15 downto 0);
			Branch : out STD_LOGIC;
			Address : out STD_LOGIC_VECTOR(15 downto 0));
end BranchSelector;

architecture Behavioral of BranchSelector is
begin

	with BranchType select Address <=
		RegisterInput when "010", -- JR
		BranchInput when others; -- B, BEQZ, BNEZ, BTEQZ, BTNEZ

	Branch <= '1' when BranchType = "001"
						 or BranchType = "010"
						 or (BranchType = "011" and RegisterInput = x"0000")
						 or (BranchType = "100" and RegisterInput /= x"0000") else
				 '0';

end Behavioral;
