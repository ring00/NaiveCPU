----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    23:12:11 11/22/2017
-- Design Name:
-- Module Name:    CPU - Behavioral
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

entity CPU is
	Port (Clock : in STD_LOGIC;
			Reset : in STD_LOGIC;

			InstAddress : out STD_LOGIC_VECTOR(15 downto 0);
			InstData : in STD_LOGIC_VECTOR(15 downto 0);

			DataAddress : out STD_LOGIC_VECTOR(15 downto 0);
			DataInput : in STD_LOGIC_VECTOR(15 downto 0);
			DataOutput : out STD_LOGIC_VECTOR(15 downto 0);

			MemReadEN : out STD_LOGIC;
			MemWriteEN : out STD_LOGIC);
end CPU;

architecture Behavioral of CPU is

-- IF BEGIN --

	component PC is
		Port (Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;
				Clear : in STD_LOGIC;
				WriteEN : in STD_LOGIC;
				PCInput : in STD_LOGIC_VECTOR(15 downto 0);
				PCOutput : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	component StallUnit is
		Port (DataHazard : in STD_LOGIC;
				Misprediction : in STD_LOGIC;
				PCWriteEN : out STD_LOGIC;
				IFIDWriteEN : out STD_LOGIC;
				IDEXWriteEN : out STD_LOGIC;
				EXMEMWriteEN : out STD_LOGIC;
				MEMWBWriteEN : out STD_LOGIC;
				PCClear : out STD_LOGIC;
				IFIDClear : out STD_LOGIC;
				IDEXClear : out STD_LOGIC;
				EXMEMClear : out STD_LOGIC;
				MEMWBClear : out STD_LOGIC);
	end component;

-- IF END --

	component IFID is
		Port (Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;
				Clear : in STD_LOGIC;
				WriteEN : in STD_LOGIC;

				InstructionInput : in STD_LOGIC_VECTOR(15 downto 0);
				PCInput : in STD_LOGIC_VECTOR(15 downto 0);

				InstructionOutput : out STD_LOGIC_VECTOR(15 downto 0);
				PCOutput : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

-- ID BEGIN --

	component Controller is
		Port (Instruction : in STD_LOGIC_VECTOR(15 downto 0);

				RegWrite : out STD_LOGIC;
				MemRead : out STD_LOGIC;
				MemWrite : out STD_LOGIC;
				BranchType : out STD_LOGIC_VECTOR(2 downto 0);
				RegSrcA : out STD_LOGIC_VECTOR(3 downto 0);
				RegSrcB : out STD_LOGIC_VECTOR(3 downto 0);
				RegDest : out STD_LOGIC_VECTOR(3 downto 0);
				UseImm : out STD_LOGIC);
	end component;

	component Extender is
		Port (Instruction : in STD_LOGIC_VECTOR(15 downto 0);
				Extended : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	component ALUController is
		Port (Instruction : in STD_LOGIC_VECTOR(15 downto 0);
				ALUop : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component RegisterFile is
		Port (Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;
				Clear : in STD_LOGIC;
				WriteEN : in STD_LOGIC;
				ReadRegA : in STD_LOGIC_VECTOR(3 downto 0);
				ReadRegB : in STD_LOGIC_VECTOR(3 downto 0);
				WriteReg : in STD_LOGIC_VECTOR(3 downto 0);
				WriteData : in STD_LOGIC_VECTOR(15 downto 0);
				PCInput : in STD_LOGIC_VECTOR(15 downto 0);
				ReadDataA : out STD_LOGIC_VECTOR(15 downto 0);
				ReadDataB : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	component HazardUnit is
		Port (IDEXMemRead : in STD_LOGIC;
				IDEXRegDest : in STD_LOGIC_VECTOR(3 downto 0);
				RegSrcA : in STD_LOGIC_VECTOR(3 downto 0);
				RegSrcB : in STD_LOGIC_VECTOR(3 downto 0);
				DataHazard : out STD_LOGIC);
	end component;

-- ID END --

	component IDEX is
		Port (Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;
				Clear : in STD_LOGIC;
				WriteEN : in STD_LOGIC;

				PCInput : in STD_LOGIC_VECTOR(15 downto 0);
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
	end component;

-- EX BEGIN --

	component BranchSelector is
		Port (BranchType : in STD_LOGIC_VECTOR(2 downto 0);
				BranchInput : in STD_LOGIC_VECTOR(15 downto 0);
				RegisterInput : in STD_LOGIC_VECTOR(15 downto 0);
				Branch : out STD_LOGIC;
				Address : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	component ALU is
		Port (ALUop : in STD_LOGIC_VECTOR(3 downto 0);
				InputA : in STD_LOGIC_VECTOR(15 downto 0);
				InputB : in STD_LOGIC_VECTOR(15 downto 0);
				Output : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	component ForwardUnit is
		Port (EXMEMRegWrite : in STD_LOGIC;
				MEMWBRegWrite : in STD_LOGIC;
				EXMEMRegDest : in STD_LOGIC_VECTOR(3 downto 0);
				MEMWBRegDest : in STD_LOGIC_VECTOR(3 downto 0);
				IDEXRegSrcA : in STD_LOGIC_VECTOR(3 downto 0);
				IDEXRegSrcB : in STD_LOGIC_VECTOR(3 downto 0);
				ForwardA : out STD_LOGIC_VECTOR(1 downto 0);
				ForwardB : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

-- EX END --

-- MEM BEGIN --

	component EXMEM is
		Port (Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;
				Clear : in STD_LOGIC;
				WriteEN : in STD_LOGIC;
				RegWriteInput : in STD_LOGIC;
				MemReadInput : in STD_LOGIC;
				MemWriteInput : in STD_LOGIC;
				RegDestInput : in STD_LOGIC_VECTOR(3 downto 0);
				EXResultInput : in STD_LOGIC_VECTOR(15 downto 0);
				RegDataBInput : in STD_LOGIC_VECTOR(15 downto 0);
				RegWriteOutput : out STD_LOGIC;
				MemReadOutput : out STD_LOGIC;
				MemWriteOutput : out STD_LOGIC;
				RegDestOutput : out STD_LOGIC_VECTOR(3 downto 0);
				EXResultOutput : out STD_LOGIC_VECTOR(15 downto 0);
				RegDataBOutput : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

-- MEM END --

	component MEMWB is
		Port (Clock : in STD_LOGIC;
				Reset : in STD_LOGIC;
				Clear : in STD_LOGIC;
				WriteEN : in STD_LOGIC;

				RegWriteInput : in STD_LOGIC;
				MemReadInput : in STD_LOGIC;
				RegDestInput : in STD_LOGIC_VECTOR(3 downto 0);
				EXResultInput : in STD_LOGIC_VECTOR(15 downto 0);
				MemDataBInput : in STD_LOGIC_VECTOR(15 downto 0);

				RegWriteOutput : out STD_LOGIC;
				MemReadOutput : out STD_LOGIC;
				RegDestOutput : out STD_LOGIC_VECTOR(3 downto 0);
				EXResultOutput : out STD_LOGIC_VECTOR(15 downto 0);
				MemDataBOutput : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

-- WB BEGIN --

-- WB END --

-- MISC BEGIN --

	component Adder is
		Port (InputA : in  STD_LOGIC_VECTOR(15 downto 0);
				InputB : in  STD_LOGIC_VECTOR(15 downto 0);
				Output : out  STD_LOGIC_VECTOR(15 downto 0));
	end component;

	component Mux is
		Port (Sel : in STD_LOGIC;
				InputA : in STD_LOGIC_VECTOR(15 downto 0);
				InputB : in STD_LOGIC_VECTOR(15 downto 0);
				Output : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	component Mux3 is
		Port (Sel : in STD_LOGIC_VECTOR(1 downto 0);
				InputA : in STD_LOGIC_VECTOR(15 downto 0);
				InputB : in STD_LOGIC_VECTOR(15 downto 0);
				InputC : in STD_LOGIC_VECTOR(15 downto 0);
				Output : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

-- MISC END --

begin

end Behavioral;
