library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity async_redge is
    Port ( clk : in STD_LOGIC;
           sig : in STD_LOGIC;
           rising : out STD_LOGIC);
end async_redge;

architecture behavior of async_redge is
    signal r0, r1 : std_logic;
begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            r0 <= sig;
            r1 <= r0;
        end if;
    end process;

    rising <= r0 and (not r1);
    --falling <= (not r0) and r1;
end behavior;
