library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity route is
    Port (clk       : in std_logic;
          ja        : in std_logic_vector(3 downto 0);
          jb        : in std_logic_vector(7 downto 0);
          jc        : out std_logic_vector(7 downto 0);
          vga_r     : out std_logic_vector(3 downto 0);
          vga_g     : out std_logic_vector(3 downto 0);
          vga_b     : out std_logic_vector(3 downto 0);
          vga_hsync : out std_logic;
          vga_vsync : out std_logic);
end route;

architecture behavior of route is
    signal jb_rise: std_logic := '0';
    signal jb_db: std_logic := '0';

    signal kc    : std_logic_vector(15 downto 0) := x"0000";
    signal kpress: std_logic := '0';
    signal dummy : std_logic := '0';
begin
    video_drv : entity work.vga_char_drv
                port map(clk => clk,
                         ascii_wea => '1', ascii_data => '0' & jb(6 downto 0), ascii_clk => jb_rise,
                         vga_r => vga_r, vga_g => vga_g, vga_b => vga_b,
                         vga_hsync => vga_hsync, vga_vsync => vga_vsync);

    ed : entity work.async_redge
         port map(clk => clk, sig => jb_db, rising => jb_rise);

    db : entity work.db
         port map(clk => clk, len => 50000, sig => jb(7), db => jb_db);

    ps2 : entity work.ps2_keyboard_to_ascii
          port map(clk => clk, ps2_clk => ja(2), ps2_data => ja(0),
                   ascii_new => jc(7), ascii_code => jc(6 downto 0));
end behavior;
