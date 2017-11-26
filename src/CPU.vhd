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

	signal IFPC : STD_LOGIC_VECTOR(15 downto 0);

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

	signal PCWriteEN : STD_LOGIC;
	signal IFIDWriteEN : STD_LOGIC;
	signal IDEXWriteEN : STD_LOGIC;
	signal EXMEMWriteEN : STD_LOGIC;
	signal MEMWBWriteEN : STD_LOGIC;
	signal PCClear : STD_LOGIC;
	signal IFIDClear : STD_LOGIC;
	signal IDEXClear : STD_LOGIC;
	signal EXMEMClear : STD_LOGIC;
	signal MEMWBClear : STD_LOGIC;

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

	signal IFIDInstruction : STD_LOGIC_VECTOR(15 downto 0);
	signal IFIDPC : STD_LOGIC_VECTOR(15 downto 0);

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

	signal IDRegWrite : STD_LOGIC;
	signal IDMemRead : STD_LOGIC;
	signal IDMemWrite : STD_LOGIC;
	signal IDBranchType : STD_LOGIC_VECTOR(2 downto 0);
	signal IDRegSrcA : STD_LOGIC_VECTOR(3 downto 0);
	signal IDRegSrcB : STD_LOGIC_VECTOR(3 downto 0);
	signal IDRegDest : STD_LOGIC_VECTOR(3 downto 0);
	signal IDUseImm : STD_LOGIC;

	component Extender is
		Port (Instruction : in STD_LOGIC_VECTOR(15 downto 0);
				Extended : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	signal IDExtended : STD_LOGIC_VECTOR(15 downto 0);

	component ALUController is
		Port (Instruction : in STD_LOGIC_VECTOR(15 downto 0);
				ALUop : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	signal IDALUop : STD_LOGIC_VECTOR(3 downto 0);

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
				RegDataA : out STD_LOGIC_VECTOR(15 downto 0);
				RegDataB : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	signal IDRegDataA : STD_LOGIC_VECTOR(15 downto 0);
	signal IDRegDataB : STD_LOGIC_VECTOR(15 downto 0);

	component HazardUnit is
		Port (IDEXMemRead : in STD_LOGIC;
				IDEXRegDest : in STD_LOGIC_VECTOR(3 downto 0);
				RegSrcA : in STD_LOGIC_VECTOR(3 downto 0);
				RegSrcB : in STD_LOGIC_VECTOR(3 downto 0);
				DataHazard : out STD_LOGIC);
	end component;

	signal IDDataHazard : STD_LOGIC;

	component BranchPredictor is
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
	end component;

	signal IDBranch : STD_LOGIC;
	signal IDTargetAddress : STD_LOGIC_VECTOR(15 downto 0);
	signal IDMisprediction : STD_LOGIC;

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

	signal IDEXPC : STD_LOGIC_VECTOR(15 downto 0);
	signal IDEXRegWrite : STD_LOGIC;
	signal IDEXMemRead : STD_LOGIC;
	signal IDEXMemWrite : STD_LOGIC;
	signal IDEXBranchType : STD_LOGIC_VECTOR(2 downto 0);
	signal IDEXRegSrcA : STD_LOGIC_VECTOR(3 downto 0);
	signal IDEXRegSrcB : STD_LOGIC_VECTOR(3 downto 0);
	signal IDEXRegDest : STD_LOGIC_VECTOR(3 downto 0);
	signal IDEXUseImm : STD_LOGIC;
	signal IDEXExtended : STD_LOGIC_VECTOR(15 downto 0);
	signal IDEXALUop : STD_LOGIC_VECTOR(3 downto 0);
	signal IDEXRegDataA : STD_LOGIC_VECTOR(15 downto 0);
	signal IDEXRegDataB : STD_LOGIC_VECTOR(15 downto 0);

-- EX BEGIN --

	component BranchSelector is
		Port (BranchType : in STD_LOGIC_VECTOR(2 downto 0);
				BranchInput : in STD_LOGIC_VECTOR(15 downto 0);
				RegisterInput : in STD_LOGIC_VECTOR(15 downto 0);
				Branch : out STD_LOGIC;
				Address : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	signal EXBranch : STD_LOGIC;
	signal EXAddress : STD_LOGIC_VECTOR(15 downto 0);

	component ALU is
		Port (ALUop : in STD_LOGIC_VECTOR(3 downto 0);
				InputA : in STD_LOGIC_VECTOR(15 downto 0);
				InputB : in STD_LOGIC_VECTOR(15 downto 0);
				Output : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	signal ALUOutput : STD_LOGIC_VECTOR(15 downto 0);

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

	signal EXForwardA : STD_LOGIC_VECTOR(1 downto 0);
	signal EXForwardB : STD_LOGIC_VECTOR(1 downto 0);

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

	signal EXMEMRegWrite : STD_LOGIC;
	signal EXMEMMemRead : STD_LOGIC;
	signal EXMEMMemWrite : STD_LOGIC;
	signal EXMEMRegDest : STD_LOGIC_VECTOR(3 downto 0);
	signal EXMEMEXResult : STD_LOGIC_VECTOR(15 downto 0);
	signal EXMEMRegDataB : STD_LOGIC_VECTOR(15 downto 0);

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

	signal MEMWBRegWrite : STD_LOGIC;
	signal MEMWBMemRead : STD_LOGIC;
	signal MEMWBRegDest : STD_LOGIC_VECTOR(3 downto 0);
	signal MEMWBEXResult : STD_LOGIC_VECTOR(15 downto 0);
	signal MEMWBMemDataB : STD_LOGIC_VECTOR(15 downto 0);

-- WB BEGIN --

-- WB END --

-- MISC BEGIN --

	component Adder is
		Port (InputA : in  STD_LOGIC_VECTOR(15 downto 0);
				InputB : in  STD_LOGIC_VECTOR(15 downto 0);
				Output : out  STD_LOGIC_VECTOR(15 downto 0));
	end component;

	signal IFAdderOutput : STD_LOGIC_VECTOR(15 downto 0);
	signal EXAdderOutput : STD_LOGIC_VECTOR(15 downto 0);

	component Mux is
		Port (Sel : in STD_LOGIC;
				InputA : in STD_LOGIC_VECTOR(15 downto 0);
				InputB : in STD_LOGIC_VECTOR(15 downto 0);
				Output : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	signal IFMuxOutput : STD_LOGIC_VECTOR(15 downto 0);
	signal EXMuxOutput : STD_LOGIC_VECTOR(15 downto 0);
	signal WBMuxOutput : STD_LOGIC_VECTOR(15 downto 0);

	component Mux3 is
		Port (Sel : in STD_LOGIC_VECTOR(1 downto 0);
				InputA : in STD_LOGIC_VECTOR(15 downto 0);
				InputB : in STD_LOGIC_VECTOR(15 downto 0);
				InputC : in STD_LOGIC_VECTOR(15 downto 0);
				Output : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	signal EXMux3AOutput : STD_LOGIC_VECTOR(15 downto 0);
	signal EXMux3BOutput : STD_LOGIC_VECTOR(15 downto 0);

-- MISC END --

begin

-- IF BEGIN
	PCInstance : PC port map (
		Clock => Clock,
		Reset => Reset,
		Clear => PCClear,
		WriteEN => PCWriteEN,
		PCInput => IFMuxOutput,
		PCOutput => IFPC
	);

	InstAddress <= IFPC;

	IFAdderInstance : Adder port map (
		InputA => IFPC,
		InputB => x"0001",
		Output => IFAdderOutput
	);

	IFMuxInstance : Mux port map (
		Sel => IDMisprediction,
		InputA => IFAdderOutput,
		InputB => IDTargetAddress,
		Output => IFMuxOutput
	);

	StallUnitInstance : StallUnit port map (
		DataHazard => IDDataHazard,
		Misprediction => IDMisprediction,
		PCWriteEN => PCWriteEN,
		IFIDWriteEN => IFIDWriteEN,
		IDEXWriteEN => IDEXWriteEN,
		EXMEMWriteEN => EXMEMWriteEN,
		MEMWBWriteEN => MEMWBWriteEN,
		PCClear => PCClear,
		IFIDClear => IFIDClear,
		IDEXClear => IDEXClear,
		EXMEMClear => EXMEMClear,
		MEMWBClear => MEMWBClear
	);

-- IF END

	IFIDInstance : IFID port map (
		Clock => Clock,
		Reset => Reset,
		Clear => IFIDClear,
		WriteEN => IFIDWriteEN,
		InstructionInput => InstData,
		PCInput => IFAdderOutput,
		InstructionOutput => IFIDInstruction,
		PCOutput => IFIDPC
	);

-- ID BEGIN

	ControllerInstance : Controller port map (
		Instruction => IFIDInstruction,
		RegWrite => IDRegWrite,
		MemRead => IDMemRead,
		MemWrite => IDMemWrite,
		BranchType => IDBranchType,
		RegSrcA => IDRegSrcA,
		RegSrcB => IDRegSrcB,
		RegDest => IDRegDest,
		UseImm => IDUseImm
	);

	ExtenderInstance : Extender port map (
		Instruction => IFIDInstruction,
		Extended => IDExtended
	);

	ALUControllerInstance : ALUController port map (
		Instruction => IFIDInstruction,
		ALUop => IDALUop
	);

	RegisterFileInstance : RegisterFile port map (
		Clock => Clock,
		Reset => Reset,
		Clear => '0',
		WriteEN => MEMWBRegWrite,
		ReadRegA => IDRegSrcA,
		ReadRegB => IDRegSrcB,
		WriteReg => MEMWBRegDest,
		WriteData => WBMuxOutput,
		PCInput => IFIDPC,
		RegDataA => IDRegDataA,
		RegDataB => IDRegDataB
	);

	HazardUnitInstance : HazardUnit port map (
		IDEXMemRead => IDEXMemRead,
		IDEXRegDest => IDEXRegDest,
		RegSrcA => IDRegSrcA,
		RegSrcB => IDRegSrcB,
		DataHazard => IDDataHazard
	);

	BranchPredictorInstance : BranchPredictor port map (
		Clock => Clock,
		Reset => Reset,
		Clear => '0',
		WriteEN => IFIDWriteEN,
		BranchType => IDBranchType,
		PCInput => IFIDPC,
		Offset => IDExtended,
		ActualBranch => EXBranch,
		ActualAddress => EXAddress,
		Branch => IDBranch,
		TargetAddress => IDTargetAddress,
		Misprediction => IDMisprediction
	);

-- ID END

	IDEXInstance : IDEX port map (
		Clock => Clock,
		Reset => Reset,
		Clear => IDEXClear,
		WriteEN => IDEXWriteEN,
		PCInput => IFIDPC,
		RegWriteInput => IDRegWrite,
		MemReadInput => IDMemRead,
		MemWriteInput => IDMemWrite,
		BranchTypeInput => IDBranchType,
		RegSrcAInput => IDRegSrcA,
		RegSrcBInput => IDRegSrcB,
		RegDestInput => IDRegDest,
		UseImmInput => IDUseImm,
		ExtendedInput => IDExtended,
		ALUopInput => IDALUop,
		RegDataAInput => IDRegDataA,
		RegDataBInput => IDRegDataB,
		PCOutput => IDEXPC,
		RegWriteOutput => IDEXRegWrite,
		MemReadOutput => IDEXMemRead,
		MemWriteOutput => IDEXMemWrite,
		BranchTypeOutput => IDEXBranchType,
		RegSrcAOutput => IDEXRegSrcA,
		RegSrcBOutput => IDEXRegSrcB,
		RegDestOutput => IDEXRegDest,
		UseImmOutput => IDEXUseImm,
		ExtendedOutput => IDEXExtended,
		ALUopOutput => IDEXALUop,
		RegDataAOutput => IDEXRegDataA,
		RegDataBOutput => IDEXRegDataB
	);

-- EX BEGIN

	EXMux3AInstance : Mux3 port map (
		Sel => EXForwardA,
		InputA => IDEXRegDataA,
		InputB => EXMEMEXResult,
		InputC => WBMuxOutput,
		Output => EXMux3AOutput
	);

	EXMux3BInstance : Mux3 port map (
		Sel => EXForwardB,
		InputA => IDEXRegDataB,
		InputB => EXMEMEXResult,
		InputC => WBMuxOutput,
		Output => EXMux3BOutput
	);

	ExMuxImmInstance : Mux port map (
		Sel => IDEXUseImm,
		InputA => EXMux3BOutput,
		InputB => IDEXExtended,
		Output => EXMuxOutput
	);

	ALUInstance : ALU port map (
		ALUop => IDEXALUop,
		InputA => EXMux3AOutput,
		InputB => EXMuxOutput,
		Output => ALUOutput
	);

	EXAdderInstance : Adder port map (
		InputA => IDEXPC,
		InputB => IDEXExtended,
		Output => EXAdderOutput
	);

	BranchSelectorInstance : BranchSelector port map (
		BranchType => IDEXBranchType,
		BranchInput => EXAdderOutput,
		RegisterInput => EXMux3AOutput,
		Branch => EXBranch,
		Address => EXAddress
	);

	ForwardUnitInstance : ForwardUnit port map (
		EXMEMRegWrite => EXMEMRegWrite,
		MEMWBRegWrite => MEMWBRegWrite,
		EXMEMRegDest => EXMEMRegDest,
		MEMWBRegDest => MEMWBRegDest,
		IDEXRegSrcA => IDEXRegSrcA,
		IDEXRegSrcB => IDEXRegSrcB,
		ForwardA => EXForwardA,
		ForwardB => EXForwardB
	);

-- EX END

	EXMEMInstance : EXMEM port map (
		Clock => Clock,
		Reset => Reset,
		Clear => EXMEMClear,
		WriteEN => EXMEMWriteEN,
		RegWriteInput => IDEXRegWrite,
		MemReadInput => IDEXMemRead,
		MemWriteInput => IDEXMemWrite,
		RegDestInput => IDEXRegDest,
		EXResultInput => ALUOutput,
		RegDataBInput => EXMux3BOutput,
		RegWriteOutput => EXMEMRegWrite,
		MemReadOutput => EXMEMMemRead,
		MemWriteOutput => EXMEMMemWrite,
		RegDestOutput => EXMEMRegDest,
		EXResultOutput => EXMEMEXResult,
		RegDataBOutput => EXMEMRegDataB
	);

-- MEM BEGIN

	DataOutput <= EXMEMRegDataB;
	DataAddress <= EXMEMEXResult;
	MemReadEN <= EXMEMMemRead;
	MemWriteEN <= EXMEMMemWrite;

-- MEM END

	MEMWBInstance : MEMWB port map (
		Clock => Clock,
		Reset => Reset,
		Clear => MEMWBClear,
		WriteEN => MEMWBWriteEN,
		RegWriteInput => EXMEMRegWrite,
		MemReadInput => EXMEMMemRead,
		RegDestInput => EXMEMRegDest,
		EXResultInput => EXMEMEXResult,
		MemDataBInput => DataInput,
		RegWriteOutput => MEMWBRegWrite,
		MemReadOutput => MEMWBMemRead,
		RegDestOutput => MEMWBRegDest,
		EXResultOutput => MEMWBEXResult,
		MemDataBOutput => MEMWBMemDataB
	);

-- WB BEGIN

	WBMuxInstance : Mux port map (
		Sel => MEMWBMemRead,
		InputA => MEMWBEXResult,
		InputB => MEMWBMemDataB,
		Output => WBMuxOutput
	);

-- WB END

end Behavioral;
 