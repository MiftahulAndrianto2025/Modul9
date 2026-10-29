library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Perkalian dua bilangan Q8.8 (16-bit unsigned) menghasilkan Q8.8
entity fixed_mul_q8_8 is
    Port ( 
        a      : in STD_LOGIC_VECTOR (15 downto 0); -- format Q8.8
        b      : in STD_LOGIC_VECTOR (15 downto 0); -- format Q8.8
        result : out STD_LOGIC_VECTOR (15 downto 0)  -- format Q8.8
    );
end fixed_mul_q8_8;

architecture Behavioral of fixed_mul_q8_8 is
    signal product : unsigned(31 downto 0); -- Q16.16 (hasil kali penuh, 32-bit)
begin
    product <= unsigned(a) * unsigned(b);
    
    -- Ambil kembali ke format Q8.8: geser 8 bit ke kanan, ambil 16 bit bawah
    result <= STD_LOGIC_VECTOR(product(23 downto 8));
end Behavioral;