----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:12:22 11/21/2017
-- Design Name:
-- Module Name:    NorthBridge - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: TODO: Fix bugs in this module.
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

entity NorthBridge is
	Port (Clock : in STD_LOGIC;
			Reset : in STD_LOGIC;

			CPUClock : out STD_LOGIC;

			InstAddress : in STD_LOGIC_VECTOR(15 downto 0);
			InstData : out STD_LOGIC_VECTOR(15 downto 0);

			MemWriteEN : in STD_LOGIC;
			MemReadEN : in STD_LOGIC;
			DataAddress : in STD_LOGIC_VECTOR(15 downto 0);
			DataOutput : in STD_LOGIC_VECTOR(15 downto 0);

			Ram1OE : out STD_LOGIC;
			Ram1WE : out STD_LOGIC;
			Ram1EN : out STD_LOGIC;
			Ram1Addr : out STD_LOGIC_VECTOR(17 downto 0);
			Ram1Data : inout STD_LOGIC_VECTOR(15 downto 0);

			SerialDataReady : in STD_LOGIC;
			SerialData : inout STD_LOGIC_VECTOR(7 downto 0);
			SerialRDN : out STD_LOGIC;
			SerialWRN : out STD_LOGIC;
			SerialTBRE : in STD_LOGIC;
			SerialTSRE : in STD_LOGIC;

			Ram2OE : out STD_LOGIC;
			Ram2WE : out STD_LOGIC;
			Ram2EN : out STD_LOGIC;
			Ram2Addr : out STD_LOGIC_VECTOR(17 downto 0);
			Ram2Data : inout STD_LOGIC_VECTOR(15 downto 0));
end NorthBridge;

architecture Behavioral of NorthBridge is

	type STATE_TYPE is (DATA_SETUP, MEM_ACCESS, INST_FETCH);
	signal state : STATE_TYPE;

	signal Ram1DataBuffer : STD_LOGIC_VECTOR(15 downto 0); -- not used
	signal Ram2DataBuffer : STD_LOGIC_VECTOR(15 downto 0);

	--signal DataOutputBuffer : STD_LOGIC_VECTOR(15 downto 0);

begin

	Ram1EN <= '1';
	Ram1WE <= '1';
	Ram1OE <= '1';
	Ram1Addr <= (others => 'Z');
	Ram1Data <= Ram2Data; -- directly linked to RAM2 data line

	Ram2EN <= '1';
	Ram2WE <= '1' when ((DataAddress = x"BF00" or DataAddress = x"BF01" or DataAddress = x"BF02" or DataAddress = x"BF03") and state = MEM_ACCESS) else
				 not MemWriteEN when (state = MEM_ACCESS) else
				 '1';
	Ram2OE <= '1' when ((DataAddress = x"BF00" or DataAddress = x"BF01" or DataAddress = x"BF02" or DataAddress = x"BF03") and state = MEM_ACCESS) else
				 not MemReadEN when (state = MEM_ACCESS) else
				 '1';
	Ram2Addr <= "00" & DataAddress;
	Ram2Data <= DataOutput when (MemWriteEN = '1' and (state = DATA_SETUP or state = MEM_ACCESS)) else
					(others => 'Z');

	SerialWRN <= not MemWriteEN when (DataAddress = x"BF00" and (state = DATA_SETUP or state = MEM_ACCESS)) else
					 '1';
	SerialRDN <= not MemReadEN when (DataAddress = x"BF00" and (state = DATA_SETUP or state = MEM_ACCESS)) else
					 '1';
	SerialData <= DataOutput(7 downto 0) when (MemWriteEN = '1' and (state = DATA_SETUP or state = MEM_ACCESS)) else
					  (others => 'Z');

	CPUClock <= '0' when (state = INST_FETCH) else
					'1';

	Update : process(Clock, Reset)
	begin
		if (Reset = '1') then
			state <= DATA_SETUP;
		elsif (rising_edge(Clock)) then
			case state is
				when DATA_SETUP =>
					if (MemReadEN = '1' or MemWriteEN = '1') then
						state <= MEM_ACCESS;
					else
						state <= INST_FETCH;
					end if;
				when MEM_ACCESS =>
					case DataAddress is
						when x"BF00" =>
							Ram2DataBuffer <= x"00" & SerialData;
						when x"BF01" =>
							Ram2DataBuffer <= "00000000000000" & SerialDataReady & (SerialTBRE and SerialTSRE);
						when x"BF02" =>
							Ram2DataBuffer <= x"DEAD";
						when x"BF03" =>
							Ram2DataBuffer <= x"BEEF";
						when others =>
							Ram2DataBuffer <= Ram2Data;
					end case;
				when INST_FETCH =>
					state <= DATA_SETUP;
				when others =>
					state <= DATA_SETUP;
			end case;
		end if;
	end process ; -- Update

end Behavioral;

