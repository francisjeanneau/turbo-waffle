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
  -- SIGNAL --------------------------------------------------------------------
  SIGNAL working     : STD_LOGIC;
  -- REGISTER ------------------------------------------------------------------
  SIGNAL started_reg : STD_LOGIC;
  SIGNAL counter_reg : UNSIGNED(6  DOWNTO 0);
BEGIN

  working <= start_i OR started_reg;

  PROCESS (clk_i)
  BEGIN
    IF rising_edge(clk_i) THEN
      IF clear_i = '1' THEN
        started_reg <= '0';
        counter_reg <= (OTHERS=>'0');
        done_o      <= '0';
      ELSE
        started_reg <= started_reg;
        counter_reg <= counter_reg;
        done_o      <= done_o;
        IF start_i = '1' THEN
          started_reg <= '1';
        END IF;
        IF working = '1' THEN
          counter_reg <= counter_reg + 1;
          data_o      <= data_i(to_integer(counter_reg));
          IF counter_reg = to_unsigned(47, counter_reg'length) THEN
            started_reg <= '0';
            done_o      <= '1';
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;