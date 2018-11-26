LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY toplevel IS
  PORT (
    clk_i     : IN  STD_LOGIC;
    clk_x2_i  : IN  STD_LOGIC;
    rst_i     : IN  STD_LOGIC_VECTOR;
    start_i   : IN  STD_LOGIC;
    data_i    : IN  STD_LOGIC_VECTOR;
    data_o    : OUT STD_LOGIC;
    done_o    : OUT STD_LOGIC
  );
END ENTITY;


ARCHITECTURE structural OF toplevel IS
  -- SIGNAL --------------------------------------------------------------------
  signal s_internal_clear        : STD_LOGIC;
  signal s_data                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal s_crc                   : STD_LOGIC_VECTOR(15 DOWNTO 0);
  signal s_serializer_input_data : STD_LOGIC_VECTOR(32+16-1 DOWNTO 0);
  -- Control SIGNAL-------------------------------------------------------------
  signal s_deserializer_start : STD_LOGIC;
  signal s_deserializer_done  : STD_LOGIC;
  signal s_crc_start          : STD_LOGIC;
  signal s_crc_done           : STD_LOGIC;
  signal s_serializer_start   : STD_LOGIC;
  signal s_serializer_done    : STD_LOGIC;
BEGIN

s_serializer_input_data <= s_data&s_crc;

crc_controller : work.crc_controller
PORT MAP (
  clk_i                <=  clk_i,
  rst_i                <=  rst_i,
  start_i              <=  start_i,
  clear_o              <=  s_internal_clear,
  deserializer_start_o <=  s_deserializer_start,
  deserializer_done_o  <=  s_deserializer_done,
  crc_start_o          <=  s_crc_start,
  crc_done_o           <=  s_crc_done,
  serializer_start_o   <=  s_serializer_start,
  serializer_done_o    <=  s_serializer_done,
  done_o               <=  done_o
);

deserializer : work.deserializer
PORT MAP (
  clk_i    <=  clk_i,
  clear_i  <=  s_internal_clear,
  start_i  <=  s_deserializer_start,
  done_o   <=  s_deserializer_done,
  data_i   <=  data_i,
  data_o   <=  s_data
);

crc_calculation : work.crc
PORT MAP (
  clk_i        <=  clk_i,
  rst_i        <=  s_internal_clear,
  crc_start_i  <=  s_crc_start,
  crc_done_o   <=  s_crc_done,
  data_i       <=  s_data,
  data_o       <=  s_crc,
);

serializer : work.serializer
PORT MAP (
  clk_i    <=  clk_i,
  clear_i  <=  s_internal_clear,
  start_i  <=  s_serializer_start,
  done_o   <=  s_serializer_done,
  data_i   <=  s_serializer_input_data,
  data_o   <=  data_o
);

END ARCHITECTURE;
