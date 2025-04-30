
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_BinTo7seg is
end entity tb_BinTo7seg;

architecture testbench of tb_BinTo7seg is
    -- Signály pro propojení s testovaným modulem
    signal clk     : std_logic := '0';
    signal MM      : std_logic_vector(7 downto 0) := (others => '0');
    signal SS      : std_logic_vector(7 downto 0) := (others => '0');
    signal seg     : std_logic_vector(6 downto 0);
    signal POS_OUT : std_logic_vector(7 downto 0);

    -- Parametr pro generování hodin
    constant clk_period : time := 10 ns;
begin
    -- Instanciace testované jednotky (UUT = Unit Under Test)
    uut: entity work.BinTo7seg
        port map (
            clk     => clk,
            MM      => MM,
            SS      => SS,
            seg     => seg,
            POS_OUT => POS_OUT
        );

    -- Proces pro generování hodinového signálu
    clk_process : process
    begin
        while now < 800 ns loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    stim_proc : process
    begin
        -- Časová značka 0 ns
        MM <= "00000001";  -- 1
        SS <= "00000010";  -- 2
        wait for 400 ns;


        MM <= "00000011";  -- 3
        SS <= "00000100";  -- 4
        wait for 400 ns;

        wait;
    end process;

end architecture testbench;
