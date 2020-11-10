library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Route is top module.
entity route is
    Port (clk   : in std_logic;
          btnc  : in std_logic;
          sw    : in std_logic_vector(8 downto 0);
          btnd  : in std_logic;
          vga_r : out std_logic_vector(3 downto 0);
          vga_g : out std_logic_vector(3 downto 0);
          vga_b : out std_logic_vector(3 downto 0);
          vga_hsync: out std_logic;
          vga_vsync: out std_logic);
end route;

architecture behavior of route is
    signal db_btn : std_logic;
    signal db_rise: std_logic := '0';
begin
    video_drv : entity work.vga_char_drv
                port map(clk => clk, rst => btnd,
                         ascii_wea => sw(8), ascii_data => sw(7 downto 0), ascii_clk => db_rise,
                         vga_r => vga_r, vga_g => vga_g, vga_b => vga_b,
                         vga_hsync => vga_hsync, vga_vsync => vga_vsync);

    ed : entity work.async_redge
         port map(clk => clk, sig => db_btn, rising => db_rise);

    db : entity work.db
         port map(clk => clk, in_btn => btnc, db_btn => db_btn);

end behavior;
