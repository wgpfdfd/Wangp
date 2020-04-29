--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:46:54 03/21/2020
-- Design Name:   
-- Module Name:   E:/AES128_Fpga/AES_TOP/AES128_pipelined/TOP_tb.vhd
-- Project Name:  AES128_pipelined
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Top
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
 
ENTITY TOP_tb IS
END TOP_tb;
 
ARCHITECTURE behavior OF TOP_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Top
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         data_valid_in : IN  std_logic;
         cipherkey_valid_in : IN  std_logic;
         cipher_key : IN  std_logic_vector(127 downto 0);
         plain_text : IN  std_logic_vector(127 downto 0);
         valid_out : OUT  std_logic;
         cipher_text : OUT  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal data_valid_in : std_logic := '0';
   signal cipherkey_valid_in : std_logic := '0';
   signal cipher_key : std_logic_vector(127 downto 0) := (others => '0');
   signal plain_text : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal valid_out : std_logic;
   signal cipher_text : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Top PORT MAP (
          clk => clk,
          reset => reset,
          data_valid_in => data_valid_in,
          cipherkey_valid_in => cipherkey_valid_in,
          cipher_key => cipher_key,
          plain_text => plain_text,
          valid_out => valid_out,
          cipher_text => cipher_text
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		reset <= '1';
		
		cipherkey_valid_in <= '1';
		cipher_key <= x"2b7e151628aed2a6abf7158809cf4f3c";
		
		
		data_valid_in <= '1';
		plain_text <=x"3243f6a8885a308d313198a2e0370734";
     
   end process;

END;
