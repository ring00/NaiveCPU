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
	Port (Clock : in  STD_LOGIC;
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
			SerialTSRE : in STD_LOGIC);
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
		Port (Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;

				CPUClock : out STD_LOGIC;

				InstAddress : in STD_LOGIC_VECTOR(15 downto 0);
				InstData : out STD_LOGIC_VECTOR(15 downto 0);

				MemWriteEN : in STD_LOGIC;
				MemReadEN : in STD_LOGIC;
				DataAddress : in STD_LOGIC_VECTOR(15 downto 0);
				DataInput : in STD_LOGIC_VECTOR(15 downto 0);
				DataOutput : out STD_LOGIC_VECTOR(15 downto 0);

				Ram1OE : out STD_LOGIC;
				Ram1WE : out STD_LOGIC;
				Ram1EN : out STD_LOGIC;
				Ram1Addr : out STD_LOGIC_VECTOR(17 downto 0);
				Ram1Data : inout STD_LOGIC_VECTOR(15 downto 0);

				SerialDataReady : in STD_LOGIC;
				SerialRDN : out STD_LOGIC;
				SerialWRN : out STD_LOGIC;
				SerialTBRE : in STD_LOGIC;
				SerialTSRE : in STD_LOGIC;

				Ram2OE : out STD_LOGIC;
				Ram2WE : out STD_LOGIC;
				Ram2EN : out STD_LOGIC;
				Ram2Addr : out STD_LOGIC_VECTOR(17 downto 0);
				Ram2Data : inout STD_LOGIC_VECTOR(15 downto 0));
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

	NorthBridgeInstance : NorthBridge port map (
		Clock => Clock,
		Reset => ResetInv,
		CPUClock => CPUClock,
		InstAddress => InstAddress,
		InstData => InstData,
		MemWriteEN => MemWriteEN,
		MemReadEN => MemReadEN,
		DataAddress => DataAddress,
		DataInput => CPUData,
		DataOutput => RamData,
		Ram1OE => Ram1OE,
		Ram1WE => Ram1WE,
		Ram1EN => Ram1EN,
		Ram1Addr => Ram1Addr,
		Ram1Data => Ram1Data,
		SerialDataReady => SerialDataReady,
		SerialRDN => SerialRDN,
		SerialWRN => SerialWRN,
		SerialTBRE => SerialTBRE,
		SerialTSRE => SerialTSRE,
		Ram2OE => Ram2OE,
		Ram2WE => Ram2WE,
		Ram2EN => Ram2EN,
		Ram2Addr => Ram2Addr,
		Ram2Data => Ram2Data
	);

end Behavioral;
