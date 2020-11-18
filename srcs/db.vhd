library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity db is
    Port ( clk    : in std_logic;
           in_btn : in std_logic;
           db_btn : out std_logic);
end db;

architecture behavior of db is
begin
    -- Debounce button.
    process(in_btn, clk)
        -- Has to be active for 5 ms.
        variable clkdiv : integer range 0 to 50000 := 0;
    begin
        if (rising_edge(clk)) then
            if (in_btn = '1') then
                clkdiv := clkdiv + 1;
                if (clkdiv = 50000) then
                    db_btn <= '1';
                end if;
            else
                db_btn <= '0';
                clkdiv := 0;
            end if;
        end if;
    end process;
end behavior;
