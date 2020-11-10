library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- TODO: color from blue to white.
entity vga_char_drv is
    Port (clk        : in std_logic;
          ascii_wea  : in std_logic;
          ascii_data : in std_logic_vector (7 downto 0);
          ascii_clk  : in std_logic;
          rst        : in std_logic;
          ascii_full : out std_logic;
          vga_r      : out std_logic_vector (3 downto 0);
          vga_g      : out std_logic_vector (3 downto 0);
          vga_b      : out std_logic_vector (3 downto 0);
          vga_hsync  : out std_logic;
          vga_vsync  : out std_logic);
end vga_char_drv;

architecture behavior of vga_char_drv is
    signal fifo_wea  : std_logic := '0';
    signal fifo_rea  : std_logic := '0';
    signal fifo_data : std_logic_vector(7 downto 0) := x"00";
    signal fifo_empty: std_logic := '0';
    
    signal ascii_printable : std_logic := '1';
    signal ascii_print_idx : std_logic_vector(6 downto 0) := "0000000";
    
    signal not_clk : std_logic := '0';
    
    signal fb_addr : std_logic_vector(16 downto 0) := x"0000" & '0';
    signal fb_wea  : std_logic := '0';
    
    signal rom_addr: std_logic_vector(10 downto 0);    
    signal rom_data: std_logic_vector(11 downto 0) := x"000";
    
    signal clear_fb: std_logic := '0';
