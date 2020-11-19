use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity kp_to_buf is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ps2_clk : in STD_LOGIC;
           ps2_data : in STD_LOGIC;
           pop_val : in STD_LOGIC;
           buf_size : out STD_LOGIC_VECTOR(5 downto 0);
           ASCII : out STD_LOGIC_VECTOR(7 downto 0);
           newpress : out STD_LOGIC;
           clk_out : out STD_LOGIC);
end kp_to_buf;

architecture bhv of kp_to_buf is

  signal keycodes : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
  signal ascii_conv : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
  signal f_writ, f_read, f, af, e, ae, push : STD_LOGIC := '0';
  
  signal num_vals : integer range 0 to 32 := 0;
  signal nv_inc, nv_dec : STD_LOGIC := '0';
    
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

  buf_size <= std_logic_vector(to_signed(num_vals, buf_size'length) );
  clk_out <= clk;
  newpress <= push;
  
  FIFO : ascii_buf
    PORT MAP (
      clk => clk,
      srst => reset,
      din => ascii_conv,
      wr_en => f_writ,
      rd_en => f_read,
      dout => ASCII,
      full => f,
      almost_full => af,
      empty => e,
      almost_empty => ae );

  KeycodetoAscii: entity work.din_to_ascii(bhv)
       port map(keycodes => keycodes, ASCII => ascii_conv);

  PS2toKeycode: entity work.ps2_to_keycode(bhv)
       port map(clk => clk, reset => reset, ps2_clk => ps2_clk, ps2_data => ps2_data, keycodes => keycodes, kpress => push );


-- Processes

  FIN: process(push)
    variable delay, flag : integer := 0;
  begin 
    if push = '1' then flag := 1; end if;
    ris: if rising_edge(clk) then 
      if flag = 1 and delay < 1 then delay := 5; end if; 
    
      if delay > 0 then delay := delay - 1; end if;
      
      setwrite: if delay > 0 and num_vals < 32 then
        setflags: if delay = 0 then flag := 0;
          f_writ <= '0'; nv_inc <= '0';
        else
          f_writ <= '1'; nv_inc <= '1';
        end if setflags;
    end if setwrite; end if ris;    
  end process FIN;



  FOUT: process(pop_val)
    variable delay, flag : integer := 0;
  begin 
    if pop_val = '1' then flag := 1; end if;
    ris: if rising_edge(clk) then
      if flag = 1 and delay < 1 then delay := 5; end if;
      
      if delay > 0 then delay := delay - 1; end if;
      
      setread: if delay > 0 and num_vals > 0 then
        setflags: if delay = 0 then flag := 0;
          f_writ <= '0'; nv_inc <= '0';
        else
          f_writ <= '1'; nv_inc <= '1';
        end if setflags;
    end if setread; end if ris;    
  end process FOUT;

  HANDLENUM: process(nv_inc, nv_dec)
  -- ADD A DELAY HERE
  begin ris: if rising_edge(clk) then
    if nv_inc = '1' then num_vals <= num_vals + 1;
    elsif nv_dec = '1' then num_vals <= num_vals - 1;
    end if;
  end if ris; end process HANDLENUM;

end bhv;
