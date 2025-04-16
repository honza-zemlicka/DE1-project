
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity countdown_timer is
    port( clk : in std_logic;
          rst_counter : in std_logic;
          min_tens    : out std_logic_vector(3 downto 0);
          min_units   : out std_logic_vector(3 downto 0);
          sec_tens    : out std_logic_vector(3 downto 0);
          sec_units   : out std_logic_vector(3 downto 0));
end entity;

architecture behavioral of countdown_timer is

signal t_1s : std_logic := '0';
signal sec_count : integer range 0 to 59 := 0; -- zadat hodnotu
signal min_count : integer range 0 to 59 := 0; -- zadat hodnotu
signal clk_count : integer range 0 to 100_000_000-1 := 0;

begin

    process(clk, rst_counter)
    begin
        if rst_counter = '1' then
            clk_count <= 0;
            t_1s <= '0';
        elsif rising_edge(clk) then
            if clk_count = 100_000_000 - 1 then
                clk_count <= 0;
                t_1s <= '1';
            else
                clk_count <= clk_count + 1;
                t_1s <= '0';
            end if;
        end if;
    end process;

    process(clk, rst_counter)
    begin
        if rst_counter = '1' then
            sec_count <= 0;
        elsif rising_edge(clk) then
            if t_1s = '1' then
                if sec_count = 0 then
                    sec_count <= 59;
                else
                    sec_count < sec_count - 1;
                end if;
            end if;
        end if;
    end process;

    process(clk, rst_counter)
    begin
        if rst_counter = '1'then
            min_count < 0;
        elsif rising_edge(clk) then
            if t_1s = '1' and sec_count = 0 then
                if min_count /= 0 then
                    min_count <= min_count - 1;
                end if;
            end if;
        end if;
    end process;

    sec_tens  <= std_logic_vector(to_unsigned(sec_count / 10, 4));
    sec_units <= std_logic_vector(to_unsigned(sec_count mod 10

    min_tens  <= std_logic_vector(to_unsigned(min_count / 10, 4));
    min_units <= std_logic_vector(to_unsigned(min_count mod 10, 4));
    