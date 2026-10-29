library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fixed_mul_4bit_hw is
    Port (
        clk    : in STD_LOGIC;
        sw     : in STD_LOGIC_VECTOR(7 downto 0); -- sw(3:0) = A, sw(7:4) = B
        seg    : out STD_LOGIC_VECTOR(6 downto 0); -- Segmen A-G
        an     : out STD_LOGIC_VECTOR(3 downto 0)  -- Anoda digit
    );
end fixed_mul_4bit_hw;

architecture Behavioral of fixed_mul_4bit_hw is
    signal a, b       : unsigned(3 downto 0);
    signal product    : unsigned(7 downto 0);
    signal result_fix : unsigned(3 downto 0);
    signal ref_counter: unsigned(15 downto 0) := (others => '0');
    signal digit0     : unsigned(3 downto 0);
begin
    -- Petakan switch
    a <= unsigned(sw(3 downto 0));
    b <= unsigned(sw(7 downto 4));

    -- Proses perkalian 4-bit fixed point (diambil bagian tengah/scaling sederhana)
    process(a, b)
        variable full_prod : unsigned(7 downto 0);
    begin
        full_prod := a * b;
        product <= full_prod;
        -- Ambil bit hasil skala fixed-point (misal geser 2 bit untuk format Q2.2)
        result_fix <= full_prod(5 downto 2); 
    end process;

    -- Tampilkan nilai hasil ke digit paling kanan (digit0), digit lain dimatikan
    digit0 <= result_fix;

    -- Multiplexing 7-segment sederhana
    process(clk)
    begin
        if rising_edge(clk) then
            ref_counter <= ref_counter + 1;
        end if;
    end process;

    an <= "1110"; -- Hanya aktifkan digit 0 (paling kanan)

    -- Dekoder 7-segment (Common Anode Basys 3)
    process(digit0)
    begin
        case digit0 is
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
            when "1010" => seg <= "0001000"; -- A
            when "1011" => seg <= "0000011"; -- b
            when "1100" => seg <= "1000110"; -- C
            when "1101" => seg <= "0100001"; -- d
            when "1110" => seg <= "0000110"; -- E
            when others => seg <= "0001110"; -- F
        end case;
    end process;
end Behavioral;