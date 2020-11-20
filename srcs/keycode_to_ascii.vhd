library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity din_to_ascii is
    Port ( clk : in STD_LOGIC;
           keycodes : in STD_LOGIC_VECTOR (15 downto 0);
           kpress : in STD_LOGIC;
           ASCII : out STD_LOGIC_VECTOR (7 downto 0);
           newval : out STD_LOGIC);
end din_to_ascii;

architecture bhv of din_to_ascii is
    signal shift : std_logic := '0';
    signal ascii_update : std_logic := '0';
    
begin

    
    /* detect when its a new key code but it needs to be shifted.
       it helps prevent converting when there is no code to convert. */
    
    shift <= '1' when (keycodes(7 downto 0) = x"F0" and (keycodes(15 downto 8) = x"12" 
                 or keycodes(15 downto 8) = x"59")) or (shift = '1' and (keycodes(7 downto 0) = x"12" 
                 or keycodes(7 downto 0) = x"59")) 
                 else '0';
   
    process(all)
        variable count : integer := 0;
    begin ris: if rising_edge(clk) and kpress = '1' then count := count + 1;
    
        if count > 3 then count := 0; end if;
       
        -- 12 is left shift, 59 is right shift
        if count = 3 and shift = '1' then
            ascii_update <= '1';
            case keycodes(15 downto 8) is
                  WHEN x"1C" => ascii <= x"41"; --A
                  WHEN x"32" => ascii <= x"42"; --B
                  WHEN x"21" => ascii <= x"43"; --C
                  WHEN x"23" => ascii <= x"44"; --D
                  WHEN x"24" => ascii <= x"45"; --E
                  WHEN x"2B" => ascii <= x"46"; --F
                  WHEN x"34" => ascii <= x"47"; --G
                  WHEN x"33" => ascii <= x"48"; --H
                  WHEN x"43" => ascii <= x"49"; --I
                  WHEN x"3B" => ascii <= x"4A"; --J
                  WHEN x"42" => ascii <= x"4B"; --K
                  WHEN x"4B" => ascii <= x"4C"; --L
                  WHEN x"3A" => ascii <= x"4D"; --M
                  WHEN x"31" => ascii <= x"4E"; --N
                  WHEN x"44" => ascii <= x"4F"; --O
                  WHEN x"4D" => ascii <= x"50"; --P
                  WHEN x"15" => ascii <= x"51"; --Q
                  WHEN x"2D" => ascii <= x"52"; --R
                  WHEN x"1B" => ascii <= x"53"; --S
                  WHEN x"2C" => ascii <= x"54"; --T
                  WHEN x"3C" => ascii <= x"55"; --U
                  WHEN x"2A" => ascii <= x"56"; --V
                  WHEN x"1D" => ascii <= x"57"; --W
                  WHEN x"22" => ascii <= x"58"; --X
                  WHEN x"35" => ascii <= x"59"; --Y
                  WHEN x"1A" => ascii <= x"5A"; --Z
                  WHEN x"16" => ascii <= x"21"; --!
                  WHEN x"52" => ascii <= x"22"; --"
                  WHEN x"26" => ascii <= x"23"; --#
                  WHEN x"25" => ascii <= x"24"; --$
                  WHEN x"2E" => ascii <= x"25"; --%
                  WHEN x"3D" => ascii <= x"26"; --&              
                  WHEN x"46" => ascii <= x"28"; --(
                  WHEN x"45" => ascii <= x"29"; --)
                  WHEN x"3E" => ascii <= x"2A"; --*
                  WHEN x"55" => ascii <= x"2B"; --+
                  WHEN x"4C" => ascii <= x"3A"; --:
                  WHEN x"41" => ascii <= x"3C"; --<
                  WHEN x"49" => ascii <= x"3E"; -->
                  WHEN x"4A" => ascii <= x"3F"; --?
                  WHEN x"1E" => ascii <= x"40"; --@
                  WHEN x"36" => ascii <= x"5E"; --^
                  WHEN x"4E" => ascii <= x"5F"; --_
                  WHEN x"54" => ascii <= x"7B"; --{
                  WHEN x"5D" => ascii <= x"7C"; --|
                  WHEN x"5B" => ascii <= x"7D"; --}
                  WHEN x"0E" => ascii <= x"7E"; --~
                  WHEN OTHERS => NULL;
             end case;
         
         --lowercase letters and numbers, keys that don't need shift or control
         --i did not worry about control commands (yet?) 
          
         elsif(shift = '0' and count = 2) then
            ascii_update <= '1'; 
            case keycodes(15 downto 8) is
                  WHEN x"1C" => ascii <= x"61"; --a
                  WHEN x"32" => ascii <= x"62"; --b
                  WHEN x"21" => ascii <= x"63"; --c
                  WHEN x"23" => ascii <= x"64"; --d
                  WHEN x"24" => ascii <= x"65"; --e
                  WHEN x"2B" => ascii <= x"66"; --f
                  WHEN x"34" => ascii <= x"67"; --g
                  WHEN x"33" => ascii <= x"68"; --h
                  WHEN x"43" => ascii <= x"69"; --i
                  WHEN x"3B" => ascii <= x"6A"; --j
                  WHEN x"42" => ascii <= x"6B"; --k
                  WHEN x"4B" => ascii <= x"6C"; --l
                  WHEN x"3A" => ascii <= x"6D"; --m
                  WHEN x"31" => ascii <= x"6E"; --n
                  WHEN x"44" => ascii <= x"6F"; --o
                  WHEN x"4D" => ascii <= x"70"; --p
                  WHEN x"15" => ascii <= x"71"; --q
                  WHEN x"2D" => ascii <= x"72"; --r
                  WHEN x"1B" => ascii <= x"73"; --s
                  WHEN x"2C" => ascii <= x"74"; --t
                  WHEN x"3C" => ascii <= x"75"; --u
                  WHEN x"2A" => ascii <= x"76"; --v
                  WHEN x"1D" => ascii <= x"77"; --w
                  WHEN x"22" => ascii <= x"78"; --x
                  WHEN x"35" => ascii <= x"79"; --y
                  WHEN x"1A" => ascii <= x"7A"; --z
                  WHEN x"45" => ascii <= x"30"; --0
                  WHEN x"16" => ascii <= x"31"; --1
                  WHEN x"1E" => ascii <= x"32"; --2
                  WHEN x"26" => ascii <= x"33"; --3
                  WHEN x"25" => ascii <= x"34"; --4
                  WHEN x"2E" => ascii <= x"35"; --5
                  WHEN x"36" => ascii <= x"36"; --6
                  WHEN x"3D" => ascii <= x"37"; --7
                  WHEN x"3E" => ascii <= x"38"; --8
                  WHEN x"46" => ascii <= x"39"; --9
                  WHEN x"52" => ascii <= x"27"; --'
                  WHEN x"41" => ascii <= x"2C"; --,
                  WHEN x"4E" => ascii <= x"2D"; ---
                  WHEN x"49" => ascii <= x"2E"; --.
                  WHEN x"4A" => ascii <= x"2F"; --/
                  WHEN x"4C" => ascii <= x"3B"; --;
                  WHEN x"55" => ascii <= x"3D"; --=
                  WHEN x"54" => ascii <= x"5B"; --[
                  WHEN x"5D" => ascii <= x"5C"; --\
                  WHEN x"5B" => ascii <= x"5D"; --]
                  WHEN x"0E" => ascii <= x"60"; --`
                  WHEN x"29" => ascii <= x"20"; --space
                  WHEN x"66" => ascii <= x"08"; --backspace (BS control code)
                  WHEN x"0D" => ascii <= x"09"; --tab (HT control code)
                  WHEN x"5A" => ascii <= x"0D"; --enter (CR control code)
                  WHEN x"76" => ascii <= x"1B"; --escape (ESC control code)
                  WHEN others => NULL;
          end case;
       
       else ascii_update <= '0';
       end if;
       end if ris; end process;    
           
  -- Delay 50 Clock cycles
  HOLD: process(all)
    variable delay : integer := 0;
    variable temp : STD_LOGIC := '0';
  begin ris: if rising_edge(clk) and (delay > 0 or ascii_update = '1') then
      delay := delay + 1;
      
      if delay = 50 then
        temp := '0'; 
        delay := 0;
      else temp := '1'; end if;
    end if ris;
    
    newval <= temp;
  end process HOLD;
          
end bhv;
