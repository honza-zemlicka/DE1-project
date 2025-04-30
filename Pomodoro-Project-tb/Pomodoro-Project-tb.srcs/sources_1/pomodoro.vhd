library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pomodoro is
    port (
        CLK100MHZ : in  std_logic;
        A         : in  std_logic; -- reset
        B         : in  std_logic; -- start/pause/resume
        C         : in  std_logic; -- skip
        MM        : out std_logic_vector(7 downto 0);
        SS        : out std_logic_vector(7 downto 0);
        LED16_B   : out std_logic; -- čekání na spuštění
        LED16_R   : out std_logic; -- work aktivní
        LED16_G   : out std_logic  -- break aktivní
    );
end entity;

architecture Behavioral of pomodoro is
    type state_type is (IDLE, WORK, BREAK);
    signal state       : state_type := IDLE;
    signal next_state  : state_type := WORK;

    signal running     : boolean := false;

    signal minutes     : integer range 0 to 59 := 25;
    signal seconds     : integer range 0 to 59 := 0;

    signal tick_cnt    : integer := 0;
    constant tick_max  : integer := 1000;

    signal B_last : std_logic := '0';
    signal C_last : std_logic := '0';
    signal A_last : std_logic := '0';

    function to_bcd(n : integer) return std_logic_vector is
        variable tens : integer := n / 10;
        variable ones : integer := n mod 10;
        variable result : std_logic_vector(7 downto 0);
    begin
        result(7 downto 4) := std_logic_vector(to_unsigned(tens, 4));
        result(3 downto 0) := std_logic_vector(to_unsigned(ones, 4));
        return result;
    end function;

begin

    -- LED logika:
    LED16_B <= '1' when (not running and state = IDLE) else '0';
    LED16_R <= '1' when (running and state = WORK) else '0';
    LED16_G <= '1' when (running and state = BREAK) else '0';

    MM <= to_bcd(minutes);
    SS <= to_bcd(seconds);

    process (CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then

            -- RESET
            if A = '1' and A_last = '0' then
                state       <= IDLE;
                next_state  <= WORK;
                running     <= false;
                minutes     <= 25;
                seconds     <= 0;

            -- Start / Pause / Resume
            elsif B = '1' and B_last = '0' then
                if state = IDLE then
                    state   <= next_state;
                    running <= true;
                else
                    running <= not running;
                end if;

            -- Skip
            elsif C = '1' and C_last = '0' then
                if state = WORK then
                    state       <= IDLE;
                    next_state  <= BREAK;
                    minutes     <= 5;
                    seconds     <= 0;
                    running     <= false;
                elsif state = BREAK then
                    state       <= IDLE;
                    next_state  <= WORK;
                    minutes     <= 25;
                    seconds     <= 0;
                    running     <= false;
                end if;

            -- Tikání času
            elsif running then
                if tick_cnt = tick_max then
                    tick_cnt <= 0;
                    if minutes = 0 and seconds = 0 then
                        if state = WORK then
                            state      <= IDLE;
                            next_state <= BREAK;
                            minutes    <= 5;
                            seconds    <= 0;
                            running    <= false;
                        elsif state = BREAK then
                            state      <= IDLE;
                            next_state <= WORK;
                            minutes    <= 25;
                            seconds    <= 0;
                            running    <= false;
                        end if;
                    elsif seconds = 0 then
                        minutes <= minutes - 1;
                        seconds <= 59;
                    else
                        seconds <= seconds - 1;
                    end if;
                else
                    tick_cnt <= tick_cnt + 1;
                end if;
            end if;

            -- Uložení posledních stavů tlačítek
            A_last <= A;
            B_last <= B;
            C_last <= C;

        end if;
    end process;

end Behavioral;
