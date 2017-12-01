----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:10:16 12/01/2017 
-- Design Name: 
-- Module Name:    digital_rom - Behavioral 
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

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY DigitalRom IS
	PORT
	(
		Address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		Clock		: IN STD_LOGIC ;
		Q		: OUT STD_LOGIC
	);
END DigitalRom;


ARCHITECTURE Behavioral OF DigitalRom IS

	signal rom_output: std_logic_vector(0 downto 0);
	component rom is
	port
	(
		clka: in std_logic;
		wea: in std_logic_vector(0 downto 0);
		addra: in std_logic_vector(13 downto 0);
		dina: in std_logic_vector(0 downto 0);
		douta: out std_logic_vector(0 downto 0)
	);
	end component;

BEGIN
	Q    <= rom_output(0);
	
	rom_component : rom
	port map (
		clka => Clock,
		wea => "0",
		addra => Address,
		dina => "0",
		douta => rom_output
	);



END Behavioral;
