library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pomodoro is
    port (
        CLK100MHZ : in  std_logic;
        A         : in  std_logic; -- reset
        B         : in  std_logic; -- skip
        C         : in  std_logic; -- start/pause/resume
        MM        : out std_logic_vector(7 downto 0);
        SS        : out std_logic_vector(7 downto 0);
        LED16_B   : out std_logic;
        LED16_R   : out std_logic;
        LED16_G   : out std_logic
    );
end entity pomodoro;

architecture Behavioral of pomodoro is

    type state_type is (idle, work, short_break, long_break);
    signal state : state_type := idle;

    signal s_sekundy : integer range 0 to 59 := 0;
    signal s_minuty  : integer range 0 to 59 := 0;
    signal s_hodiny  : integer range 0 to 23 := 0;

    constant SECOND_TC : natural := 100_000_000;
    signal count : natural range 0 to SECOND_TC - 1;
    signal second_tick : std_logic := '0';

    signal A_prev, B_prev, C_prev : std_logic := '0';

    signal temp_hodiny : integer range 0 to 23 := 0;
    signal temp_minuty : integer range 0 to 59 := 0;

begin

    tick_gen_proc : process(clk100MHz)
    begin
        if rising_edge(clk100MHz) then
            if count = SECOND_TC - 1 then
                count <= 0;
                second_tick <= '1';
            else
                count <= count + 1;
                second_tick <= '0';
            end if;
        end if;
    end process;

    Clock : process(clk100MHz)
    begin
        if rising_edge(clk100MHz) then
            A_prev <= A;
            B_prev <= B;
            C_prev <= C;

            if second_tick = '1' then
                if s_sekundy = 59 then
                    s_sekundy <= 0;
                    if s_minuty = 59 then
                        s_minuty <= 0;
                        if s_hodiny = 23 then
                            s_hodiny <= 0;
                        else
                            s_hodiny <= s_hodiny + 1;
                        end if;
                    else
                        s_minuty <= s_minuty + 1;
                    end if;
                else
                    s_sekundy <= s_sekundy + 1;
                end if;
            end if;

            if C = '1' and C_prev = '0' then
                temp_hodiny <= s_hodiny;
                temp_minuty <= s_minuty;
            end if;

            -- Přepínání stavu na základě tlačítek (demo účel, lze nahradit FSM)
            if A = '1' and A_prev = '0' then
                state <= idle;
            elsif B = '1' and B_prev = '0' then
                state <= short_break;
            elsif C = '1' and C_prev = '0' then
                state <= work;
            end if;
        end if;
    end process;

    -- LED výstupy dle stavu
    LED16_R <= '1' when state = work else '0'; -- červená pro work
    LED16_G <= '1' when state = short_break or state = long_break else '0'; -- zelená pro pauzy
    LED16_B <= '1' when state = idle else '0'; -- modrá pro idle

    -- Výstupy času
    SS <= std_logic_vector(TO_UNSIGNED(s_sekundy, 8));
    MM <= std_logic_vector(TO_UNSIGNED(s_minuty, 8));

end Behavioral;
