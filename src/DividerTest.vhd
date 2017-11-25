--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:31:37 11/25/2017
-- Design Name:   
-- Module Name:   C:/Users/zwei/Desktop/NaiveCPU/src/DividerTest.vhd
-- Project Name:  NaiveCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FrequencyDivider
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
 
ENTITY DividerTest IS
END DividerTest;
 
ARCHITECTURE behavior OF DividerTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FrequencyDivider
    PORT(
         Reset : IN  std_logic;
         Clock11 : IN  std_logic;
         Clock01 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Reset : std_logic := '0';
   signal Clock11 : std_logic := '0';

 	--Outputs
   signal Clock01 : std_logic;

   -- Clock period definitions
   constant Clock11_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FrequencyDivider PORT MAP (
          Reset => Reset,
          Clock11 => Clock11,
          Clock01 => Clock01
        );

   -- Clock process definitions
   Clock11_process :process
   begin
		Clock11 <= '0';
		wait for Clock11_period/2;
		Clock11 <= '1';
		wait for Clock11_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		wait for 5 ns;
		
		Reset <= '1';
		
      wait for 5 ns;	
		
		Reset <= '0';

      wait for Clock11_period;

      -- insert stimulus here 

      wait;
   end process;

END;
