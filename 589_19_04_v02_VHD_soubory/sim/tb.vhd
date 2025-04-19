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

    -- Stimulus
    stim_proc: process
    begin
        -- Reset sekvence
        BTNL <= '1'; wait for 50 ns;
        BTNL <= '0'; wait for 50 ns;
    
        -- Start
        BTNC <= '1'; wait for 10 ns;
        BTNC <= '0'; wait for 100 ns;
    
        -- Skip test
        BTNR <= '1'; wait for 10 ns;
        BTNR <= '0'; wait for 50 ns;
    
        -- Necháme běžet systém
        wait for 5000 ns;
    
        assert false report "End of simulation." severity note;
        wait;
    end process;


end behavior;
