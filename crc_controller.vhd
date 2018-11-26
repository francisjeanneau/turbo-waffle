LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY crc_controller IS
  PORT (
    clk_i                : IN  STD_LOGIC;
    rst_i                : IN  STD_LOGIC;
    start_i              : IN  STD_LOGIC;
    clear_o              : OUT STD_LOGIC;
    deserializer_start_o : OUT STD_LOGIC;
    deserializer_done_i  : IN  STD_LOGIC;
    crc_start_o          : OUT STD_LOGIC;
    crc_done_i           : IN  STD_LOGIC;
    serializer_start_o   : OUT STD_LOGIC;
    serializer_done_i    : IN  STD_LOGIC;
    done_o               : OUT STD_LOGIC
  );
END ENTITY;

ARCHITECTURE rtl OF crc_controller IS
TYPE   crc_ctrl_fsm IS (IDLE, DESERIALIZER_START, DESERIALIZER, CRC_START, CRC,
                        SERIALIZER_START, SERIALIZER, DONE);
SIGNAL crc_ctrl_fsm_state : crc_ctrl_fsm := IDLE;
  -- REGISTER ------------------------------------------------------------------
BEGIN
  
  fsm_process : PROCESS(clk_i)
  BEGIN
    IF rising_edge(clk_i) THEN
      IF rst_i = '1' THEN
        clear_o              <= '1';
        deserializer_start_o <= '0';
        crc_start_o          <= '0';
        serializer_start_o   <= '0';
        done_o               <= '0';
        crc_ctrl_fsm_state   <= IDLE;
      ELSE
        clear_o              <= '0';
        deserializer_start_o <= '0';
        crc_start_o          <= '0';
        serializer_start_o   <= '0';
        done_o               <= '0';
        crc_ctrl_fsm_state   <= crc_ctrl_fsm_state;
        CASE crc_ctrl_fsm_state IS
          WHEN IDLE             =>
            clear_o              <= '1';
            IF start_i = '1' THEN
              crc_ctrl_fsm_state <= DESERIALIZER_START;
            END IF;
          WHEN DESERIALIZER_START =>
            deserializer_start_o <= '1';
            crc_ctrl_fsm_state <= DESERIALIZER;
          WHEN DESERIALIZER     =>
            IF deserializer_done_i = '1' THEN
              crc_ctrl_fsm_state   <= CRC_START;
            END IF;
          WHEN CRC_START        =>
            crc_start_o <= '1';
            crc_ctrl_fsm_state <= CRC;
          WHEN CRC              =>
            IF crc_done_i = '1' THEN
              crc_ctrl_fsm_state   <= SERIALIZER_START;
            END IF;
          WHEN SERIALIZER_START =>
            serializer_start_o <= '1';
            crc_ctrl_fsm_state <= SERIALIZER;
          WHEN SERIALIZER       =>
            IF serializer_done_i = '1' THEN
              crc_ctrl_fsm_state   <= DONE;
            END IF;
          WHEN DONE             =>
            done_o <= '1';
            crc_ctrl_fsm_state   <= IDLE;
        END CASE;
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;