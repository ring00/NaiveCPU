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
	port (Clock : in STD_LOGIC;
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

			Ram1EN : out STD_LOGIC;

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
end NorthBridge;

architecture Behavioral of NorthBridge is

	component Flash
		port (Clock : in STD_LOGIC;
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
	end component;

	type STATE_TYPE is (BOOT, BOOT_START, BOOT_FLASH, BOOT_RAM, BOOT_COMPLETE, DATA_PRE, DATA_RW, INS_READ);
	signal state : STATE_TYPE;

	signal BufferData1, BufferData2 : STD_LOGIC_VECTOR(15 downto 0);
	signal BF01 : STD_LOGIC_VECTOR(15 downto 0);
	signal BF03 : STD_LOGIC_VECTOR(15 downto 0);

	signal MemoryBusFlag, SerialBusFlag : STD_LOGIC;
	signal MemoryBusHolder : STD_LOGIC_VECTOR(15 downto 0);

	signal FlashBootMemAddr : STD_LOGIC_VECTOR(15 downto 0);
	signal FlashBootAddr : STD_LOGIC_VECTOR(22 downto 0);
	signal FlashAddrInput : STD_LOGIC_VECTOR(22 downto 0);
	signal FlashDataOutput : STD_LOGIC_VECTOR(15 downto 0);

	signal FlashTimer : STD_LOGIC_VECTOR(7 downto 0);
	signal FlashReadData : STD_LOGIC_VECTOR(15 downto 0);
	signal ctl_read : STD_LOGIC;

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
					'1' when (Address2(15 downto 12)=x"F" and state=DATA_RW) else
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

