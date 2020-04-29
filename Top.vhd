----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:09:15 03/20/2020 
-- Design Name: 
-- Module Name:    Top - Behavioral 
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

entity Top is
port (
		clk : in std_logic;                       --system clock
		reset : in std_logic;                     --asynch reset
		data_valid_in : in std_logic;            --data valid signal
		cipherkey_valid_in : in std_logic;        --cipher key valid signal
		cipher_key : IN STD_LOGIC_VECTOR(127 DOWNTO 0);    --cipher key
		plain_text : IN STD_LOGIC_VECTOR(127 DOWNTO 0);   --plain text
		valid_out : OUT std_logic;               --output valid signal
		cipher_text : OUT STD_LOGIC_VECTOR(127 DOWNTO 0) --cipher text
);
end Top;

architecture Behavioral of Top is

Component Subbytes_128 IS
   PORT (
      clk        : IN STD_LOGIC;
      reset      : IN STD_LOGIC;
      valid_in   : IN STD_LOGIC;
      data_in    : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
      valid_out  : OUT STD_LOGIC;
      data_out   : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
   );
END Component;

Component shiftrows is
    Port ( 
				clk : in  STD_LOGIC;
				reset : in  STD_LOGIC;
				valid_in : in  STD_LOGIC;
				data_in : in  STD_LOGIC_VECTOR (127 downto 0);
           valid_out : out  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (127 downto 0)
           );
end Component;

Component AddRoundKey IS
   PORT (
      clk            : IN STD_LOGIC;
      reset          : IN STD_LOGIC;
      data_valid_in  : IN STD_LOGIC;
      key_valid_in   : IN STD_LOGIC;
      data_in        : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
      round_key      : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
      valid_out      : OUT STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
   );
END Component;

Component Keyexpantion IS
   PORT (
      
      clk         : IN STD_LOGIC;
      reset       : IN STD_LOGIC;
      valid_in    : IN STD_LOGIC;
      cipher_key  : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
      W           : OUT STD_LOGIC_VECTOR((11 * 128)-1  DOWNTO 0);
      valid_out   : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
   );
END Component;

Component Round IS
   PORT (
      clk            : IN STD_LOGIC;
      reset          : IN STD_LOGIC;
      data_valid_in  : IN STD_LOGIC;
      key_valid_in   : IN STD_LOGIC;
      data_in        : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
      round_key      : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
      valid_out      : OUT STD_LOGIC;
      data_out       : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
   );
END Component;

TYPE data_array IS ARRAY (0 TO 9) OF STD_LOGIC_VECTOR(127 DOWNTO 0);

signal valid_round_key : STD_LOGIC_VECTOR(10 DOWNTO 0);            --all round keys valid signals KeyExpantion output
signal valid_round_data : STD_LOGIC_VECTOR(9 DOWNTO 0);         --all rounds ouput data valid signals
signal data_round : data_array;    										--all rounds data
signal valid_sub2shift : std_logic;                            --for final round connection
signal valid_shift2key : std_logic;                            
signal data_sub2shift : std_logic_vector(127 downto 0);                
signal data_shift2key : std_logic_vector(127 downto 0);                 
signal W : STD_LOGIC_VECTOR((11 * 128) - 1 DOWNTO 0);                 --all round keys


signal data_shift2key_delayed : std_logic_vector(127 downto 0) ;           --for last round delay register
signal valid_shift2key_delayed : std_logic ;
 
begin

U_KEYEXP : Keyexpantion
PORT MAP
(clk,reset,cipherkey_valid_in,cipher_key,W,valid_round_key);

U0_ARK : AddRoundKey
PORT MAP
(clk,reset,data_valid_in,valid_round_key(10),plain_text,W(11*128 - 1 downto 10*128),valid_round_data(0),data_round(0));

   ROUND_GEN : FOR i IN 0 to 8 GENERATE
      ROUND_U : Round
         PORT MAP (clk,reset,valid_round_data(i),valid_round_key(i),data_round(i),W((10-i)*128-1 downto (9-i)*128),valid_round_data(i+1),data_round(i+1));
   END GENERATE;

U_SUB :Subbytes_128
PORT MAP
(clk,reset,valid_round_data(9),data_round(9),valid_sub2shift,data_sub2shift);

U_SH :ShiftRows
PORT MAP  
(clk,reset,valid_sub2shift,data_sub2shift,valid_shift2key,data_shift2key);

U_KEY : AddRoundKey  
PORT MAP 
(clk,reset,valid_shift2key_delayed,valid_round_key(9),data_shift2key_delayed,W(127 downto 0),valid_out,cipher_text);

PROCESS (clk, reset)
   BEGIN
      IF ((NOT(reset)) = '1') THEN
			valid_shift2key_delayed <= '0';
			data_shift2key_delayed <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
      ELSIF (valid_shift2key = '1') THEN
         data_shift2key_delayed <= data_shift2key; 
		ELSE
			data_shift2key_delayed <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
      END IF;
         valid_shift2key_delayed <= valid_shift2key;
   END PROCESS;

end Behavioral;

