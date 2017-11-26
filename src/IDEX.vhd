----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    13:00:43 11/22/2017
-- Design Name:
-- Module Name:    IDEX - Behavioral
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

entity IDEX is
	Port (Clock : in STD_LOGIC;
			Reset : in STD_LOGIC;
			Clear : in STD_LOGIC;
			WriteEN : in STD_LOGIC;

			PCInput : in STD_LOGIC_VECTOR(15 downto 0);
			BranchInput : in STD_LOGIC_VECTOR(15 downto 0);
			RegWriteInput : in STD_LOGIC;
			MemReadInput : in STD_LOGIC;
			MemWriteInput : in STD_LOGIC;
			BranchTypeInput : in STD_LOGIC_VECTOR(2 downto 0);
			RegSrcAInput : in STD_LOGIC_VECTOR(3 downto 0);
			RegSrcBInput : in STD_LOGIC_VECTOR(3 downto 0);
			RegDestInput : in STD_LOGIC_VECTOR(3 downto 0);
			UseImmInput : in STD_LOGIC;
			ExtendedInput : in STD_LOGIC_VECTOR(15 downto 0);
			ALUopInput : in STD_LOGIC_VECTOR(3 downto 0);
			RegDataAInput : in STD_LOGIC_VECTOR(15 downto 0);
			RegDataBInput : in STD_LOGIC_VECTOR(15 downto 0);

			PCOutput : out STD_LOGIC_VECTOR(15 downto 0);
			BranchOutput : out STD_LOGIC_VECTOR(15 downto 0);
			RegWriteOutput : out STD_LOGIC;
			MemReadOutput : out STD_LOGIC;
			MemWriteOutput : out STD_LOGIC;
			BranchTypeOutput : out STD_LOGIC_VECTOR(2 downto 0);
			RegSrcAOutput : out STD_LOGIC_VECTOR(3 downto 0);
			RegSrcBOutput : out STD_LOGIC_VECTOR(3 downto 0);
			RegDestOutput : out STD_LOGIC_VECTOR(3 downto 0);
			UseImmOutput : out STD_LOGIC;
			ExtendedOutput : out STD_LOGIC_VECTOR(15 downto 0);
			ALUopOutput : out STD_LOGIC_VECTOR(3 downto 0);
			RegDataAOutput : out STD_LOGIC_VECTOR(15 downto 0);
			RegDataBOutput : out STD_LOGIC_VECTOR(15 downto 0));
end IDEX;

architecture Behavioral of IDEX is

	signal PC : STD_LOGIC_VECTOR(15 downto 0);
	signal Branch : STD_LOGIC_VECTOR(15 downto 0);
	signal RegWrite : STD_LOGIC;
	signal MemRead : STD_LOGIC;
	signal MemWrite : STD_LOGIC;
	signal BranchType : STD_LOGIC_VECTOR(2 downto 0);
	signal RegSrcA : STD_LOGIC_VECTOR(3 downto 0);
	signal RegSrcB : STD_LOGIC_VECTOR(3 downto 0);
	signal RegDest : STD_LOGIC_VECTOR(3 downto 0);
	signal UseImm : STD_LOGIC;
	signal Extended : STD_LOGIC_VECTOR(15 downto 0);
	signal ALUop : STD_LOGIC_VECTOR(3 downto 0);
	signal RegDataA : STD_LOGIC_VECTOR(15 downto 0);
	signal RegDataB : STD_LOGIC_VECTOR(15 downto 0);

begin

	PCOutput <= PC;
	BranchOutput <= Branch;
	RegWriteOutput <= RegWrite;
	MemReadOutput <= MemRead;
	MemWriteOutput <= MemWrite;
	BranchTypeOutput <= BranchType;
	RegSrcAOutput <= RegSrcA;
	RegSrcBOutput <= RegSrcB;
	RegDestOutput <= RegDest;
	UseImmOutput <= UseImm;
	ExtendedOutput <= Extended;
	ALUopOutput <= ALUop;
	RegDataAOutput <= RegDataA;
	RegDataBOutput <= RegDataB;

	Update : process (Reset, Clock)
	begin
		if (Reset = '1') then
			PC <= (others => '0');
			Branch <= (others => '0');
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			BranchType <= (others => '0');
			RegSrcA <= (others => '0');
			RegSrcB <= (others => '0');
			RegDest <= (others => '0');
			UseImm <= '0';
			Extended <= (others => '0');
			ALUop <= (others => '0');
			RegDataA <= (others => '0');
			RegDataB <= (others => '0');
		elsif (RISING_EDGE(Clock)) then
			if (Clear = '1') then
				PC <= (others => '0');
				Branch <= (others => '0');
				RegWrite <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				BranchType <= (others => '0');
				RegSrcA <= (others => '0');
				RegSrcB <= (others => '0');
				RegDest <= (others => '0');
				UseImm <= '0';
				Extended <= (others => '0');
				ALUop <= (others => '0');
				RegDataA <= (others => '0');
				RegDataB <= (others => '0');
			elsif (WriteEN = '1') then
				PC <= PCInput;
				Branch <= BranchInput;
				RegWrite <= RegWriteInput;
				MemRead <= MemReadInput;
				MemWrite <= MemWriteInput;
				BranchType <= BranchTypeInput;
				RegSrcA <= RegSrcAInput;
				RegSrcB <= RegSrcBInput;
				RegDest <= RegDestInput;
				UseImm <= UseImmInput;
				Extended <= ExtendedInput;
				ALUop <= ALUopInput;
				RegDataA <= RegDataAInput;
				RegDataB <= RegDataBInput;
			end if;
		end if;
	end process Update;

end Behavioral;
