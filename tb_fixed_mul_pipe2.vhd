library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_fixed_mul_pipe2 is
end tb_fixed_mul_pipe2;

architecture behavioral of tb_fixed_mul_pipe2 is
    signal clk : STD_LOGIC := '0';
    signal a, b : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal result : STD_LOGIC_VECTOR(15 downto 0);
    constant clk_period : time := 10 ns;
begin
    -- Generator Clock 100 MHz
    clk_process : process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    uut: entity work.fixed_mul_pipe2
        port map ( clk => clk, a => a, b => b, result => result );

    stimulus: process
    begin
        wait for clk_period;
        a <= X"0200"; b <= X"0300"; -- Masukkan input 2.0 * 3.0[cite: 1]
        
        -- Tunggu 2 siklus clock agar hasil keluar di pipeline tahap 2[cite: 1]
        wait for clk_period * 2; 
        assert (result = X"0600") report "Pipeline 2 Gagal" severity error;

        wait;
    end process;
end behavioral;