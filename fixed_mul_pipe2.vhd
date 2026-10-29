library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fixed_mul_pipe2 is
    Port ( 
        clk    : in STD_LOGIC;
        a      : in STD_LOGIC_VECTOR (15 downto 0);
        b      : in STD_LOGIC_VECTOR (15 downto 0);
        result : out STD_LOGIC_VECTOR (15 downto 0)
    );
end fixed_mul_pipe2;

architecture Behavioral of fixed_mul_pipe2 is
    signal product_reg : unsigned(31 downto 0); -- register tahap 1
    signal result_reg  : STD_LOGIC_VECTOR(15 downto 0); -- register tahap 2
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Tahap 1: hitung perkalian penuh, simpan ke register[cite: 1]
            product_reg <= unsigned(a) * unsigned(b);
            
            -- Tahap 2: ambil hasil tahap 1 dari siklus sebelumnya, lakukan scaling[cite: 1]
            result_reg  <= STD_LOGIC_VECTOR(product_reg(23 downto 8));
        end if;
    end process;

    result <= result_reg;
end Behavioral;