library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mode_control is
    port( clk : in std_logic;
          rst_mode : in std_logic;
          countdown_done : in std_logic;
          start_btn : in std_logic;
          load_time : in std_logic;
          min_out : out integer range 0 to 59;
          sec_out : out integer range 0 to 59);
end entity;

architecture behavioral of mode_control is
type mode_type is (POMODORO, SHORT_BREAK, LONG_BREAK);
signal current_mode : mode_type := POMODORO;
signal pomodoro_count : integer range 0 to 3 := 0;
signal waiting_for_start : std_logic := '1';
signal skip : std_logic := '0';

begin
    process(clk, rst)
    begin
        if rst = '1' then
            current_mode <= POMODORO;
            pomodoro_count <= 0;
            waiting_for_start <= '1';
            min_out <= 1;
            sec_out <= 5;
        elsif rising_edge(clk) then
            
            if start_btn = '1' and waiting_for_start = '0' then
                skip <= '1';
            end if;

            if (countdown_done = '1' and waiting_for_start = '0') or skip = '1' then
                waiting_for_start <= '1';
                skip <= '0';
                
                case current_mode is
                    when POMODORO =>
                        if pomodoro_count = 3 then
                            current_mode <= LONG_BREAK;
                            pomodoro_count <= 0;
                        else
                            current_mode <= SHORT_BREAK;
                            pomodoro_count <= pomodoro_count + 1;
                        end if;
                    when SHORT_BREAK | LONG_BREAK =>
                        current_mode <= POMODORO;
                end case;
            end if;
            if start_btn = '1' and waiting_for_start = '1' then
                waiting_for_start <= '0';
                load_time <= '1';
                case current_mode is
                    when POMODORO =>
                        min_out = 1;
                        sec_out = 5;
                    when SHORT_BREAK =>
                        min_out = 0;
                        sec_out = 10;
                    when LONG_BREAK =>
                        min_out = 0;
                        sec_out = 5;
                end case;
            else
                load_time <= '0';
            end if;
        end if;
    end process;
end architecture;
