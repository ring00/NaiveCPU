--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:01:03 11/24/2017
-- Design Name:   
-- Module Name:   C:/Users/zwei/Desktop/NaiveCPU/src/CPUTest.vhd
-- Project Name:  NaiveCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CPU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CPUTest IS
END CPUTest;
 
ARCHITECTURE behavior OF CPUTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         InstAddress : OUT  std_logic_vector(15 downto 0);
         InstData : IN  std_logic_vector(15 downto 0);
         DataAddress : OUT  std_logic_vector(15 downto 0);
         DataInput : IN  std_logic_vector(15 downto 0);
         DataOutput : OUT  std_logic_vector(15 downto 0);
         MemReadEN : OUT  std_logic;
         MemWriteEN : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '0';
   signal InstData : std_logic_vector(15 downto 0) := (others => '0');
   signal DataInput : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal InstAddress : std_logic_vector(15 downto 0);
   signal DataAddress : std_logic_vector(15 downto 0);
   signal DataOutput : std_logic_vector(15 downto 0);
   signal MemReadEN : std_logic;
   signal MemWriteEN : std_logic;

   -- Clock period definitions
   constant Clock_period : time := 20 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: CPU PORT MAP (
          Clock => Clock,
          Reset => Reset,
          InstAddress => InstAddress,
          InstData => InstData,
          DataAddress => DataAddress,
          DataInput => DataInput,
          DataOutput => DataOutput,
          MemReadEN => MemReadEN,
          MemWriteEN => MemWriteEN
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 5 ns;

		Reset <= '1';

      wait for Clock_period;
		
		Reset <= '0';
		
		wait for Clock_period;
		
		InstData <= "1001100000100001";
		
		DataInput <= x"DEAD";
		
      -- insert stimulus here 

      wait;
   end process;

END;
