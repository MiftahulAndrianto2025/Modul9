library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fixed_mul_pipe3_hw is
    Port (
        clk    : in STD_LOGIC;                     
        sw     : in STD_LOGIC_VECTOR(15 downto 0); 
        led    : out STD_LOGIC_VECTOR(15 downto 0)  
    );
end fixed_mul_pipe3_hw;

architecture Behavioral of fixed_mul_pipe3_hw is
    signal a_in, b_in : STD_LOGIC_VECTOR(15 downto 0);
    signal result_out : STD_LOGIC_VECTOR(15 downto 0);
begin
    -- Mapping switch: sw(7 downto 0) untuk input A, sw(15 downto 8) untuk input B
    a_in <= "00000000" & sw(7 downto 0);
    b_in <= "00000000" & sw(15 downto 8);

    uut_pipe3: entity work.fixed_mul_pipe3
        port map (
            clk    => clk,
            a      => a_in,
            b      => b_in,
            result => result_out
        );

    led <= result_out;
end Behavioral;