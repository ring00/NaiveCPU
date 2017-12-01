----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:05:13 11/30/2017
-- Design Name:
-- Module Name:    Keyboard - Behavioral
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

entity Keyboard is
	port (PS2Data : in STD_LOGIC; -- PS2 data
			PS2Clock : in STD_LOGIC; -- PS2 clk
			Clock : in STD_LOGIC;
			Reset : in STD_LOGIC;
			DataReceive : in STD_LOGIC;
			DataReady : out STD_LOGIC;  -- data output enable signal
			Output : out STD_LOGIC_VECTOR(7 downto 0)); -- scan code signal output
end Keyboard;

architecture Behavioral of Keyboard is

	type STATE_TYPE is (DELAY, START, S0, S1, S2, S3, S4, S5, S6, S7, PARITY, STOP, FINISH);
	signal data, clk, clk1, clk2, odd, fokSignal : STD_LOGIC;
	signal code : STD_LOGIC_VECTOR(7 downto 0);
	signal OutputCode : STD_LOGIC_VECTOR(7 downto 0);
	signal flag : STD_LOGIC;
	signal state : STATE_TYPE;

begin
	clk1 <= PS2Clock when rising_edge(Clock);
	clk2 <= clk1 when rising_edge(Clock);
	clk <= (not clk1) and clk2;
	data <= PS2Data when rising_edge(Clock);
	odd <= code(0) xor code(1) xor code(2) xor code(3) xor code(4) xor code(5) xor code(6) xor code(7);
	OutputCode <= code when fokSignal = '1';

	process(Reset, Clock)
	begin
		if Reset = '1' then
			state <= DELAY;
			code <= (others => '0');
			fokSignal <= '1';
			code <= (others => '0');
			fokSignal <= '0';
			DataReady <= '0';
			flag <= '0';
		elsif RISING_EDGE(Clock) then
			fokSignal <= '0';
			case state is
				when DELAY =>
					state <= START;
				when START =>
					if (clk = '1') then
						if data = '0' then
							state <= S0;
						else
							state <= DELAY;
						end if;
					end if;
				when S0 =>
					if (clk = '1') then
						code(0) <= data;
						state <= S1;
					end if;
				when S1 =>
					if (clk = '1') then
						code(1) <= data;
						state <= S2;
					end if;
				when S2 =>
					if (clk = '1') then
						code(2) <= data;
						state <= S3;
					end if ;
				when S3 =>
					if (clk = '1') then
						code(3) <= data;
						state <= S4;
					end if;
				when S4 =>
					if (clk = '1') then
						code(4) <= data;
						state <= S5;
					end if;
				when S5 =>
					if (clk = '1') then
						code(5) <= data;
						state <= S6;
					end if;
				when S6 =>
					if (clk = '1') then
						code(6) <= data;
						state <= S7;
					end if;
				when S7 =>
					if (clk = '1') then
						code(7) <= data;
						state <= PARITY;
					end if;
				when PARITY =>
					if (clk = '1') then
						if (data xor odd) = '1' then
							state <= STOP;
						else
							state <= DELAY;
						end if;
					end if;
				when STOP =>
					if (clk = '1') then
						if (data = '1') then
							state <= FINISH;
						else
							state <= DELAY;
						end if;
					end if;
				when FINISH =>
					state <= DELAY;
					fokSignal <= '1';
				when others =>
					state <= DELAY;
			end case;

			if (OutputCode = "11110000") then
				flag <= '1';
			elsif (flag = '1') then
				DataReady <= '1';
				Output <= OutputCode;
				flag <= '0';
			end if;
			if DataReceive = '0' then
				DataReady <= '0';
			end if;
		end if;
	end process;
end Behavioral;

