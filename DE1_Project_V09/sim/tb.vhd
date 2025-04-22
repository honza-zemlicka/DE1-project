-- Simulation settings - simulation runtime třeba 40ms
-- Upravy v kodu pro simulaci oproti realizaci
-- - countdown_timer - line 65: 99 vs 99999999
-- - clock_divider_1kHz - line 23: 9 vs 99 999

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_level_tb is
end top_level_tb;

architecture behavior of top_level_tb is

    component top_level
        Port ( 
            CLK100MHZ : in std_logic;
            BTNC      : in std_logic;
            BTNR      : in std_logic;
            BTNL      : in std_logic;
            SEG       : out std_logic_vector(6 downto 0);
            AN        : out std_logic_vector(3 downto 0);
            DP        : out std_logic;
            LED16_R   : out std_logic;
            LED16_G   : out std_logic;
            LED16_B   : out std_logic
        );
    end component;

    -- Signály pro připojení komponenty
    signal CLK100MHZ : std_logic := '0';
    signal BTNC      : std_logic := '0';
    signal BTNR      : std_logic := '0';
    signal BTNL      : std_logic := '0';

    signal SEG       : std_logic_vector(6 downto 0);
    signal AN        : std_logic_vector(3 downto 0);
    signal DP        : std_logic;
    signal LED16_R   : std_logic;
    signal LED16_G   : std_logic;
    signal LED16_B   : std_logic;

    -- Signály pro sledování každé číslice displeje
    signal SEG_D0, SEG_D1, SEG_D2, SEG_D3 : std_logic_vector(6 downto 0) := (others => '1');

begin

    -- UUT instantiation
    uut: top_level
        port map (
            CLK100MHZ => CLK100MHZ,
            BTNC      => BTNC,
            BTNR      => BTNR,
            BTNL      => BTNL,
            SEG       => SEG,
            AN        => AN,
            DP        => DP,
            LED16_R   => LED16_R,
            LED16_G   => LED16_G,
            LED16_B   => LED16_B
        );

    -- Clock generation
    clk_process : process
    begin
        CLK100MHZ <= '0';
        wait for 5 ns;
        CLK100MHZ <= '1';
        wait for 5 ns;
    end process;

    -- Zaznamenání výstupů pro každou číslici
    monitor_display : process (CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            case AN is
                when "1110" => SEG_D0 <= SEG; -- AN(0)
                when "1101" => SEG_D1 <= SEG; -- AN(1)
                when "1011" => SEG_D2 <= SEG; -- AN(2)
                when "0111" => SEG_D3 <= SEG; -- AN(3)
                when others => null;
            end case;
        end if;
    end process;

    -- Testovací sekvence
    stimulus : process
    begin
        wait for 200 ns;

        -- Spuštění Pomodoro režimu (BTNC = start)
        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';

        -- Simulace běhu (počkáme 2 ms, během kterých klesne čas)
        wait for 2 ms;

        -- Pokus o skip → v IDLE se nic nestane
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        -- Spustíme pauzu (BTNC = start)
        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Pozastavíme pauzu (BTNC = i pause)
        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Znovu pustíme pauzu (BTNC = start)
        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;

        -- Další skip → zpět do práce (25:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;

        -- Další skip → krátká pauza (5:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        -- Další skip → práce (25:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;

        -- Další skip → dlouhá pauza (15:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → práce
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → pauza (5:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;

        -- Další skip → práce
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;

       -- Další skip → pauza (5:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;

        -- Další skip → práce
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → dlouhá pauza (15:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → práce
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → pauza (5:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → práce
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Reset
        BTNL <= '1';
        wait for 200 ns;
        BTNL <= '0';
        
        -- Znovu od začátku
        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → pauza (5:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → práce
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → pauza (5:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → práce
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → dlouhá pauza (15:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → práce
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;
        
        -- Další skip → pauza (5:00)
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 200 us;

        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 200 us;

        -- Konec simulace
        wait for 500 ns;
        assert false report "Test Completed." severity failure;
    end process;


end behavior;
