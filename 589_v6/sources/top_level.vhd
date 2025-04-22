
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_level is
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
end top_level;

architecture Behavioral of top_level is

    component countdown_timer is
        Port (
            clk          : in std_logic;
            rst          : in std_logic;
            run_timer    : in std_logic;
            force_reload : in std_logic;
            time_select  : in std_logic_vector(1 downto 0);
            minutes      : out std_logic_vector(5 downto 0);
            seconds      : out std_logic_vector(5 downto 0);
            done         : out std_logic
        );
    end component;

    component bin2seg is
        Port (
            bin     : in std_logic_vector(3 downto 0);
            seg     : out std_logic_vector(6 downto 0)
        );
    end component;

    component pomodoro_timer is
        Port (
            clk            : in std_logic;
            rst            : in std_logic;
            btn_start      : in std_logic;
            btn_skip       : in std_logic;
            btn_reset      : in std_logic;
            done           : in std_logic;
            mode_work_led  : out std_logic;
            mode_break_led : out std_logic;
            mode_done_led  : out std_logic;
            run_timer      : out std_logic;
            force_reload   : out std_logic;
            time_select    : out std_logic_vector(1 downto 0)
        );
    end component;

    component mux_4_seg is
        Port (
            EN          : in STD_LOGIC;
            mux_RST     : in STD_LOGIC;
            clk_1kHz    : in STD_LOGIC;
            mux_out     : out STD_LOGIC_VECTOR (7 downto 0);
            anode_index : out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;

    component clock_divider_1kHz is
        Port (
            clk_in     : in STD_LOGIC;
            reset      : in STD_LOGIC;
            clk_out_1k : out STD_LOGIC
        );
    end component;

    signal minutes_sig, seconds_sig : std_logic_vector(5 downto 0);
    signal run_timer_sig : std_logic;
    signal time_select_sig : std_logic_vector(1 downto 0);
    signal countdown_done : std_logic;
    signal force_reload_signal : std_logic;
    signal digit0, digit1, digit2, digit3 : std_logic_vector(3 downto 0);
    signal seg0, seg1, seg2, seg3 : std_logic_vector(6 downto 0);
    signal anode_select : std_logic_vector(1 downto 0);
    signal dummy_mux_out : std_logic_vector(7 downto 0);
    signal clk_1kHz_sig : std_logic;

begin    

    countdown_inst : countdown_timer
        port map (
            clk         => CLK100MHZ,
            rst         => BTNL,
            run_timer   => run_timer_sig,
            force_reload => force_reload_signal,
            time_select => time_select_sig,
            minutes     => minutes_sig,
            seconds     => seconds_sig,
            done        => countdown_done
        );

    pomodoro_inst : pomodoro_timer
        port map (
            clk            => CLK100MHZ,
            rst            => BTNL,
            btn_start      => BTNC,
            btn_skip       => BTNR,
            btn_reset      => BTNL,
            done           => countdown_done,
            mode_work_led  => LED16_R,
            mode_break_led => LED16_G,
            mode_done_led  => LED16_B,
            run_timer      => run_timer_sig,
            time_select    => time_select_sig,
            force_reload   => force_reload_signal
        );

    -- Dělička hodin
    clk_div_inst: clock_divider_1kHz
        port map (
            clk_in     => CLK100MHZ,
            reset      => BTNL,
            clk_out_1k => clk_1kHz_sig
        );

    -- Multiplexor řízený zpomaleným hodinovým signálem
    mux_inst : mux_4_seg
        port map (
            EN          => '1',
            mux_RST     => BTNL,
            clk_1kHz    => clk_1kHz_sig,  -- Použit zpomalený clock
            mux_out     => dummy_mux_out,
            anode_index => anode_select
        );

    -- Výpočet číslic pro displej
    digit0 <= std_logic_vector(to_unsigned(to_integer(unsigned(seconds_sig)) mod 10, 4));
    digit1 <= std_logic_vector(to_unsigned(to_integer(unsigned(seconds_sig)) / 10, 4));
    digit2 <= std_logic_vector(to_unsigned(to_integer(unsigned(minutes_sig)) mod 10, 4));
    digit3 <= std_logic_vector(to_unsigned(to_integer(unsigned(minutes_sig)) / 10, 4));

    -- Převod na 7-segment
    b2s0: bin2seg port map(bin => digit0, seg => seg0);
    b2s1: bin2seg port map(bin => digit1, seg => seg1);
    b2s2: bin2seg port map(bin => digit2, seg => seg2);
    b2s3: bin2seg port map(bin => digit3, seg => seg3);

    -- Výběr aktivního segmentu podle muxu
process(anode_select)
begin
        case anode_select is
            when "00" =>
                AN <= "1110";
                SEG <= seg0;
                DP <= '1';
            when "01" =>
                AN <= "1101";
                SEG <= seg1;
                DP <= '0';
            when "10" =>
                AN <= "1011";
                SEG <= seg2;
                DP <= '1';
            when others =>
                AN <= "0111";
                SEG <= seg3;
                DP <= '1';
        end case;
end process;

end Behavioral;
