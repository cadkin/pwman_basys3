library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Divides input clock by half.
entity clkdiv is
    Port ( clk : in STD_LOGIC := '0';
           hclk : out STD_LOGIC := '0');
end clkdiv;

architecture behavior of clkdiv is
begin
    process(clk)
    begin
        if (rising_edge(clK)) then
            hclk <= not hclk;
        end if;
    end process;

end behavior;
