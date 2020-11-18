library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Route is top module.
entity route is
    Port (clk   : in std_logic;
          ja    : in std_logic_vector(7 downto 0);
          sw    : in std_logic_vector(0 downto 0);
          btnd  : in std_logic;
          vga_r : out std_logic_vector(3 downto 0);
          vga_g : out std_logic_vector(3 downto 0);
          vga_b : out std_logic_vector(3 downto 0);
          vga_hsync: out std_logic;
          vga_vsync: out std_logic);
end route;

architecture behavior of route is
    signal ja_rise: std_logic := '0';
    signal ja_db: std_logic:= '0';
begin
    video_drv : entity work.vga_char_drv
                port map(clk => clk, rst => btnd,
                         ascii_wea => sw(0), ascii_data => '0' & ja(6 downto 0), ascii_clk => ja_rise,
                         vga_r => vga_r, vga_g => vga_g, vga_b => vga_b,
                         vga_hsync => vga_hsync, vga_vsync => vga_vsync);

    ed : entity work.async_redge
         port map(clk => clk, sig => ja_db, rising => ja_rise);

    db : entity work.db
         port map(clk => clk, in_btn => ja(7), db_btn => ja_db);

end behavior;
