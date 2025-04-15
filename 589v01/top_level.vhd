

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port ( CLK100MHZ : in STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end top_level;

architecture Behavioral of top_level is

    signal AN_IN     : std_logic_vector(7 downto 0);
    signal num       : std_logic_vector(3 downto 0);
    signal pulse_1hz : std_logic;

    component bin2seg is
        port(  clear : in std_logic;
               bin   : in std_logic_vector(3 downto 0);
               seg   : out std_logic_vector(6 downto 0));
    end component;

    component counter is
        port ( clk              : in std_logic;
               btn_reset        : in std_logic;
               btn_skip         : in std_logic;
               btn_start_pause  : in std_logic;
               count            : out integer range 0 to 1500 := 1500);
    end component;

    component clock_en is
        generic (n_periods : integer := 50000000); -- Default: 1Hz z 50MHz
        port ( clk   : in  std_logic;
               rst   : in  std_logic;
               pulse : out std_logic);
    end component;

    component countdown_timer is
        port( clk         : in std_logic;
              pulse_1hz   : in std_logic;
              rst_counter : in std_logic;
              min_tens    : out std_logic_vector(3 downto 0);
              min_units   : out std_logic_vector(3 downto 0);
              sec_tens    : out std_logic_vector(3 downto 0);
              sec_units   : out std_logic_vector(3 downto 0));
    end component;

    component mux_4_seg is
        port( EN      : in STD_LOGIC;
              mux_RST : in STD_LOGIC;
              clk     : in STD_LOGIC;
              mux_out : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

begin

    -- Připojení MUXu
    MUX : mux_4_seg
    port map(
        EN       => '1',
        mux_RST  => '0',
        clk      => CLK100MHZ,
        mux_out  => AN_IN(3 downto 0)  -- Používáme jen 4 displeje
    );

    -- Přímé přiřazení na výstup AN
    AN <= AN_IN;

    -- Připojení bin2seg převodníku (zatím jen 1 číslice)
    DISP : bin2seg
    port map(
        clear  => '0',
        bin    => num,
        seg(6) => CA,
        seg(5) => CB,
        seg(4) => CC,
        seg(3) => CD,
        seg(2) => CE,
        seg(1) => CF,
        seg(0) => CG
    );

    -- Clock enable generátor (1 Hz z 100 MHz)
    CLKEN : clock_en
    generic map(n_periods => 100_000_000)
    port map(
        clk   => CLK100MHZ,
        rst   => '0',
        pulse => pulse_1hz
    );

    -- Countdown timer
    TIMER : countdown_timer
    port map(
        clk         => CLK100MHZ,
        pulse_1hz   => pulse_1hz,
        rst_counter => '0',
        min_tens    => open,
        min_units   => open,
        sec_tens    => open,
        sec_units   => open
    );

    -- Pevné zobrazení čísla podle multiplexu (test/demo)
    with AN_IN select
        num <= "0000" when "11110111", -- číslo 0
               "0001" when "11111011", -- číslo 1
               "0010" when "11111101", -- číslo 2
               "0011" when others;     -- číslo 3

    DP <= '1';  -- Tečka vypnutá

end Behavioral;
