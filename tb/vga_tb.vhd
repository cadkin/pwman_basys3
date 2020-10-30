library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_tb is
--  Port ( );
end vga_tb;

architecture behavior of vga_tb is
    signal clk : std_logic := '0';
    signal vga_hsync, vga_vsync : std_Logic := '0';
    
    signal vga_r, vga_g, vga_b : std_logic_vector(3 downto 0) := "0000";
begin
    rt: entity work.route
        port map(clk => clk, vga_hsync => vga_hsync, vga_vsync => vga_vsync,
                 vga_r => vga_r, vga_g => vga_g, vga_b => vga_b);

    process
    begin
        wait for 5 ns;
        clk <= not clk;
    end process;
    
    process
    begin
        wait;
    end process;

end behavior;
