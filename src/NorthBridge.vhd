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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NorthBridge is
	port (Clock : in std_logic;
			Reset : in std_logic;
			CPUClock : out std_logic;

			BootROM : in std_logic;

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

			Ram1EN : out std_logic;

			SerialWRN : out std_logic;
			SerialRDN : out std_logic;
			SerialDATA_READY : in std_logic;
			SerialTSRE : in std_logic;
			SerialTBRE : in std_logic;
			SerialDataBus : inout std_logic_vector(7 downto 0);

			KeyboardRDN : out std_logic;
			KeyboardDATA_READY : in std_logic;
			KeyboardData : in std_logic_vector(7 downto 0);

			VGAWriteEn : out STD_LOGIC;
			VGAWriteAddress : out STD_LOGIC_VECTOR(11 downto 0);
			VGAWriteData : out STD_LOGIC_VECTOR(7 downto 0);

			FlashByte : out std_logic;
			FlashVpen : out std_logic;
			FlashCE : out std_logic;
			FlashOE : out std_logic;
			FlashWE : out std_logic;
			FlashRP : out std_logic;
			FlashAddr : out std_logic_vector(22 downto 0);
			FlashData : inout std_logic_vector(15 downto 0));
end NorthBridge;

architecture Behavioral of NorthBridge is

	component Flash
		port (Clock : in std_logic;
				Reset : in std_logic;
				Address : in std_logic_vector(22 downto 0);
				OutputData : out std_logic_vector(15 downto 0);
				ctl_read : in std_logic;

				FlashByte : out std_logic;
				FlashVpen : out std_logic;
				FlashCE : out std_logic;
				FlashOE : out std_logic;
				FlashWE : out std_logic;
				FlashRP : out std_logic;

				FlashAddr : out std_logic_vector(22 downto 0);
				FlashData : inout std_logic_vector(15 downto 0)
		);
	end component;

	type STATE_TYPE is (BOOT, BOOT_START, BOOT_FLASH, BOOT_RAM, BOOT_COMPLETE, DATA_PRE, DATA_RW, INS_READ);
	signal state : STATE_TYPE;

	signal BufferData1, BufferData2 : std_logic_vector(15 downto 0);
	signal BF01 : std_logic_vector(15 downto 0);
	signal BF03 : std_logic_vector(15 downto 0);

	signal MemoryBusFlag, SerialBusFlag : std_logic;
	signal MemoryBusHolder : std_logic_vector(15 downto 0);

	signal FlashBootMemAddr : std_logic_vector(15 downto 0);
	signal FlashBootAddr : std_logic_vector(22 downto 0);
	signal FlashAddrInput : std_logic_vector(22 downto 0);
	signal FlashDataOutput : std_logic_vector(15 downto 0);

	signal FlashTimer : std_logic_vector(7 downto 0);
	signal FlashReadData : std_logic_vector(15 downto 0);
	signal ctl_read : std_logic;

