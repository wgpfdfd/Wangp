----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:45:53 03/19/2020 
-- Design Name: 
-- Module Name:    Subbytes_128 - Behavioral 
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


ENTITY Subbytes_128 IS
   PORT (
      clk        : IN STD_LOGIC;
      reset      : IN STD_LOGIC;
      valid_in   : IN STD_LOGIC;
      data_in    : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
      valid_out  : OUT STD_LOGIC;
      data_out   : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
   );
END Subbytes_128;

ARCHITECTURE trans OF Subbytes_128 IS
   COMPONENT Sbox IS
      PORT (
         addr       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         dout       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
   END COMPONENT;
   
BEGIN
   ROM : FOR i IN 15 DOWNTO 0 GENERATE
      u_sbox : Sbox
         PORT MAP (
            data_in((i * 8) + 7 DOWNTO (i * 8)),
            data_out((i * 8) + 7 DOWNTO (i * 8))
         );
   END GENERATE;
   
   PROCESS (clk, reset)
   BEGIN
      IF ((NOT(reset)) = '1') THEN
         valid_out <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         valid_out <= valid_in;
      END IF;
   END PROCESS;
   
   
END trans;
