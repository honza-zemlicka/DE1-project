library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (
            CLK100MHZ  : in  std_logic;
            BTNC       : in  std_logic;
            BTNL       : in  std_logic;
            BTNR       : in  std_logic;
            LED16_B    : out std_logic;
            LED16_R    : out std_logic;
            LED16_G    : out std_logic;
            CA         : out std_logic;
            CB         : out std_logic;
            CC         : out std_logic;
            CD         : out std_logic;
            CE         : out std_logic;
            CF         : out std_logic;
            CG         : out std_logic;
            DP         : out std_logic;
            AN         : out std_logic_vector (7 downto 0)
        );
    end component;

    -- Clock and inputs
    signal CLK100MHZ : std_logic := '0';
    signal BTNC      : std_logic := '0'; -- reset
    signal BTNL      : std_logic := '0'; -- start/pause
    signal BTNR      : std_logic := '0'; -- skip

    -- Outputs
    signal LED16_B   : std_logic;
    signal LED16_R   : std_logic;
    signal LED16_G   : std_logic;
    signal CA        : std_logic;
    signal CB        : std_logic;
    signal CC        : std_logic;
    signal CD        : std_logic;
    signal CE        : std_logic;
    signal CF        : std_logic;
    signal CG        : std_logic;
    signal DP        : std_logic;
    signal AN        : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    -- DUT instance
    dut : top_level
        port map (
            CLK100MHZ => CLK100MHZ,
            BTNC      => BTNC,
            BTNL      => BTNL,
            BTNR      => BTNR,
            LED16_B   => LED16_B,
            LED16_R   => LED16_R,
            LED16_G   => LED16_G,
            CA        => CA,
            CB        => CB,
            CC        => CC,
            CD        => CD,
            CE        => CE,
            CF        => CF,
            CG        => CG,
            DP        => DP,
            AN        => AN
        );

    -- Clock generator
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    CLK100MHZ <= TbClock;

    -- Stimuli process
    stimuli : process
    begin
        -- Initial state
        BTNC <= '0';
        BTNL <= '0';
        BTNR <= '0';
        wait for 500 ns;

        -- Start režimu "work"
        BTNC <= '1'; wait for 30 ns; BTNC <= '0';
        wait for 500 ns;

        -- Simulace krátké pauzy (skip)
        BTNC <= '1'; wait for 30 ns; BTNC <= '0';
        wait for 500 ns;

        -- Reset do idle
        BTNR <= '1'; wait for 30 ns; BTNR <= '0';
        wait for 100 ns;

        -- Konec testu (lze odkomentovat)
        -- TbSimEnded <= '1';
        wait;
    end process;

end architecture tb;

-- Optional config for simulation
configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;
