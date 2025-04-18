library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity countdown_timer is
    Port ( 
        clk         : in std_logic;
        rst         : in std_logic;
        run_timer   : in std_logic;
        time_select : in std_logic_vector(1 downto 0);
        minutes     : out std_logic_vector(5 downto 0);
        seconds     : out std_logic_vector(5 downto 0);
        done        : out std_logic
    );
end countdown_timer;

architecture Behavioral of countdown_timer is
    signal minutes_reg : unsigned(5 downto 0) := to_unsigned(25, 6);
    signal seconds_reg : unsigned(5 downto 0) := (others => '0');
    signal clk_div     : unsigned(25 downto 0) := (others => '0');
    signal enable      : std_logic := '0';
    signal preset_minutes : unsigned(5 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or run_timer = '0' then
                case time_select is
                    when "00" => preset_minutes <= to_unsigned(25, 6);
                    when "01" => preset_minutes <= to_unsigned(5, 6);
                    when "10" => preset_minutes <= to_unsigned(15, 6);
                    when others => preset_minutes <= to_unsigned(25, 6);
                end case;
                minutes_reg <= preset_minutes;
                seconds_reg <= (others => '0');
                enable <= '0';
                done <= '0';
            else
                if clk_div = 99999999 then -- 1Hz
                    clk_div <= (others => '0');
                    enable <= '1';
                else
                    clk_div <= clk_div + 1;
                    enable <= '0';
                end if;

                if enable = '1' then
                    if minutes_reg = 0 and seconds_reg = 0 then
                        done <= '1';
                    else
                        done <= '0';
                        if seconds_reg = 0 then
                            if minutes_reg /= 0 then
                                minutes_reg <= minutes_reg - 1;
                                seconds_reg <= to_unsigned(59, 6);
                            end if;
                        else
                            seconds_reg <= seconds_reg - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    minutes <= std_logic_vector(minutes_reg);
    seconds <= std_logic_vector(seconds_reg);

end Behavioral;