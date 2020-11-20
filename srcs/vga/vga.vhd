library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Main vga controller module with access to framebuffer.
entity vga is
    Port (clk       : in std_logic;
          fb_clk    : in std_logic;
          fb_addr   : in std_logic_vector(16 downto 0);
          fb_data   : in std_logic_vector(11 downto 0);
          fb_wea    : in std_logic;
          vga_r     : out std_logic_vector(3 downto 0);
          vga_g     : out std_logic_vector(3 downto 0);
          vga_b     : out std_logic_vector(3 downto 0);
          vga_hsync : out std_logic;
          vga_vsync : out std_logic);
end vga;

architecture behavior of vga is
    signal blank : std_logic := '0';

    signal idx_px  : integer range 0 to 479999 := 0;
    signal ram_idx : integer range 0 to 119999 := 0;
    signal fb_pxg  : std_logic_vector(11 downto 0) := "000000000000";
    signal pxg_idx : integer range 0 to 3 := 0;
    signal rgb     : std_logic_vector(2 downto 0) := "111";
begin
    vga_s: entity work.vga_sync
           port map(clk => clk, idx_px => idx_px,
                     hsync => vga_hsync, vsync => vga_vsync, blank => blank);

    -- According to datasheet, read access time on block ram with output
    -- register and -1 speed grade is only 0.89 ns. This _should_ be sufficient.
    vgafb: entity work.vga_fb
           port map(clka => fb_clk, addra => fb_addr, dina => fb_data, wea(0) => fb_wea,
                    clkb => clk, addrb => std_logic_vector(to_unsigned(ram_idx, 17)), doutb => fb_pxg);

    -- Get the ram index by dividing the pixel index by 4.
    ram_idx <= idx_px / 4;
    pxg_idx <= idx_px mod 4;

    -- Select the outputs from the pixel group.
    with pxg_idx select rgb <=
       fb_pxg(11 downto 9) when 1,
       fb_pxg(8 downto 6)  when 2,
       fb_pxg(5 downto 3)  when 3,
       -- Vector is off by one.
       fb_pxg(2 downto 0)  when 0;

    -- Convert the rgb signal into 4 bits. Could theoretically be used to control palette.
    vga_r <= "0000" when (blank = '1' or rgb(1) = '0') else "1111";
    vga_g <= "0000" when (blank = '1' or rgb(2) = '0') else "1111";
    vga_b <= "0000" when (blank = '1' or rgb(0) = '0') else "1111";


end behavior;
