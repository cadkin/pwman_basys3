library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ps2_to_keycode is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ps2_clk : in STD_LOGIC;
           ps2_data : in STD_LOGIC;
           keycodes : out STD_LOGIC_VECTOR (15 downto 0); -- Left first, right previous
           kpress : out STD_LOGIC);
end ps2_to_keycode;

architecture bhv of ps2_to_keycode is
    signal kb_in : STD_LOGIC_VECTOR(0 to 7) := "00000000";
    signal prev_in : STD_LOGIC_VECTOR(0 to 7) := "00000000";
    signal ukp, prevkp : STD_LOGIC := '0';
begin
  UPDATE: process(all)
  variable i : integer := 0;
  begin fal: if falling_edge(ps2_clk) then
    
    -- Set value of kb_in, set push
    data: if i > 0 and i < 9 then kb_in(i-1) <= ps2_data;
    elsif i = 9 then ukp <= '1';
    elsif i = 10 then ukp <= '0';
    end if data;
    
    -- Update i
    up: if i < 10 then i := i+1;
    else i := 0; end if up;    
  end if fal; end process UPDATE;


  PRESS: process(all)
  begin
    setkeycodes: if reset = '1' then keycodes <= "0000000000000000"; 
    elsif rising_edge(clk) then 
      if ukp = '1' and prevkp = '0' then
        keycodes(15 downto 8) <= kb_in; keycodes(7 downto 0) <= prev_in;
        kpress <= '1';
        prev_in <= kb_in;

      else kpress <= '0';
      end if;
    end if setkeycodes;
    
    updtflag: if rising_edge(clk) then prevkp <= ukp; end if updtflag;
  end process PRESS;

end bhv;
