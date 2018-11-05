LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CRC IS
  PORT (
    clk2_i          : IN  STD_LOGIC;
    rst_i           : IN  STD_LOGIC;
    crc_start_i     : IN  STD_LOGIC;
    data_i          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_o          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
  );
END ENTITY;


ARCHITECTURE RTL OF CRC IS
  -- REGISTER ------------------------------------------------------------------
  SIGNAL data_in_reg    : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS=­­­>'0');
  SIGNAL crc_reg        : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS=­­­>'0');
BEGIN

  data_o <= crc_reg;

  PROCESS(clk_i)
    CONSTANT poly   	        : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"2F15";
    VARIABLE data_in_signal     : STD_LOGIC;
    VARIABLE counter_s_signal   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  BEGIN
    IF rising_edge(clk_i)
      IF rst_i = '1' THEN
        crc_reg     <= (OTHERS=­­­>'0');
      ELSE
        IF data_in_reg(0) = '1' THEN
          data_in_signal  = data_i(UNSIGNED(counter_s_signal));
          data_in_reg    <= SHIFT_LEFT(data_in_reg, 1);
          data_in_reg(0) <= data_in_signal;
          crc_reg        <= data_in_reg XOR poly;
        ELSE
          data_in_signal  = data_i(UNSIGNED(counter_s_signal));
          data_in_reg    <= SHIFT_LEFT(data_in_reg, 1);
          data_in_reg(0) <= data_in_signal;
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;