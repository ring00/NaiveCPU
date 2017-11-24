----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    19:20:48 11/23/2017
-- Design Name:
-- Module Name:    CPUTop - Behavioral
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

entity CPUTop is
	Port (Clock50 : in  STD_LOGIC;
			Clock11 : in STD_LOGIC;
			Clock00 : in STD_LOGIC;
			Reset : in STD_LOGIC;

			Ram1OE : out STD_LOGIC;
			Ram1WE : out STD_LOGIC;
			Ram1EN : out STD_LOGIC;
			Ram1Addr : out STD_LOGIC_VECTOR(17 downto 0);
			Ram1Data : inout STD_LOGIC_VECTOR(15 downto 0);

			Ram2OE : out STD_LOGIC;
			Ram2WE : out STD_LOGIC;
			Ram2EN : out STD_LOGIC;
			Ram2Addr : out STD_LOGIC_VECTOR(17 downto 0);
			Ram2Data : inout STD_LOGIC_VECTOR(15 downto 0);

			SerialDataReady : in STD_LOGIC;
			SerialRDN : out STD_LOGIC;
			SerialWRN : out STD_LOGIC;
			SerialTBRE : in STD_LOGIC;
			SerialTSRE : in STD_LOGIC;

			FlashByte : out std_logic;
			FlashVpen : out std_logic;
			FlashCE : out std_logic;
			FlashOE : out std_logic;
			FlashWE : out std_logic;
			FlashRP : out std_logic;
			FlashAddr : out std_logic_vector(22 downto 0);
			FlashData : inout std_logic_vector(15 downto 0);

			LED : out std_logic_vector (15 downto 0));
end CPUTop;

architecture Behavioral of CPUTop is
	
	component CPU is
		Port (Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;

				InstAddress : out STD_LOGIC_VECTOR(15 downto 0);
				InstData : in STD_LOGIC_VECTOR(15 downto 0);

				DataAddress : out STD_LOGIC_VECTOR(15 downto 0);
				DataInput : in STD_LOGIC_VECTOR(15 downto 0);
				DataOutput : out STD_LOGIC_VECTOR(15 downto 0);

				MemReadEN : out STD_LOGIC;
				MemWriteEN : out STD_LOGIC);
	end component;

	signal InstAddress : STD_LOGIC_VECTOR(15 downto 0);
	signal DataAddress : STD_LOGIC_VECTOR(15 downto 0);
	signal CPUData : STD_LOGIC_VECTOR(15 downto 0);
	signal MemReadEN : STD_LOGIC;
	signal MemWriteEN : STD_LOGIC;

	component NorthBridge is
		port (Clock : in std_logic;
				Reset : in std_logic;
				CPUClock : out std_logic;

				ReadEN : in std_logic;
				WriteEN : in std_logic;

				Address1 : in std_logic_vector(15 downto 0);
				DataOutput1 : out std_logic_vector(15 downto 0);

				Address2 : in std_logic_vector(15 downto 0);
				DataInput2 : in std_logic_vector(15 downto 0);
				DataOutput2 : out std_logic_vector(15 downto 0);

				MemoryAddress : out std_logic_vector(17 downto 0);
				MemoryDataBus : inout std_logic_vector(15 downto 0);
				MemoryEN : out std_logic;
				MemoryOE : out std_logic;
				MemoryWE : out std_logic;

				RAM1EN : out std_logic;

				SerialWRN : out std_logic;
				SerialRDN : out std_logic;
				SerialDATA_READY : in std_logic;
				SerialTSRE : in std_logic;
				SerialTBRE : in std_logic;
				SerialDataBus : inout std_logic_vector(7 downto 0);

				FlashByte : out std_logic;
				FlashVpen : out std_logic;
				FlashCE : out std_logic;
				FlashOE : out std_logic;
				FlashWE : out std_logic;
				FlashRP : out std_logic;
				FlashAddr : out std_logic_vector(22 downto 0);
				FlashData : inout std_logic_vector(15 downto 0);

				LEDOut : out std_logic_vector(15 downto 0));
	end component;

	signal CPUClock : STD_LOGIC;
	signal InstData : STD_LOGIC_VECTOR(15 downto 0);
	signal RamData : STD_LOGIC_VECTOR(15 downto 0);
	signal ResetInv : STD_LOGIC;

begin

	ResetInv <= not Reset;

	CPUInstance : CPU port map (
		Clock => CPUClock,
		Reset => ResetInv,
		InstAddress => InstAddress,
		InstData => InstData,
		DataAddress => DataAddress,
		DataInput => RamData,
		DataOutput => CPUData,
		MemReadEN => MemReadEN,
		MemWriteEN => MemWriteEN
	);

	LED(12 downto 0) <= InstAddress(12 downto 0);
	LED(15 downto 13) <= SerialDataReady & SerialTBRE & SerialTSRE;

	NorthBridgeInstance : NorthBridge port map (
		Clock => Clock11,
		Reset => ResetInv,
		CPUClock => CPUClock,
		ReadEN => MemReadEN,
		WriteEN => MemWriteEN,
		Address1 => InstAddress,
		DataOutput1 => InstData,
		Address2 => DataAddress,
		DataInput2 => CPUData,
		DataOutput2 => RamData,
		MemoryAddress => Ram2Addr,
		MemoryDataBus => Ram2Data,
		MemoryEN => Ram2EN,
		MemoryOE => Ram2OE,
		MemoryWE => Ram2WE,
		RAM1EN => Ram1EN,
		SerialWRN => SerialWRN,
		SerialRDN => SerialRDN,
		SerialDATA_READY => SerialDataReady,
		SerialTSRE => SerialTSRE,
		SerialTBRE => SerialTBRE,
		SerialDataBus => Ram1Data(7 downto 0),

		FlashByte => FlashByte,
		FlashVpen => FlashVpen,
		FlashCE => FlashCE,
		FlashOE => FlashOE,
		FlashWE => FlashWE,
		FlashRP => FlashRP,
		FlashAddr => FlashAddr,
		FlashData => FlashData
		--LEDOut => LED
	);

	Ram1Data(15 downto 8) <= (others => 'Z');
	Ram1Addr <= (others => 'Z');
	Ram1OE <= '1';
	Ram1WE <= '1';

end Behavioral;
