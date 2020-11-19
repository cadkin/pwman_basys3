library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity kp_to_buf is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ps2_clk : in STD_LOGIC;
           ps2_data : in STD_LOGIC;
           
           ASCII : out STD_LOGIC_VECTOR(7 downto 0);
           newpress : out STD_LOGIC;
           clk_out : out STD_LOGIC);
end kp_to_buf;

architecture bhv of kp_to_buf is

  signal keycodes : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

begin
-- Components and Signal Assignments

  clk_out <= clk;
 
  KeycodetoAscii: entity work.din_to_ascii(bhv)
       port map(keycodes => keycodes, ASCII => ASCII);

  PS2toKeycode: entity work.ps2_to_keycode(bhv)
       port map(clk => clk, reset => reset, ps2_clk => ps2_clk, ps2_data => ps2_data, keycodes => keycodes, kpress => newpress );

end bhv;
