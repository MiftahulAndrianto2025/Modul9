library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fixed_mul_pipe3 is
    Port ( 
        clk    : in STD_LOGIC;
        a      : in STD_LOGIC_VECTOR (15 downto 0);
        b      : in STD_LOGIC_VECTOR (15 downto 0);
        result : out STD_LOGIC_VECTOR (15 downto 0)
    );
end fixed_mul_pipe3;

architecture Behavioral of fixed_mul_pipe3 is
    signal stage1_prod : unsigned(31 downto 0);
    signal stage2_mid  : unsigned(31 downto 0);
    signal stage3_res  : STD_LOGIC_VECTOR(15 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Tahap 1: Perkalian parsial
            stage1_prod <= unsigned(a) * unsigned(b);
            -- Tahap 2: Register antara
            stage2_mid  <= stage1_prod;
            -- Tahap 3: Scaling akhir (geser 8 bit ke kanan, ambil 16 bit bawah)
            stage3_res  <= STD_LOGIC_VECTOR(stage2_mid(23 downto 8));
        end if;
    end process;

    result <= stage3_res;
end Behavioral;