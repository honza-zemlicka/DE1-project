library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pomodoro is
    port (
        CLK100MHZ : in  std_logic;
        A         : in  std_logic; -- reset
        B         : in  std_logic; -- skip
        C         : in  std_logic; -- start
        MM        : out std_logic_vector(7 downto 0);
        SS        : out std_logic_vector(7 downto 0);
        LED16_B   : out std_logic; -- idle
        LED16_R   : out std_logic; -- work
        LED16_G   : out std_logic  -- break
    );
end entity pomodoro;

architecture Behavioral of pomodoro is

    type state_type is (idle, work, short_break, long_break);
    signal state : state_type := idle;

    constant WORK_MINUTES        : integer := 25;
    constant SHORT_BREAK_MINUTES: integer := 5;
    constant LONG_BREAK_MINUTES : integer := 15;

    signal s_minuty  : integer range 0 to 59 := 0;
    signal s_sekundy : integer range 0 to 59 := 0;

    signal work_counter : integer range 0 to 3 := 0;

    constant SECOND_TC : natural := 100_000_000;
    signal count : natural range 0 to SECOND_TC - 1 := 0;
    signal second_tick : std_logic := '0';

    signal A_prev, B_prev, C_prev : std_logic := '0';

begin

    tick_gen_proc : process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if count = SECOND_TC - 1 then
                count <= 0;
                second_tick <= '1';
            else
                count <= count + 1;
                second_tick <= '0';
            end if;
        end if;
    end process;

    Clock : process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            A_prev <= A;
            B_prev <= B;
            C_prev <= C;

            -- RESET
            if A = '1' and A_prev = '0' then
                state <= idle;
                s_minuty <= 0;
                s_sekundy <= 0;
                work_counter <= 0;

            -- SKIP tla?ítko
            elsif B = '1' and B_prev = '0' then
                case state is
                    when work =>
                        if work_counter = 2 then
                            state <= long_break;
                            s_minuty <= LONG_BREAK_MINUTES;
                            work_counter <= 0;
                        else
                            state <= short_break;
                            s_minuty <= SHORT_BREAK_MINUTES;
                            work_counter <= work_counter + 1;
                        end if;
                        s_sekundy <= 0;
                    when short_break | long_break =>
                        state <= work;
                        s_minuty <= WORK_MINUTES;
                        s_sekundy <= 0;
                    when others =>
                        null;
                end case;

            -- START tla?ítko (pouze v idle)
            elsif C = '1' and C_prev = '0' then
                if state = idle then
                    state <= work;
                    s_minuty <= WORK_MINUTES;
                    s_sekundy <= 0;
                    work_counter <= 0;
                end if;
            end if;

            -- Odpo?ítávání
            if second_tick = '1' then
                if state /= idle then
                    if s_minuty = 0 and s_sekundy = 0 then
                        -- ?as vypršel, p?echod
                        case state is
                            when work =>
                                if work_counter = 2 then
                                    state <= long_break;
                                    s_minuty <= LONG_BREAK_MINUTES;
                                    work_counter <= 0;
                                else
                                    state <= short_break;
                                    s_minuty <= SHORT_BREAK_MINUTES;
                                    work_counter <= work_counter + 1;
                                end if;
                                s_sekundy <= 0;

                            when short_break | long_break =>
                                state <= work;
                                s_minuty <= WORK_MINUTES;
                                s_sekundy <= 0;

                            when others =>
                                null;
                        end case;
                    else
                        if s_sekundy = 0 then
                            s_sekundy <= 59;
                            s_minuty <= s_minuty - 1;
                        else
                            s_sekundy <= s_sekundy - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Výstupy pro LED
    LED16_R <= '1' when state = work else '0';
    LED16_G <= '1' when state = short_break or state = long_break else '0';
    LED16_B <= '1' when state = idle else '0';

    -- Výstupy ?asu
    MM <= std_logic_vector(to_unsigned(s_minuty, 8));
    SS <= std_logic_vector(to_unsigned(s_sekundy, 8));

end Behavioral;
