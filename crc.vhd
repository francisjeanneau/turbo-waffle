LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CRC IS
  PORT (
    clk_i           : IN  STD_LOGIC;
    rst_i           : IN  STD_LOGIC;
    crc_start_i     : IN  STD_LOGIC;
    data_i          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    crc_done_o      : OUT STD_LOGIC;
    data_o          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;


ARCHITECTURE RTL OF CRC IS
  -- SIGNAL -------------------------------------------------------------------
  SIGNAL data_in_aug  : STD_LOGIC_VECTOR(0 TO 47)     := (OTHERS=>'0');
  SIGNAL crc_done_sig : STD_LOGIC                     := '0';
  -- REGISTER -----------------------------------------------------------------
  SIGNAL data_in_reg  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS=>'0');
BEGIN

  data_o      <= data_in_reg;
  crc_done_o  <= crc_done_sig;
  data_in_aug <= data_i & x"0000";

  PROCESS(clk_i)
    CONSTANT poly             : UNSIGNED(15 DOWNTO 0)         := x"1021";
    VARIABLE data_in_signal   : STD_LOGIC                     := '0';
    VARIABLE started_var      : STD_LOGIC                     := '0';
    VARIABLE counter_s_signal : UNSIGNED(6 DOWNTO 0)          := (OTHERS=>'0');
    VARIABLE data_in_reg_var  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS=>'0');
  BEGIN
    IF rising_edge(clk_i) THEN
      IF rst_i = '1' THEN
        data_in_reg       <= (OTHERS=>'0');
        crc_done_sig      <= '0';
        started_var       := '0';
        counter_s_signal  := (OTHERS=>'0');
        data_in_reg_var   := (OTHERS=>'0');

      ELSIF (counter_s_signal <= 47) and ((started_var = '1') or (crc_start_i = '1')) THEN
        IF crc_start_i = '1' THEN
          started_var   := crc_start_i;
        END IF;
          data_in_signal    := data_in_aug(TO_INTEGER(counter_s_signal));

          IF data_in_reg(15) = '1' THEN
            data_in_reg_var := data_in_reg(14 downto 0) & data_in_signal;
            data_in_reg     <= data_in_reg_var XOR STD_LOGIC_VECTOR(poly);
          ELSE
            data_in_reg     <= data_in_reg(14 downto 0) & data_in_signal;
          END IF;

        IF counter_s_signal = 47 THEN
          crc_done_sig <= '1';
        END IF;

        counter_s_signal := counter_s_signal + 1;

      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;