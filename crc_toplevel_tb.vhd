LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.all;
LIBRARY std;
USE std.textio.ALL;

ENTITY crc_toplevel_tb IS
END ENTITY;


ARCHITECTURE tb OF crc_toplevel_tb IS
  FILE file_test_vectors : TEXT;
  FILE file_results : TEXT;

  SIGNAL clk           : STD_LOGIC := '0';
  SIGNAL clk_x2        : STD_LOGIC := '0';
  SIGNAL rst           : STD_LOGIC := '0';
  SIGNAL input_data    : STD_LOGIC_VECTOR(31 DOWNTO 0)  := (OTHERS=>'0');
  SIGNAL output_data   : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS=>'0');

  SIGNAL input_data_counter  : INTEGER := 0;
  SIGNAL input_data_serial   : STD_LOGIC;
  SIGNAL output_data_counter : INTEGER := 0;
  SIGNAL output_data_serial  : STD_LOGIC;
  SIGNAL done : STD_LOGIC := '0';
  SIGNAL start : STD_LOGIC := '0';

  CONSTANT clk_period : TIME := 1 pS;
BEGIN

input_data_serial <= input_data(31 - input_data_counter);

  dut : entity work.toplevel
  PORT MAP (
    clk_i     => clk,
    clk_x2_i  => clk_x2,
    rst_i     => rst,
    start_i   => start,
    data_i    => input_data_serial,
    data_o    => output_data_serial,
    done_o    => done
  );

  clk_proc : PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR clk_period/2;
    clk <= '1';
    WAIT FOR clk_period/2;
  END PROCESS;

  clk_x2_proc : PROCESS
  BEGIN
    clk_x2 <= '0';
    WAIT FOR clk_period/4;
    clk_x2 <= '1';
    WAIT FOR clk_period/4;
  END PROCESS;

  PROCESS
    VARIABLE v_i_line      : LINE;
    VARIABLE v_o_line      : LINE;
    VARIABLE v_input_data           : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE v_expected_output_data : STD_LOGIC_VECTOR(47 DOWNTO 0);
    VARIABLE v_space      : CHARACTER;
    VARIABLE vector_num   : INTEGER := 0;
    
  BEGIN
    report "Starting simulation and test";
    file_open(file_test_vectors, "input_vectors.txt",  read_mode);
    file_open(file_results, "output_results.txt", write_mode);
    WHILE NOT endfile(file_test_vectors) LOOP
      report "Executing test vector #" & INTEGER'IMAGE(vector_num);
      input_data_counter  <= 0;
      output_data_counter <= 0;
      readline(file_test_vectors, v_i_line); -- Skip comment
      readline(file_test_vectors, v_i_line);
      hread(v_i_line, v_input_data);
      input_data <= v_input_data;
      WAIT UNTIL falling_edge(clk);
      rst <= '1';
      WAIT UNTIL falling_edge(clk);
      rst <= '0';
      WAIT UNTIL falling_edge(clk);
      start <= '1';
      WAIT UNTIL falling_edge(clk);
      start <= '0';
      FOR I IN 0 TO 2000 LOOP--32 + 48/2 + 48 - 1 LOOP
        WAIT UNTIL falling_edge(clk);
        IF input_data_counter /= 31 THEN
          input_data_counter <= input_data_counter + 1;
        END IF;
        IF done = '1' THEN
          output_data(output_data_counter) <= output_data_serial;
          output_data_counter <= output_data_counter + 1;
        END IF;
      END LOOP;
      WAIT UNTIL falling_edge(clk);

      output_data(output_data_counter) <= output_data_serial;
      
      readline(file_test_vectors, v_i_line);
      hread(v_i_line, v_expected_output_data);
      --ASSERT v_expected_output_data = output_data REPORT "Expected output : " & v_expected_output_data &
      --       " does not match output : " & output_data SEVERITY ERROR;

 
      hwrite(v_o_line, output_data);
      writeline(file_results, v_o_line);
      vector_num := vector_num + 1;
      --hwrite(my_line, std_logic_vector(to_unsigned(16,8)));

    END LOOP;

    file_close(file_test_vectors);
    file_close(file_results);
    
    REPORT "Simulation complete";
    WAIT;

  END PROCESS;
  
END ARCHITECTURE;