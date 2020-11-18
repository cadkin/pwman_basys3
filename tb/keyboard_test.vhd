library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity keyboard_test is
--  Port ( );
end keyboard_test;

architecture bhv of keyboard_test is
signal buf_sz : STD_LOGIC_VECTOR(5 downto 0) := "000000";
signal ASCII : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
signal input : STD_LOGIC_VECTOR(54 downto 0);
signal key1 : STD_LOGIC_VECTOR(10 downto 0) := "00001000100";
signal key2 : STD_LOGIC_VECTOR(10 downto 0) := "00101010011";
signal key3 : STD_LOGIC_VECTOR(10 downto 0) := "10011010110";
signal key4 : STD_LOGIC_VECTOR(10 downto 0) := "01110111001";
signal key5 : STD_LOGIC_VECTOR(10 downto 0) := "11111010010";
signal clock : STD_LOGIC := '0'; 
signal c_ps2, d_ps2 : STD_LOGIC := '1';
signal s, pop : STD_LOGIC := '0';
signal k_push : STD_LOGIC;
--signal k_push : STD_LOGIC;
begin

  KEYB: entity work.kp_to_buf(bhv)
        port map(clk => clock, ps2_clk => c_ps2, ps2_data => d_ps2, pop_val => pop, buf_size => buf_sz, ASCII => ASCII );

k_push <= <<signal KEYB.push : STD_LOGIC >>;
--k_push <= <<signal KEYB.push : STD_LOGIC >>;



  process -- Set input keys
  begin
    for ind in 1 to 5 loop
      if ind = 1 then input(10 downto 0) <= key1;
      elsif ind = 2 then input(21 downto 11) <= key2;
      elsif ind = 3 then input(32 downto 22) <= key3;
      elsif ind = 4 then input(43 downto 33) <= key4;
      elsif ind = 5 then input(54 downto 44) <= key5;
      end if;
    end loop; wait;
  end process;

  process -- Clock
  begin
    wait for 5ns;
    clock <= not clock;
  end process;

  process -- PS2 Clock
  variable sending : integer := -1;
  variable a_sent : integer := 0;
  begin if a_sent = 6 then wait; end if;
    
    -- Waits 50ns between simulating a keypress
    if sending = 0 then sending := sending - 1;
      s <= '0';
      pop <= '1';
    elsif sending = -1 then sending := 19; pop <= '0'; wait for 50ns; a_sent := a_sent + 1;
    else s <= '1'; sending := sending - 1; end if;
     
    -- Cycle clock during data burst
    wait for 15ns;
    if sending > -1 and a_sent < 6 then c_ps2 <= not c_ps2; end if; 
  end process;



  process(c_ps2) -- loop through the test cases loop
    variable i, k : integer := 0;
    variable main : integer := 1; 
  begin if falling_edge(c_ps2) and (s = '1') then
    
    if main > 0 and main < 6 then
      -- Get index value      
      i := (main * 11) - 11;
      d_ps2 <= input(k+i); 
      
      -- iterate each step
      if k = 10 then k := 0; main := main + 1;
      else k := k + 1; end if;
    
    end if;
  elsif falling_edge(c_ps2) then d_ps2 <= '1';
  end if; end process;

end bhv;
