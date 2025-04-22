library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider_1kHz is
    Port (
        clk_in     : in STD_LOGIC;        -- Původní hodinový signál, např. 50 MHz
        reset      : in STD_LOGIC;
        clk_out_1k : out STD_LOGIC        -- Výstupní "pomalý" clock (~1 kHz)
    );
end clock_divider_1kHz;

architecture Behavioral of clock_divider_1kHz is
    signal counter : unsigned(15 downto 0) := (others => '0');
    signal clk_out : STD_LOGIC := '0';
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                counter <= (others => '0');
                clk_out <= '0';
            elsif counter = 9 then   -- na desku 99 999 (100MHz / 100_000 = 1kHz) (v simulaci méně)
                counter <= (others => '0');
                clk_out <= not clk_out;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out_1k <= clk_out;

end Behavioral;
