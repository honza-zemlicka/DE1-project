
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_debounce is
end entity;

architecture behavior of tb_debounce is
    signal clk     : std_logic := '0';
    signal btn_in  : std_logic := '0';
    signal btn_out : std_logic;
    signal edge    : std_logic;
    signal rise    : std_logic;
    signal fall    : std_logic;

    constant clk_period : time := 10 ns;

begin

    uut: entity work.debounce
        generic map (
            DB_TIME => 250 ns
        )
        port map (
            clk     => clk,
            btn_in  => btn_in,
            btn_out => btn_out,
            edge    => edge,
            rise    => rise,
            fall    => fall
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        wait for 100 ns;
        btn_in <= '1';   -- simulate button press
        
        wait for 30 ns;
        btn_in <= '0';   -- glitch
        
        wait for 30 ns;
        btn_in <= '1';   -- button stable
        
        wait for 300 ns;
        btn_in <= '0';   -- button release
        
        wait for 30 ns;
        btn_in <= '1';   -- glitch
        
        wait for 30 ns;
        btn_in <= '0';   -- stable release
        wait;
    end process;

end architecture;