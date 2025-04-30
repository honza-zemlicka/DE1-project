library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pomodoro is
end entity tb_pomodoro;

architecture Behavioral of tb_pomodoro is

    component pomodoro is
        port (
            CLK100MHZ : in  std_logic;
            A         : in  std_logic; -- reset
            B         : in  std_logic; -- start/pause/resume
            C         : in  std_logic; -- skip
            MM        : out std_logic_vector(7 downto 0);
            SS        : out std_logic_vector(7 downto 0);
            LED16_B   : out std_logic; -- idle
            LED16_R   : out std_logic; -- work
            LED16_G   : out std_logic  -- break
        );
    end component;

    signal CLK100MHZ : std_logic := '0';
    signal A         : std_logic := '0';
    signal B         : std_logic := '0';
    signal C         : std_logic := '0';
    signal MM        : std_logic_vector(7 downto 0);
    signal SS        : std_logic_vector(7 downto 0);
    signal LED16_B   : std_logic;
    signal LED16_R   : std_logic;
    signal LED16_G   : std_logic;

begin

    UUT: pomodoro
        port map (
            CLK100MHZ => CLK100MHZ,
            A         => A,
            B         => B,
            C         => C,
            MM        => MM,
            SS        => SS,
            LED16_B   => LED16_B,
            LED16_R   => LED16_R,
            LED16_G   => LED16_G
        );

    -- Hodiny 100 MHz, běží 1 ms
    CLK100MHZ_process : process
    begin
        while now < 170 us loop
            CLK100MHZ <= '0'; wait for 5 ns;
            CLK100MHZ <= '1'; wait for 5 ns;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        -- Start
        B <= '1'; wait for 1 us; B <= '0'; wait for 20 us;

        -- Pause
        B <= '1'; wait for 1 us; B <= '0'; wait for 20 us;

        -- Resume
        B <= '1'; wait for 1 us; B <= '0'; wait for 20 us;

        -- Skip
        C <= '1'; wait for 1 us; C <= '0'; wait for 20 us;

        -- Reset
        A <= '1'; wait for 1 us; A <= '0'; wait for 20 us;

        -- Resume
        B <= '1'; wait for 1 us; B <= '0'; wait for 20 us;

        -- Skip
        C <= '1'; wait for 1 us; C <= '0'; wait for 20 us;

        -- Resume
        B <= '1'; wait for 1 us; B <= '0'; wait for 20 us;

        assert false report "Simulation done" severity failure;
    end process;

end Behavioral;
