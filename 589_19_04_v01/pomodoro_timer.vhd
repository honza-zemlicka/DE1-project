library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pomodoro_timer is
    Port (
        clk         : in std_logic;
        rst         : in std_logic;
        btn_start   : in std_logic; -- BTNC
        btn_skip    : in std_logic; -- BTNR
        btn_reset   : in std_logic; -- BTNL
        done        : in std_logic; -- signál z countdown_timer, že doběhl čas

        mode_work_led  : out std_logic; -- LED16_R
        mode_break_led : out std_logic; -- LED16_G
        mode_done_led  : out std_logic; -- LED16_B

        run_timer    : out std_logic;              -- povolení běhu časovače
        time_select  : out std_logic_vector(1 downto 0)  -- 00 = work, 01 = short break, 10 = long break
    );
end pomodoro_timer;

architecture Behavioral of pomodoro_timer is

    type state_type is (
        IDLE,
        WORK_RUNNING,
        WORK_DONE,
        SHORT_BREAK_RUNNING,
        SHORT_BREAK_DONE,
        LONG_BREAK_RUNNING,
        LONG_BREAK_DONE
    );
    signal current_state, next_state : state_type;

    signal work_count : integer range 0 to 3 := 0;
    signal running    : std_logic := '0';

    -- Tlačítkový debounce detekce hran (pro jednoduchost - synchronní verze)
    signal btn_start_prev, btn_skip_prev, btn_reset_prev : std_logic := '0';
    signal btn_start_edge, btn_skip_edge, btn_reset_edge : std_logic;

begin

    --------------------------------------------------------------------
    -- Detekce hran (jednoduchá)
    process(clk)
    begin
        if rising_edge(clk) then
            btn_start_edge <= btn_start and not btn_start_prev;
            btn_skip_edge  <= btn_skip and not btn_skip_prev;
            btn_reset_edge <= btn_reset and not btn_reset_prev;

            btn_start_prev <= btn_start;
            btn_skip_prev  <= btn_skip;
            btn_reset_prev <= btn_reset;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Stavový automat
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= IDLE;
            work_count    <= 0;
            running       <= '0';
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Přechody mezi stavy
    process(current_state, btn_start_edge, btn_skip_edge, btn_reset_edge, done, work_count, running)
    begin
        next_state <= current_state;

        case current_state is
            when IDLE =>
                running    <= '0';
                if btn_reset_edge = '1' then
                    next_state <= IDLE;
                elsif btn_start_edge = '1' then
                    next_state <= WORK_RUNNING;
                end if;

            when WORK_RUNNING =>
                running <= '1';
                if btn_start_edge = '1' then
                    running <= '0'; -- pauza
                elsif btn_skip_edge = '1' or done = '1' then
                    next_state <= WORK_DONE;
                end if;

            when WORK_DONE =>
                running <= '0';
                if btn_start_edge = '1' then
                    if work_count = 2 then
                        next_state <= LONG_BREAK_RUNNING;
                    else
                        next_state <= SHORT_BREAK_RUNNING;
                    end if;
                end if;

            when SHORT_BREAK_RUNNING =>
                running <= '1';
                if btn_start_edge = '1' then
                    running <= '0'; -- pauza
                elsif btn_skip_edge = '1' or done = '1' then
                    next_state <= SHORT_BREAK_DONE;
                end if;

            when SHORT_BREAK_DONE =>
                running <= '0';
                if btn_start_edge = '1' then
                    next_state <= WORK_RUNNING;
                end if;

            when LONG_BREAK_RUNNING =>
                running <= '1';
                if btn_start_edge = '1' then
                    running <= '0';
                elsif btn_skip_edge = '1' or done = '1' then
                    next_state <= LONG_BREAK_DONE;
                end if;

            when LONG_BREAK_DONE =>
                running <= '0';
                if btn_start_edge = '1' then
                    next_state <= WORK_RUNNING;
                end if;

            when others =>
                next_state <= IDLE;
        end case;
    end process;

    --------------------------------------------------------------------
    -- Výstupy a pomocná logika
    process(current_state)
    begin
        -- Výchozí hodnoty
        mode_work_led  <= '0';
        mode_break_led <= '0';
        mode_done_led  <= '0';
        time_select    <= "00"; -- default = work

        case current_state is
            when IDLE =>
                mode_done_led <= '1';
                time_select   <= "00"; -- připraven na práci

            when WORK_RUNNING =>
                mode_work_led <= '1';
                time_select   <= "00";

            when WORK_DONE =>
                mode_done_led <= '1';
                time_select   <= "00";

            when SHORT_BREAK_RUNNING =>
                mode_break_led <= '1';
                time_select    <= "01";

            when SHORT_BREAK_DONE =>
                mode_done_led <= '1';
                time_select   <= "01";

            when LONG_BREAK_RUNNING =>
                mode_break_led <= '1';
                time_select    <= "10";

            when LONG_BREAK_DONE =>
                mode_done_led <= '1';
                time_select   <= "10";

            when others =>
                mode_done_led <= '1';
        end case;
    end process;

    --------------------------------------------------------------------
    -- Inkrementace počítadla prací
    process(clk)
    begin
        if rising_edge(clk) then
            if current_state = WORK_DONE and next_state /= WORK_DONE then
                if work_count = 2 then
                    work_count <= 0;
                else
                    work_count <= work_count + 1;
                end if;
            end if;
        end if;
    end process;

    -- Výstup běhu timeru
    run_timer <= running;

end Behavioral;
