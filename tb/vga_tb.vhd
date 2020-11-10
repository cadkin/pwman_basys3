library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_tb is
--  Port ( );
end vga_tb;

architecture behavior of vga_tb is
    signal clk : std_logic := '0';
    signal vga_hsync, vga_vsync : std_Logic := '0';
    
    signal vga_r, vga_g, vga_b : std_logic_vector(3 downto 0) := "0000";
    
    signal btnc, write, rst : std_logic := '0';
    
    signal ascii : std_logic_vector(7 downto 0) := x"00";
    signal sw    : std_logic_vector(8 downto 0);
begin
    rt: entity work.route
        port map(clk => clk, btnc => btnc, sw => sw, btnd => rst,
                 vga_hsync => vga_hsync, vga_vsync => vga_vsync,
                 vga_r => vga_r, vga_g => vga_g, vga_b => vga_b);

    sw <= write & ascii;

    process
    begin
        wait for 5 ns;
        clk <= not clk;
    end process;
    
    process
    begin
        write <= '1';
        rst <= '0';

        wait for 180 ns;
        
        ascii <= x"61"; -- 'a'
        wait for 10 ns;
        btnc <= '1';
        wait for 10 ns;
        btnc <= '0';
        
        ascii <= x"62"; -- 'b'
        wait for 10 ns;
        btnc <= '1';
        wait for 10 ns;
        btnc <= '0';
        
        wait;
    end process;

end behavior;
