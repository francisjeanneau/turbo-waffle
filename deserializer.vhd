LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY deserializer IS
  PORT (
    clk_i    : IN  STD_LOGIC;
    clear_i  : IN  STD_LOGIC;
    start_i  : IN  STD_LOGIC;
    done_o   : OUT STD_LOGIC;
    data_i   : IN  STD_LOGIC;
    data_o   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
  );
END ENTITY;

ARCHITECTURE rtl OF deserializer IS
  -- REGISTER ------------------------------------------------------------------
BEGIN

  

END ARCHITECTURE;