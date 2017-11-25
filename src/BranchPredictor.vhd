----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    13:53:20 11/25/2017
-- Design Name:
-- Module Name:    BranchPredictor - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BranchPredictor is
	Port (Clock : in  STD_LOGIC;
			Reset : in  STD_LOGIC;
			Clear : in STD_LOGIC;
			WriteEN : in STD_LOGIC;
			BranchType : in STD_LOGIC_VECTOR(2 downto 0);
			PCInput : in STD_LOGIC_VECTOR(15 downto 0);
			Offset : in STD_LOGIC_VECTOR(15 downto 0);
			ActualBranch : in STD_LOGIC;
			ActualAddress : in STD_LOGIC_VECTOR(15 downto 0);
			Branch : out STD_LOGIC;
			TargetAddress : out STD_LOGIC_VECTOR(15 downto 0);
			Misprediction : out STD_LOGIC);
end BranchPredictor;

architecture Behavioral of BranchPredictor is

	component Adder is
		Port (InputA : in  STD_LOGIC_VECTOR(15 downto 0);
				InputB : in  STD_LOGIC_VECTOR(15 downto 0);
				Output : out  STD_LOGIC_VECTOR(15 downto 0));
	end component;

	type StateType is (PREDICT, AMEND);
	signal state : StateType;

	type SaturatingCounter is (StronglyNotTaken, WeaklyNotTaken, WeaklyTaken, StronglyTaken);
	type BufferArray is array(0 to 255) of SaturatingCounter;
	signal HisotryBuffer : BufferArray;

	signal Index : STD_LOGIC_VECTOR(7 downto 0);

	signal Prediction : STD_LOGIC;
	signal Counter : SaturatingCounter;

	signal CurrentIndex : integer range 0 to 255;
	signal CurrentPrediction : STD_LOGIC;
	signal CurrentCounter : SaturatingCounter;

	signal PredictedAddress : STD_LOGIC_VECTOR(15 downto 0);

begin

	AdderInstance : Adder port map (
		InputA => PCInput,
		InputB => Offset,
		Output => PredictedAddress
	);

	with state select TargetAddress <=
		PredictedAddress when PREDICT,
		ActualAddress when AMEND,
		(others => '0') when others;

	Counter <= HisotryBuffer(TO_INTEGER(UNSIGNED(PCInput(7 downto 0))));

	with Counter select Prediction <=
		'0' when StronglyNotTaken,
		'0' when WeaklyNotTaken,
		'1' when WeaklyTaken,
		'1' when StronglyTaken,
		'1' when others;

	Branch <= CurrentPrediction;

	Update : process(Clock, Reset)
	begin
		if (Reset = '1') then
			state <= PREDICT;
			HisotryBuffer <= (others => WeaklyTaken);
			CurrentPrediction <= '0';
			Misprediction <= '0';
			Index <= (others => '0');
			CurrentCounter <= WeaklyTaken;
		elsif FALLING_EDGE(Clock) then -- TODO: Should I use FALLING_EDGE here just like RegisterFile?
			if (Clear = '1') then
				state <= PREDICT;
				HisotryBuffer <= (others => WeaklyTaken);
				CurrentPrediction <= '0';
				Misprediction <= '0';
				Index <= (others => '0');
				CurrentCounter <= WeaklyTaken;
			elsif (WriteEN = '1') then
				case (state) is
					when PREDICT =>
						Index <= PCInput(7 downto 0);
						CurrentCounter <= Counter;
						if (BranchType = "000") then
							state <= PREDICT;
						else
							state <= AMEND;
						end if;
						case (BranchType) is
							when "001" => CurrentPrediction <= '1'; -- B
							when "010" => CurrentPrediction <= '0'; -- JR, DON'T JUMP!
							when "011" => CurrentPrediction <= Prediction; -- BEQZ, BTEQZ
							when "100" => CurrentPrediction <= Prediction; -- BNEZ, BTNEZ
							when others => CurrentPrediction <= '0'; -- Normal Instructions
						end case;
					when AMEND =>
						state <= PREDICT;
						if (CurrentPrediction = ActualBranch) then
							CurrentPrediction <= '0';
							Misprediction <= '0';
						else
							CurrentPrediction <= '1';
							Misprediction <= '1';
						end if;
						case (CurrentCounter) is
							when StronglyNotTaken =>
								if ActualBranch = '1' then
									HisotryBuffer(TO_INTEGER(UNSIGNED(Index))) <= WeaklyNotTaken;
								else
									HisotryBuffer(TO_INTEGER(UNSIGNED(Index))) <= StronglyNotTaken;
								end if;
							when WeaklyNotTaken =>
								if ActualBranch = '1' then
									HisotryBuffer(TO_INTEGER(UNSIGNED(Index))) <= WeaklyTaken;
								else
									HisotryBuffer(TO_INTEGER(UNSIGNED(Index))) <= StronglyNotTaken;
								end if;
							when WeaklyTaken =>
								if ActualBranch = '1' then
									HisotryBuffer(TO_INTEGER(UNSIGNED(Index))) <= StronglyTaken;
								else
									HisotryBuffer(TO_INTEGER(UNSIGNED(Index))) <= WeaklyNotTaken;
								end if;
							when StronglyTaken =>
								if ActualBranch = '1' then
									HisotryBuffer(TO_INTEGER(UNSIGNED(Index))) <= StronglyTaken;
								else
									HisotryBuffer(TO_INTEGER(UNSIGNED(Index))) <= WeaklyTaken;
								end if;
							when others =>
						end case;
					when others =>
						state <= PREDICT;
				end case;
			end if;
		end if;
	end process Update; -- Update

end Behavioral;
