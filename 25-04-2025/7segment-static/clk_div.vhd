library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clk_div is
    Port (
        clk     : in  STD_LOGIC;    -- 100 MHz vstupní hodinový signál
        clk_out : out STD_LOGIC     -- výstupní 1 kHz signál
    );
end clk_div;

architecture Behavioral of clk_div is
    constant DIVISOR : integer := 50000;  -- polovina periody pro 1 kHz
    signal counter   : integer range 0 to DIVISOR - 1 := 0;
    signal clk_reg   : STD_LOGIC := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if counter = DIVISOR - 1 then
                counter <= 0;
                clk_reg <= not clk_reg;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_reg;

end Behavioral;
