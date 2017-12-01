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

			PS2Clock : in STD_LOGIC;
			PS2Data : in STD_LOGIC;

			Hs : out STD_LOGIC;
			Vs : out STD_LOGIC;
			R : out STD_LOGIC_VECTOR(2 downto 0);
			G : out STD_LOGIC_VECTOR(2 downto 0);
			B : out STD_LOGIC_VECTOR(2 downto 0);

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

	signal Reset : STD_LOGIC;

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
		Port (Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;
				CPUClock : out STD_LOGIC;

				BootROM : in STD_LOGIC;

				ReadEN : in STD_LOGIC;
				WriteEN : in STD_LOGIC;

				Address1 : in STD_LOGIC_VECTOR(15 downto 0);
				DataOutput1 : out STD_LOGIC_VECTOR(15 downto 0);

				Address2 : in STD_LOGIC_VECTOR(15 downto 0);
				DataInput2 : in STD_LOGIC_VECTOR(15 downto 0);
				DataOutput2 : out STD_LOGIC_VECTOR(15 downto 0);

				MemoryAddress : out STD_LOGIC_VECTOR(17 downto 0);
				MemoryDataBus : inout STD_LOGIC_VECTOR(15 downto 0);
				MemoryEN : out STD_LOGIC;
				MemoryOE : out STD_LOGIC;
				MemoryWE : out STD_LOGIC;

				RAM1EN : out STD_LOGIC;

				SerialWRN : out STD_LOGIC;
				SerialRDN : out STD_LOGIC;
				SerialDATA_READY : in STD_LOGIC;
				SerialTSRE : in STD_LOGIC;
				SerialTBRE : in STD_LOGIC;
				SerialDataBus : inout STD_LOGIC_VECTOR(7 downto 0);

				KeyboardRDN : out STD_LOGIC;
				KeyboardDATA_READY : in STD_LOGIC;
				KeyboardData : in STD_LOGIC_VECTOR(7 downto 0);

				VGAWriteEn : out STD_LOGIC;
				VGAWriteAddress : out STD_LOGIC_VECTOR(11 downto 0);
				VGAWriteData : out STD_LOGIC_VECTOR(7 downto 0);

				FlashByte : out STD_LOGIC;
				FlashVpen : out STD_LOGIC;
				FlashCE : out STD_LOGIC;
				FlashOE : out STD_LOGIC;
				FlashWE : out STD_LOGIC;
				FlashRP : out STD_LOGIC;
				FlashAddr : out STD_LOGIC_VECTOR(22 downto 0);
				FlashData : inout STD_LOGIC_VECTOR(15 downto 0));
	end component;

	signal CPUClock : STD_LOGIC;
	signal InstData : STD_LOGIC_VECTOR(15 downto 0);
	signal RamData : STD_LOGIC_VECTOR(15 downto 0);

	signal VGAWriteEn : STD_LOGIC;
	signal VGAWriteAddress : STD_LOGIC_VECTOR(11 downto 0);
	signal VGAWriteData : STD_LOGIC_VECTOR(7 downto 0);

	component Seg7 is
		Port (Number : in STD_LOGIC_VECTOR(3 downto 0);
				Display : out STD_LOGIC_VECTOR(6 downto 0));
	end component;

	signal Number0 : STD_LOGIC_VECTOR(3 downto 0);
	signal Number1 : STD_LOGIC_VECTOR(3 downto 0);

	component ClockManager
		Port (CLKIN_IN : in STD_LOGIC;
				RST_IN : in STD_LOGIC;
				CLKFX_OUT : out STD_LOGIC);
	end component;

	signal Clock : STD_LOGIC;
	signal ClockFX : STD_LOGIC;

	component KeyboardTop is
		Port (PS2Data : in STD_LOGIC;
				PS2Clock : in STD_LOGIC;
				Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;
				DataReceive : in STD_LOGIC;
				DataReady : out STD_LOGIC ;
				Output : out STD_LOGIC_VECTOR(7 downto 0));
	end component;

	signal KeyboardRDN : STD_LOGIC;
	signal KeyboardDATA_READY : STD_LOGIC;
	signal KeyboardData : STD_LOGIC_VECTOR(7 downto 0);

	component VGATop is
		Port (Reset : in STD_LOGIC;
				Clock : in STD_LOGIC;
				WriteEN : in STD_LOGIC;
				WriteAddress : in STD_LOGIC_VECTOR(11 downto 0);
				WriteData : in STD_LOGIC_VECTOR(7 downto 0);
				Hs, Vs : out STD_LOGIC;
				R, G, B : out STD_LOGIC_VECTOR(2 downto 0));
	end component;

begin

	Ram1Data(15 downto 8) <= (others => 'Z'); -- DON'T CARE
	Ram1Addr <= (others => 'Z'); -- DON'T CARE
	Ram1OE <= '1';
	Ram1WE <= '1';

	ClockManagerInstance : ClockManager port map (
		CLKIN_IN => Clock50,
		RST_IN => Reset,
		CLKFX_OUT => ClockFX
	);

	Number0 <= InstAddress(7 downto 4);
	Seg0 : Seg7 port map (
		Number => Number0,
		Display => DYP0
	);

	Number1 <= InstAddress(3 downto 0);
	Seg1 : Seg7 port map(
		Number => Number1,
		Display => DYP1
	);

	LED <= InstData;

	Reset <= not ResetInv;
	Clock <= Clock50 when SW(9) = '1' else ClockFX;

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
		BootROM => SW(8),
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
		Ram1EN => Ram1EN,
		SerialWRN => SerialWRN,
		SerialRDN => SerialRDN,
		SerialDATA_READY => SerialDataReady,
		SerialTSRE => SerialTSRE,
		SerialTBRE => SerialTBRE,
		SerialDataBus => Ram1Data(7 downto 0),
		KeyboardRDN => KeyboardRDN,
		KeyboardDATA_READY => KeyboardDATA_READY,
		KeyboardData => KeyboardData,
		VGAWriteEn => VGAWriteEn,
		VGAWriteAddress => VGAWriteAddress,
		VGAWriteData => VGAWriteData,
		FlashByte => FlashByte,
		FlashVpen => FlashVpen,
		FlashCE => FlashCE,
		FlashOE => FlashOE,
		FlashWE => FlashWE,
		FlashRP => FlashRP,
		FlashAddr => FlashAddr,
		FlashData => FlashData
	);

	KeyboardTopInstance : KeyboardTop port map (
		PS2Data => PS2Data,
		PS2Clock => PS2Clock,
		Clock => Clock,
		Reset => Reset,
		DataReceive => KeyboardRDN,
		DataReady => KeyboardDATA_READY,
		Output => KeyboardData
	);

	VGATopInstance : VGATop port map (
		Reset => Reset,
		Clock => Clock,
		WriteEN => VGAWriteEn,
		WriteAddress => VGAWriteAddress,
		WriteData => VGAWriteData,
		Hs => Hs,
		Vs => Vs,
		R => R,
		G => G,
		B => B
	);

end Behavioral;
