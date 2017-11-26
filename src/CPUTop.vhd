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
			Click : in STD_LOGIC;
			ResetInv : in STD_LOGIC;

			SW : in STD_LOGIC_VECTOR(15 downto 0);

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

			FlashByte : out STD_LOGIC;
			FlashVpen : out STD_LOGIC;
			FlashCE : out STD_LOGIC;
			FlashOE : out STD_LOGIC;
			FlashWE : out STD_LOGIC;
			FlashRP : out STD_LOGIC;
			FlashAddr : out STD_LOGIC_VECTOR(22 downto 0);
			FlashData : inout STD_LOGIC_VECTOR(15 downto 0);

			LED : out STD_LOGIC_VECTOR(15 downto 0);

			DYP0 : out STD_LOGIC_VECTOR(6 downto 0);
			DYP1 : out STD_LOGIC_VECTOR(6 downto 0));
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
	signal CPUDataOutput : STD_LOGIC_VECTOR(15 downto 0);
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
				FlashData : inout std_logic_vector(15 downto 0));
	end component;

	signal CPUClock : STD_LOGIC;
	signal InstData : STD_LOGIC_VECTOR(15 downto 0);
	signal RamData : STD_LOGIC_VECTOR(15 downto 0);
	signal Reset : STD_LOGIC;

	component Seg7 is
	port(
		Number : in STD_LOGIC_VECTOR(3 downto 0);
		Dispaly : out STD_LOGIC_VECTOR(6 downto 0)
	);
	end component;

	signal Number0 : STD_LOGIC_VECTOR(3 downto 0);
	signal Number1 : STD_LOGIC_VECTOR(3 downto 0);

	component ClockManager
	port(
		CLKIN_IN : in STD_LOGIC;
		RST_IN : in STD_LOGIC;          
		CLKFX_OUT : out STD_LOGIC
	);
	end component;

	signal Clock : STD_LOGIC;
	signal ClockFX : STD_LOGIC;

begin

	ClockManagerInstance : ClockManager port map (
		CLKIN_IN => Clock50,
		RST_IN => Reset,
		CLKFX_OUT => ClockFX
	);

	Seg0 : Seg7 port map (
		Number0, DYP0
	);
	--DYP0 <= (others => '0');

	Number0 <= InstAddress(7 downto 4);

	Seg1 : Seg7 port map(
		Number1, DYP1
	);
	--DYP1 <= (others => '0');

	Number1 <= InstAddress(3 downto 0);

	LED <= InstData;
	--LED <= (others => '0');

	Clock <= ClockFX;
	Reset <= not ResetInv;

	CPUInstance : CPU port map (
		Clock => CPUClock,
		Reset => Reset,
		InstAddress => InstAddress,
		InstData => InstData,
		DataAddress => DataAddress,
		DataInput => RamData,
		DataOutput => CPUDataOutput,
		MemReadEN => MemReadEN,
		MemWriteEN => MemWriteEN
	);

	NorthBridgeInstance : NorthBridge port map (
		Clock => Clock,
		Reset => Reset,
		CPUClock => CPUClock,
		ReadEN => MemReadEN,
		WriteEN => MemWriteEN,
		Address1 => InstAddress,
		DataOutput1 => InstData,
		Address2 => DataAddress,
		DataInput2 => CPUDataOutput,
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
	);

	Ram1Data(15 downto 8) <= (others => '0');
	Ram1Addr <= (others => '0');
	Ram1OE <= '1';
	Ram1WE <= '1';

end Behavioral;
