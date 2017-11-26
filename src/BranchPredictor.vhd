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
--use IEEE.NUMERIC_STD.ALL;

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
			BranchTaken : in STD_LOGIC;
			BranchSelect : out STD_LOGIC_VECTOR(1 downto 0);
			Misprediction : out STD_LOGIC);
end BranchPredictor;

architecture Behavioral of BranchPredictor is

	component RAM is
		port (
			a : in STD_LOGIC_VECTOR(7 downto 0);
			d : in STD_LOGIC_VECTOR(1 downto 0);
			clk : in STD_LOGIC;
			we : in STD_LOGIC;
			spo : out STD_LOGIC_VECTOR(1 downto 0)
		);
	end component;

	constant StronglyTaken : STD_LOGIC_VECTOR(1 downto 0) := "01";
	constant WeaklyTaken : STD_LOGIC_VECTOR(1 downto 0) := "00";
	constant WeaklyNotTaken : STD_LOGIC_VECTOR(1 downto 0) := "10";
	constant StronglyNotTaken : STD_LOGIC_VECTOR(1 downto 0) := "11";

	signal BufferAddress : STD_LOGIC_VECTOR(7 downto 0);
	signal BufferData : STD_LOGIC_VECTOR(1 downto 0);
	signal BufferWE : STD_LOGIC;
	signal BufferState : STD_LOGIC_VECTOR(1 downto 0);

	signal Prediction : STD_LOGIC;
	signal LastPrediction : STD_LOGIC;
	signal LastPC : STD_LOGIC_VECTOR(15 downto 0);

	type STATE_TYPE is (FORCAST, AMEND);
	signal State : STATE_TYPE;

begin

	BufferAddress <= PCInput(7 downto 0) when State = FORCAST else
						  LastPC(7 downto 0) when State = AMEND else
						  (others => '0');

	BufferData <= StronglyTaken when (State = AMEND and BufferState = StronglyTaken and BranchTaken = '1') else
					  WeaklyTaken when (State = AMEND and BufferState = StronglyTaken and BranchTaken = '0') else
					  StronglyTaken when (State = AMEND and BufferState = WeaklyTaken and BranchTaken = '1') else
					  WeaklyNotTaken when (State = AMEND and BufferState = WeaklyTaken and BranchTaken = '0') else
					  WeaklyTaken when (State = AMEND and BufferState = WeaklyNotTaken and BranchTaken = '1') else
					  StronglyNotTaken when (State = AMEND and BufferState = WeaklyNotTaken and BranchTaken = '0') else
					  WeaklyNotTaken when (State = AMEND and BufferState = StronglyNotTaken and BranchTaken = '1') else
					  StronglyNotTaken when (State = AMEND and BufferState = StronglyNotTaken and BranchTaken = '0') else
					  WeaklyTaken;

	BufferWE <= '1' when (State = AMEND and BufferState = StronglyTaken and BranchTaken = '0')
							or (State = AMEND and BufferState = WeaklyTaken and BranchTaken = '1')
							or (State = AMEND and BufferState = WeaklyTaken and BranchTaken = '0')
							or (State = AMEND and BufferState = WeaklyNotTaken and BranchTaken = '1')
							or (State = AMEND and BufferState = WeaklyNotTaken and BranchTaken = '0')
							or (State = AMEND and BufferState = StronglyNotTaken and BranchTaken = '1') else
					'0';

	BranchHistoryBuffer : RAM port map (
		a => BufferAddress,
		d => BufferData,
		clk => Clock,
		we => BufferWE,
		spo => BufferState
	);

	Prediction <= '1' when (State = FORCAST and BranchType = "001") -- B
							  or (State = FORCAST and (BranchType = "011" or BranchType = "100") and (BufferState = WeaklyTaken or BufferState = StronglyTaken)) else -- BEQZ, BTEQZ, BNEZ, BTNEZ
					  '0';

	BranchSelect <= "00" when (State = FORCAST and Prediction = '0')
								  or (State = AMEND and LastPrediction = BranchTaken) else
						 "01" when (State = FORCAST and Prediction = '1') else
						 "10" when (State = AMEND and LastPrediction /= BranchTaken) else
						 "00";

	Misprediction <= '1' when (State = AMEND and LastPrediction /= BranchTaken) else
						  '0';

	Update : process(Clock, Reset)
	begin
		if (Reset = '1') then
			State <= FORCAST;
			LastPrediction <= '0';
			LastPC <= (others => '0');
		elsif RISING_EDGE(Clock) then
			if (Clear = '1') then
				State <= FORCAST;
				LastPrediction <= '0';
				LastPC <= (others => '0');
			elsif (WriteEN = '1') then
				case(State) is
					when FORCAST =>
						case(BranchType) is
							when "000" => State <= FORCAST;
							when others => State <= AMEND;
						end case ;
						LastPrediction <= Prediction;
						LastPC <= PCInput;
					when AMEND =>
						State <= FORCAST;
					when others =>
						State <= FORCAST;
				end case ;
			end if;
		end if;
	end process; -- Update

end Behavioral;
