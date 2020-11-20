library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity db is
    Port ( clk : in std_logic;
           len : in integer range 0 to 100000;
           sig : in std_logic;
           db  : out std_logic);
end db;

architecture behavior of db is
begin
    -- Debounce button.
    process(sig, clk)
        variable clkdiv : integer range 0 to 100000 := 0;
    begin
        if (rising_edge(clk)) then
            if (sig = '1') then
                clkdiv := clkdiv + 1;
                if (clkdiv >= len) then
                    db <= '1';
                end if;
            else
                db <= '0';
                clkdiv := 0;
            end if;
        end if;
    end process;
end behavior;

