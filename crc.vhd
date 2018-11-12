LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CRC IS
  PORT (
    clk_i          : IN  STD_LOGIC;
    rst_i           : IN  STD_LOGIC;
    crc_start_i     : IN  STD_LOGIC;
    data_i          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_o          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;


ARCHITECTURE RTL OF CRC IS
  SIGNAL data_in_aug_reg  : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS=>'0');
  -- REGISTER ------------------------------------------------------------------
  SIGNAL data_in_reg      : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS=>'0');
  SIGNAL crc_reg          : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS=>'0');
BEGIN

  data_o <= crc_reg;
  data_in_aug_reg   <= data_i & x"0000";

  PROCESS(clk_i)
    CONSTANT poly             : UNSIGNED(15 DOWNTO 0) := x"2F15";
    VARIABLE data_in_signal   : STD_LOGIC;
    VARIABLE counter_s_signal : UNSIGNED(6 DOWNTO 0);
  BEGIN
    IF rising_edge(clk_i) THEN
      IF rst_i = '1' THEN
        data_in_reg       <= (OTHERS=>'0');
        crc_reg           <= (OTHERS=>'0');
        counter_s_signal  := (OTHERS=>'0');
      ELSE
        IF data_in_reg(15) = '1' THEN
          data_in_signal := data_in_aug_reg(0 TO 47)(TO_INTEGER(UNSIGNED(counter_s_signal)));
          data_in_reg    <= data_in_reg(14 downto 0) & data_in_signal;
          crc_reg        <= data_in_reg XOR STD_LOGIC_VECTOR(poly);
        ELSE
          data_in_signal := data_in_aug_reg(TO_INTEGER(UNSIGNED(counter_s_signal)));
          data_in_reg    <= data_in_reg(14 downto 0) & data_in_signal;
        END IF;
        counter_s_signal := counter_s_signal + 1;
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;