LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Subbytes_32 IS
   PORT (
      clk        : IN STD_LOGIC;
      reset      : IN STD_LOGIC;
      valid_in   : IN STD_LOGIC;
      data_in    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      valid_out  : OUT STD_LOGIC;
      data_out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
   );
END Subbytes_32;

ARCHITECTURE trans OF Subbytes_32 IS
   COMPONENT Sbox IS
      PORT (
         addr       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         dout       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
   END COMPONENT;
   
BEGIN
   ROM : FOR i IN 3 DOWNTO 0 GENERATE
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


