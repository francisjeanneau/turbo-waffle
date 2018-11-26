LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY serializer IS
  PORT (
    clk_i    : IN  STD_LOGIC;
    clear_i  : IN  STD_LOGIC;
    start_i  : IN  STD_LOGIC;
    done_o   : OUT STD_LOGIC;
    data_i   : IN  STD_LOGIC_VECTOR(32+16-1 DOWNTO 0);
    data_o   : OUT STD_LOGIC;
  );
END ENTITY;

ARCHITECTURE rtl OF serializer IS
  -- REGISTER ------------------------------------------------------------------
BEGIN

  

END ARCHITECTURE;