begin
    vga_d: entity work.vga
           port map(clk => clk, 
                    fb_clk => not_clk, fb_addr => fb_addr, fb_data => rom_data, fb_wea => fb_wea,
                    vga_r => vga_r, vga_g => vga_g, vga_b => vga_b,
                    vga_hsync => vga_hsync, vga_vsync => vga_vsync);
    
    -- Clock and not clock are used to make fifo sort of a DDR setup.
    s_buf: entity work.ascii_fifo
           port map(rst => rst, wr_clk => clk, rd_clk => not_clk, din => ascii_data,
                    wr_en => fifo_wea, rd_en => fifo_rea, dout => fifo_data, full => ascii_full,
                    empty => fifo_empty);
                    
    font_r: entity work.font_rom
            port map(clka => not_clk, addra => rom_addr, douta => rom_data); 
         
    not_clk <= not clk;
    
    -- If ascii char is printable, set a signal high. 
    with (fifo_data(6 downto 5)) select ascii_printable <=
        '0' when "00",
        '1' when others;
    
    -- Reindex ascii value from 32 -> 0. Used into index in ROM.
    with (fifo_data(6 downto 5)) select ascii_print_idx <=
        "00" & fifo_data(4 downto 0) when "01",
        "01" & fifo_data(4 downto 0) when "10",
        "10" & fifo_data(4 downto 0) when "11",
        "0000000" when others;
    
    -- Fifo write process.
    process(clk, ascii_clk)
    begin
        if (rising_edge(clk)) then
            if (fifo_wea <= '1') then
                fifo_wea <= '0';
            end if;
        
            if (ascii_wea = '1' and ascii_clk = '1') then
                fifo_wea <= '1';
            end if;
        end if; 
    end process;
    
    -- Main address logic process.
    process(clk, rst)
        -- ROM indexing information.
        constant pxg_rom_src_idx_max: integer := 1519;
        constant pxg_rom_font_row   : integer := 190;
        variable pxg_rom_src_idx    : integer range 0 to pxg_rom_src_idx_max;

        
        -- FB ram indexing information
        variable pxg_ram_dest_idx_max: integer := 119999;
        constant pxg_ram_fb_row      : integer := 200;
        variable pxg_ram_dest_idx    : integer range 0 to pxg_ram_dest_idx_max;
         
        -- Shared indexing information.
        constant pxg_copy_size  : integer := 16;
        variable pxg_copy_count : integer range 0 to pxg_copy_size := 0;
        
        -- Position of cursor.
        constant cursor_pos_max : integer := 7500;
        variable cursor_pos     : integer range 0 to cursor_pos_max := 0;
        
        -- Current state.
        variable copying : std_logic := '0';
        variable odd_cycle : std_logic := '0';
    begin
        if (rst = '1') then
            copying := '0';
            odd_cycle := '0';
            pxg_copy_count := 0;
            
            cursor_pos := 0;
            
            clear_fb <= '1';
            fb_wea <= '1';
            pxg_rom_src_idx := 0;
            pxg_ram_dest_idx := 0;
        end if;
 
        if (rising_edge(clk)) then
            -- Reset framebuffer if clearing.
            if (clear_fb = '1') then
                if (pxg_ram_dest_idx = pxg_ram_dest_idx_max) then
                    clear_fb <= '0';
                    fb_wea <= '0';
                end if;
                pxg_ram_dest_idx := pxg_ram_dest_idx + 1;   
            end if;
        
            -- If we are copying, increment the address. 
            if (copying = '1') then
                -- Hang a cycle to allow copy from rom to occur.
                if (odd_cycle = '0') then
                    odd_cycle := '1';
                else
                    -- Next address is +1 if on even interations and to the next row
                    -- on odd. 
                    if (pxg_copy_count mod 2 = 0) then
                        pxg_ram_dest_idx := pxg_ram_dest_idx + 1;
                        pxg_rom_src_idx := pxg_rom_src_idx + 1;
                    else
                        pxg_ram_dest_idx := pxg_ram_dest_idx + (pxg_ram_fb_row - 1);
                        pxg_rom_src_idx := pxg_rom_src_idx + (pxg_rom_font_row - 1);
                    end if;
                    
                    -- Increment the count of px groups copied so far.
                    pxg_copy_count := pxg_copy_count + 1;
                    
                    -- Detect if we are done copying the current character.
                    if (pxg_copy_count = pxg_copy_size) then
                        copying := '0';
                        pxg_copy_count := 0;
                        fb_wea <= '0';
                        
                        -- Increment the cursor position.
                        cursor_pos := cursor_pos + 1;
                        if (cursor_pos >= cursor_pos_max) then
                            cursor_pos := 0;
                        end if;
                    end if;
                    
                    odd_cycle := '0'; 
                end if;
            -- If the fifo is not empty and we are not copying currently, get the next char.
            elsif (fifo_empty = '0') then
                fifo_rea <= '1';                
            end if;
            

            -- Reset read enable the next clock cycle.
            if (fifo_rea = '1' and clear_fb = '0') then
                fifo_rea <= '0';
                
                -- If ascii is printable, intialize the source and destination. 
                if (ascii_printable = '1') then
                    -- Probable cause of -8.150 negative slack.
                    pxg_ram_dest_idx := ((cursor_pos mod 100) * 2) + ((cursor_pos / 100) * pxg_ram_fb_row * 8); 
                    pxg_rom_src_idx  := to_integer(unsigned(ascii_print_idx)) * 2;
                    
                    copying := '1';
                    odd_cycle := '0';
                    fb_wea <= '1';
                else
                    -- Handle control codes here. 
                    case fifo_data(4 downto 0) is
                        when "01000" => cursor_pos := cursor_pos - 1;           -- Back. (non-destructive)
                        when "01001" => cursor_pos := cursor_pos + 4;           -- Tab.
                        when "01101" => cursor_pos := (cursor_pos / 100) + 100; -- Carriage Return.
                        when others => null;
                    end case;
                    
                    if (cursor_pos > cursor_pos_max or cursor_pos < 0) then
                        cursor_pos := 0;
                    end if;
                end if;
            end if;

            fb_addr <= std_logic_vector(to_unsigned(pxg_ram_dest_idx, fb_addr'length));
            rom_addr <= std_logic_vector(to_unsigned(pxg_rom_src_idx, rom_addr'length));
        end if;
    end process;
end behavior;
