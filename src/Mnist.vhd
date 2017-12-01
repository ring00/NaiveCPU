----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    23:52:37 11/19/2017
-- Design Name:
-- Module Name:    IFID - Behavioral
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
library ieee;
use ieee.STD_LOGIC_1164.all;

entity Mnist is
port(
	Clk_0,Reset: in STD_LOGIC;
	Image: in STD_LOGIC_VECTOR(3 downto 0);
	Answer: in STD_LOGIC_VECTOR(3 downto 0);
	Hs,Vs: out STD_LOGIC; 
	R,G,B: out STD_LOGIC_VECTOR(2 downto 0)
);
end Mnist;

architecture Behavioral of Mnist is

component Vga640480 is
	 port(
			Address		:		  out	STD_LOGIC_VECTOR(13 DOWNTO 0);
			Image			:			in STD_LOGIC_VECTOR(3 downto 0);
			Answer		:			in STD_LOGIC_VECTOR(3 downto 0);
			Reset       :         in  STD_LOGIC;
			Clk25       :		  out STD_LOGIC; 
			Q		    :		  in STD_LOGIC_VECTOR(0 downto 0);
			Clk_0       :         in  STD_LOGIC; --100M时钟输入
			Hs,Vs       :         out STD_LOGIC; --行同步、场同步信号
			R,G,B       :         out STD_LOGIC_VECTOR(2 downto 0)
	  );
end component;

component DigitalRom IS
	PORT
	(
		Address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		Q		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

signal address_tmp: STD_LOGIC_VECTOR(13 downto 0);
signal Clk25: STD_LOGIC;
signal q_tmp: STD_LOGIC_VECTOR(0 downto 0);
signal frame: STD_LOGIC_VECTOR(3 downto 0);

begin

u1: vga640480 port map(
						Address=>address_tmp, 
						Image=>Image,
						Answer=>Answer,
						Reset=>Reset, 
						Clk25=>Clk25, 
						Q=>q_tmp, 
						Clk_0=>Clk_0, 
						Hs=>Hs, Vs=>Vs, 
						R=>R, G=>G, B=>B
					);
u2: DigitalRom port map(	
						Address=>address_tmp, 
						clock=>Clk25, 
						Q=>q_tmp
					);
end Behavioral;