library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity din_to_ascii is
    Port ( din : in STD_LOGIC_VECTOR (0 to 7);
           ASCII : out STD_LOGIC_VECTOR (7 downto 0));
end din_to_ascii;

architecture bhv of din_to_ascii is

begin

  ASCII <= din;

end bhv;
