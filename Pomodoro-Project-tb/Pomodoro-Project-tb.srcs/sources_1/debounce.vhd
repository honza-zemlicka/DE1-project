
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
    generic (
        DB_TIME : time := 250 us  -- 25 ms before, for tb 250 us
    );
    port (
        clk     : in  std_logic;
        btn_in  : in  std_logic;
        btn_out : out std_logic := '0';
        edge    : out std_logic := '0';
        rise    : out std_logic := '0';
        fall    : out std_logic := '0'
    );
end entity debounce;

architecture v1 of debounce is
    constant CLK_PERIOD : time := 10 ns;
    constant MAX_COUNT : natural := integer(DB_TIME / CLK_PERIOD);
    constant SYNC_BITS : positive := 2;

    signal sync_buffer : std_logic_vector(SYNC_BITS - 1 downto 0) := (others => '0');
    alias sync_input : std_logic is sync_buffer(SYNC_BITS - 1);
    signal sig_count : natural range 0 to MAX_COUNT := 0;
    signal sig_btn : std_logic := '0';

begin
    process (clk)
    begin
        if rising_edge(clk) then
            -- synchronizace vstupu
            sync_buffer <= sync_buffer(SYNC_BITS - 2 downto 0) & btn_in;

            if sync_input /= sig_btn then
                if sig_count = MAX_COUNT then
                    -- změna potvrzena - nový stabilní stav
                    sig_btn <= sync_input;

                    edge <= '1';
                    rise <= (not sig_btn) and sync_input;
                    fall <= sig_btn and (not sync_input);

                    sig_count <= 0;
                else
                    sig_count <= sig_count + 1;

                    edge <= '0';
                    rise <= '0';
                    fall <= '0';
                end if;
            else
                sig_count <= 0;

                edge <= '0';
                rise <= '0';
                fall <= '0';
            end if;

            btn_out <= sig_btn;
        end if;
    end process;
end architecture v1;
