library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity kp_to_buf is
    Port ( clk : in STD_LOGIC;
           ps2_clk : in STD_LOGIC;
           ps2_data : in STD_LOGIC;
           pop_val : in STD_LOGIC;
           buf_size : out STD_LOGIC_VECTOR(5 downto 0);
           ASCII : out STD_LOGIC_VECTOR(7 downto 0);
           newpress : out STD_LOGIC;
           clk_out : out STD_LOGIC);
end kp_to_buf;

architecture bhv of kp_to_buf is

    signal ascii_conv : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    signal f_writ, f_read, f, af, e, ae, push : STD_LOGIC := '0';
    signal num_vals : STD_LOGIC_VECTOR(5 downto 0) := "000000";
    
    COMPONENT ascii_buf
      PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        full : OUT STD_LOGIC;
        almost_full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC;
        almost_empty : OUT STD_LOGIC
      );
    END COMPONENT;

begin
-- Components and Signal Assignments

  buf_size <= num_vals;
  clk_out <= clk;
  
  FIFO : ascii_buf
    PORT MAP (
      clk => clk,
      srst => '0',
      din => ascii_conv,
      wr_en => f_writ,
      rd_en => f_read,
      dout => ASCII,
      full => f,
      almost_full => af,
      empty => e,
      almost_empty => ae );

  I2A: entity work.din_to_ascii(bhv)
       port map(din => kb_in, ASCII => ascii_conv);




-- Processes

  FIN: process(all)
    variable delay : integer := 0;
  begin if rising_edge(clk) then 
    if push = '1' and delay < 1 then delay := 1; 
    elsif push = '0' and delay < 1 then delay := 0; f_writ <= '0'; end if;
    
    if delay = 1 and f = '0' and num_vals /= "100000" then 
      f_writ <= '1';
      num_vals <= std_logic_vector(unsigned(num_vals) + 1);
    end if;
    
    delay := delay - 1; 
    
  end if; end process FIN;



  FOUT: process(all)
    variable delay : integer := 0;
  begin if rising_edge(clk) then 
    if pop_val = '1' and delay < 1 then delay := 1;
    elsif pop_val = '0' and delay < 1 then delay := 0; f_read <= '0'; end if;
    
    if delay = 1 and e = '0' and num_vals /= "000000" then 
      f_read <= '1';
      num_vals <= std_logic_vector(unsigned(num_vals) - 1);
    end if;
    
    delay := delay - 1; 
    
  end if; end process FOUT;



end bhv;
