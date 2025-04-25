library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_pomodoro is
end entity TB_pomodoro;

architecture Behavioral of TB_pomodoro is

    component pomodoro
        port (
            CLK100MHZ : in  std_logic;
            A         : in  std_logic;
            B         : in  std_logic;
            C         : in  std_logic;
            MM        : out std_logic_vector(7 downto 0);
            SS        : out std_logic_vector(7 downto 0);
            LED16_B   : out std_logic;
            LED16_R   : out std_logic;
            LED16_G   : out std_logic
        );
    end component;

    -- Signály pro testbench
    signal clk100MHz_tb : std_logic := '0';
    signal A_tb         : std_logic := '0';
    signal B_tb         : std_logic := '0';
    signal C_tb         : std_logic := '0';
    signal MM_tb        : std_logic_vector(7 downto 0);
    signal SS_tb        : std_logic_vector(7 downto 0);

    signal LED16_B_tb   : std_logic;
    signal LED16_R_tb   : std_logic;
    signal LED16_G_tb   : std_logic;

    constant clk_period : time := 10 ns;

begin

    uut: pomodoro 
        port map (
            CLK100MHZ => clk100MHz_tb,
            A         => A_tb,
            B         => B_tb,
            C         => C_tb,
            MM        => MM_tb,
            SS        => SS_tb,
            LED16_B   => LED16_B_tb,
            LED16_R   => LED16_R_tb,
            LED16_G   => LED16_G_tb
        );

    clk_process: process
    begin
        loop
            clk100MHz_tb <= '0';
            wait for clk_period / 2;
            clk100MHz_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimulus_process: process
    begin
        A_tb <= '0';
        B_tb <= '0';
        C_tb <= '0';
        wait for 20 ns;

        wait for 500 ns;

        -- Start režim "work"
        C_tb <= '1';
        wait for clk_period;
        C_tb <= '0';
        wait for 20 ns;

        -- Simulace nějaké činnosti
        for i in 1 to 5 loop
            A_tb <= '1';
            wait for clk_period;
            A_tb <= '0';
            wait for 2 * clk_period;
        end loop;

        wait for 100 ns;
        
        -- Další události (např. skip, reset atd.)
        A_tb <= '1';
        wait for 5 * clk_period;
        A_tb <= '0';

        B_tb <= '1';  -- skip -> short break
        wait for clk_period;
        B_tb <= '0';
        wait for 2 * clk_period;

        wait for 1000 ms;

        -- Zpět do idle
        C_tb <= '1';
        wait for clk_period;
        C_tb <= '0';

        wait for 500 ns;

        wait;
    end process;

end architecture Behavioral;
