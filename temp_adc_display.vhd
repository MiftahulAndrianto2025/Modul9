library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temp_adc_display is
    Port (
        clk    : in STD_LOGIC;
        sw     : in STD_LOGIC_VECTOR(11 downto 0); -- Input switch 12-bit (ADC tiruan)
        seg    : out STD_LOGIC_VECTOR(6 downto 0); -- Segmen A-G untuk Seven-Segment
        an     : out STD_LOGIC_VECTOR(3 downto 0)  -- Anoda digit (4 digit)
    );
end temp_adc_display;

architecture Behavioral of temp_adc_display is
    -- Perhatikan ukuran bit disamakan (16-bit)
    signal temp_val : unsigned(15 downto 0) := (others => '0');
    signal digit0, digit1, digit2, digit3 : unsigned(3 downto 0);
    signal ref_counter : unsigned(15 downto 0) := (others => '0');
    signal active_digit : integer range 0 to 3 := 0;
begin

    -- Konversi linier ADC (0 - 4095) ke rentang Suhu (0 - 100°C)
    process(sw)
        variable mult_res : unsigned(31 downto 0);
    ganti_suhu: begin
        -- Perkalian 12-bit switch dengan 100
        mult_res := unsigned("0000" & sw) * 100;
        -- Ambil hasil bagian atas yang ukurannya pas 16-bit untuk dimasukkan ke temp_val
        temp_val <= mult_res(27 downto 12); 
    end process;

    -- Ekstraksi digit angka untuk ditampilkan ke 4 digit Seven-Segment
    digit3 <= resize((temp_val / 1000) mod 10, 4);
    digit2 <= resize((temp_val / 100) mod 10, 4);
    digit1 <= resize((temp_val / 10) mod 10, 4);
    digit0 <= resize(temp_val mod 10, 4);

    -- Proses multiplexing kecepatan refresh 7-segment
    process(clk)
    begin
        if rising_edge(clk) then
            ref_counter <= ref_counter + 1;
            if ref_counter = 0 then
                if active_digit = 3 then active_digit <= 0;
                else active_digit <= active_digit + 1;
                end if;
            end if;
        end if;
    end process;

    -- Pengaturan Anoda dan Dekoder 7-Segment (Common Anode Basys 3)
    process(active_digit, digit0, digit1, digit2, digit3)
        variable cur_dig : unsigned(3 downto 0);
    begin
        case active_digit is
            when 0 => an <= "1110"; cur_dig := digit0;
            when 1 => an <= "1101"; cur_dig := digit1;
            when 2 => an <= "1011"; cur_dig := digit2;
            when 3 => an <= "0111"; cur_dig := digit3;
        end case;

        case cur_dig is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when others => seg <= "1111111"; -- Blank
        end case;
    end process;
end Behavioral;