begin

	FlashAdapterInstance : Flash port map (
		Clock => Clock,
		Reset => Reset,
		Address => FlashAddrInput,
		OutputData => FlashDataOutput,
		ctl_read => ctl_read,

		FlashByte => FlashByte,
		FlashVpen => FlashVpen,
		FlashCE => FlashCE,
		FlashOE => FlashOE,
		FlashWE => FlashWE,
		FlashRP => FlashRP,

		FlashAddr => FlashAddr,
		FlashData => FlashData
	);

	MemoryEN <= '0';
	Ram1EN <= '1';

	DataOutput1 <= MemoryDataBus;
	DataOutput2 <= BufferData2;

	CPUClock <= '0' when state=INS_READ else '1';

	MemoryWE <= '1' when (Address2=x"BF00" and state=DATA_RW) else
					'1' when (Address2=x"BF01" and state=DATA_RW) else
					'1' when (Address2=x"BF02" and state=DATA_RW) else
					'1' when (Address2=x"BF03" and state=DATA_RW) else
					not WriteEN when state=DATA_RW else
					'0' when state=BOOT_RAM else
					'1';

	MemoryOE <= not ReadEN when state=DATA_RW else
					'0' when state=INS_READ else
					'1';

	MemoryBusFlag <= not WriteEN when (state=DATA_PRE or state=DATA_RW) else
						  '0' when (state=BOOT_RAM or state=BOOT_FLASH) else
						  '1';
	SerialBusFlag <= not WriteEN;
	MemoryBusHolder <= FlashReadData when (state=BOOT_FLASH or state=BOOT_RAM) else DataInput2;
	MemoryDataBus <= MemoryBusHolder when MemoryBusFlag='0' else (others => 'Z');
	SerialDataBus <= DataInput2(7 downto 0) when SerialBusFlag='0' else (others => 'Z');

	MemoryAddress <= "00" & FlashBootMemAddr when (state=BOOT_FLASH or state=BOOT_RAM) else
						  "00" & Address1 when state=INS_READ else
						  "00" & Address2;

	SerialRDN <= not ReadEN when (Address2=x"BF00" and (state=DATA_PRE or state=DATA_RW)) else '1';
	SerialWRN <= not WriteEN when (Address2=x"BF00" and (state=INS_READ or state=DATA_RW)) else '1';

	VGAWriteEn <= '1' when (WriteEN='1' and state=DATA_RW and (Address2(15 downto 12) = X"F")) else '0';
	VGAWriteAddress <= Address2(11 downto 0);
	VGAWriteData <= DataInput2(7 downto 0);

	KeyboardRDN <= '0' when (Address2=x"BF02" and state=DATA_RW) else '1';

	BF01 <= "00000000000000" & SerialDATA_READY & (SerialTSRE and SerialTBRE);
	BF03 <= "000000000000000" & KeyboardDATA_READY;

	ctl_read <= '0' when state=BOOT_FLASH else '1';

	process (Clock, Reset)
	begin
		if Reset = '1' then
			if BootROM = '1' then
				state <= BOOT_START;
			else
				state <= BOOT_COMPLETE;
			end if;
		elsif RISING_EDGE(Clock) then
			case state is
				when BOOT =>
					state <= BOOT;
				when BOOT_START =>
					state <= BOOT_FLASH;
					FlashTimer <= (others => '0');
					FlashBootMemAddr <= (others => '0');
					FlashBootAddr <= (others => '0');
				when BOOT_FLASH =>
					case FlashTimer is
						when "00000000" =>
							FlashAddrInput <= FlashBootAddr;
							FlashTimer <= STD_LOGIC_VECTOR(UNSIGNED(FlashTimer) + 1);
							state <= BOOT_FLASH;
						when "11111111" =>
							state <= BOOT_RAM;
							FlashReadData <= FlashDataOutput;
							FlashTimer <= (others => '0');
						when others =>
							FlashTimer <= STD_LOGIC_VECTOR(UNSIGNED(FlashTimer) + 1);
							state <= BOOT_FLASH;
					end case;
				when BOOT_RAM =>
					FlashBootAddr <= STD_LOGIC_VECTOR(UNSIGNED(FlashBootAddr) + 2);
					FlashBootMemAddr <= STD_LOGIC_VECTOR(UNSIGNED(FlashBootMemAddr) + 1);
					if FlashBootMemAddr < x"0FFF" then
						state <= BOOT_FLASH;
					else
						state <= BOOT_COMPLETE;
					end if;
				when BOOT_COMPLETE =>
					state <= DATA_PRE;
				when DATA_PRE =>
					if ReadEN='1' or WriteEN='1' then
						state <= DATA_RW;
					else
						state <= INS_READ;
					end if;
				when DATA_RW =>
					state <= INS_READ;
					case Address2 is
						when x"BF00" =>
							BufferData2 <= "00000000" & SerialDataBus;
						when x"BF01" =>
							BufferData2 <= BF01;
						when x"BF02" =>
							BufferData2 <= "00000000" & KeyboardData;
						when x"BF03" =>
							BufferData2 <= BF03;
						when others =>
							BufferData2 <= MemoryDataBus;
					end case;
				when INS_READ =>
					state <= DATA_PRE;
					BufferData1 <= MemoryDataBus;
				when others =>
					state <= BOOT;
			end case;
		end if;
	end process;

end Behavioral;

