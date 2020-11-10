library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Creates a sync signal for a VGA display.
-- Output: 800 x 600 @ 72 Hz
-- Input clock: 100 MHz
-- Note: Resolution due to pixel clock - needed 50 MHz, exactly half of built-in clock. How convient.
entity vga_sync is
    Port(clk    : in std_logic;
         idx_px : out integer range 0 to 479999 := 0;
         hsync  : out std_logic := '0';
         vsync  : out std_logic := '0';
         blank  : out std_logic);
end vga_sync;

architecture behavior of vga_sync is
    signal hclk : std_logic := '0';
    signal hblank, vblank :std_logic := '0';

    -- Constants for timing.
    constant hvis : integer := 800;
    constant h_fp : integer := 856;
    constant h_sy : integer := 976;
    constant h_bp : integer := 1040;

    constant vvis : integer := 600;
    constant v_fp : integer := 637;
    constant v_sy : integer := 643;
    constant v_bp : integer := 666;

    constant px_count : integer := 479999;
begin
    -- Divide input clock.
    hc: entity work.clkdiv
        port map(clk => clk, hclk => hclk);

    -- If either vertical or horizontal are blanking, then overall blank.
    blank <= vblank or hblank;

    process(hclk)
        variable h_px : integer range 1 to h_bp := 1;
        variable v_px : integer range 1 to v_bp := 1;
        variable idx  : integer range 0 to px_count := 0;
    begin
        if (rising_edge(hclk)) then
            -- Send horizontal blanking signal.
            case h_px is
                -- Each pixel increments the overall index.
                when 1 to hvis         => hsync <= '1'; hblank <= '0'; idx := idx + 1;
                when hvis + 1 to h_fp  => hsync <= '1'; hblank <= '1';
                when h_fp + 1 to h_sy  => hsync <= '0'; hblank <= '1';
                when h_sy + 1 to h_bp  => hsync <= '1'; hblank <= '1';
            end case;

            -- Send vertical blanking signal.
            case v_px is
                when 1 to vvis        => vsync <= '1'; vblank <= '0';
                when vvis + 1 to v_fp => vsync <= '1'; vblank <= '1'; idx := 0;
                when v_fp + 1 to v_sy => vsync <= '0'; vblank <= '1'; idx := 0;
                when v_sy + 1 to v_bp => vsync <= '1'; vblank <= '1'; idx := 0;
            end case;

            -- Count up horizontal pixel count pixels.
            h_px := h_px + 1;
            -- Reset horizontal pixel count and increment vertical count.
            if (h_px >= h_bp) then
                v_px := v_px + 1;
                h_px := 1;
            end if;

            -- Reset vertical pixel count when counter reaches the end of the frame.
            if (v_px >= v_bp) then
                v_px := 1;
            end if;

        end if;

        idx_px <= idx;
    end process;

end behavior;
