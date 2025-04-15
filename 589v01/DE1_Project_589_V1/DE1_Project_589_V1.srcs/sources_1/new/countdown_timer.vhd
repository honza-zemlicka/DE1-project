

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity countdown_timer is
    port( clk         : in std_logic;
          pulse_1hz   : in std_logic;   -- nový vstup
          rst_counter : in std_logic;
          min_tens    : out std_logic_vector(3 downto 0);
          min_units   : out std_logic_vector(3 downto 0);
          sec_tens    : out std_logic_vector(3 downto 0);
          sec_units   : out std_logic_vector(3 downto 0));
end entity;

architecture behavioral of countdown_timer is

signal sec_count : integer range 0 to 59 := 0;
signal min_count : integer range 0 to 59 := 0;

begin

    -- Sekundy
    process(clk, rst_counter)
    begin
        if rst_counter = '1' then
            sec_count <= 0;
        elsif rising_edge(clk) then
            if pulse_1hz = '1' then
                if sec_count = 0 then
                    sec_count <= 59;
                else
                    sec_count <= sec_count - 1;
                end if;
            end if;
        end if;
    end process;

    -- Minuty
    process(clk, rst_counter)
    begin
        if rst_counter = '1' then
            min_count <= 0;
        elsif rising_edge(clk) then
            if pulse_1hz = '1' and sec_count = 0 then
                if min_count /= 0 then
                    min_count <= min_count - 1;
                end if;
            end if;
        end if;
    end process;

    -- Výstupy pro 7segmentovky
    sec_tens  <= std_logic_vector(to_unsigned(sec_count / 10, 4));
    sec_units <= std_logic_vector(to_unsigned(sec_count mod 10, 4));
    min_tens  <= std_logic_vector(to_unsigned(min_count / 10, 4));
    min_units <= std_logic_vector(to_unsigned(min_count mod 10, 4));

end architecture;
