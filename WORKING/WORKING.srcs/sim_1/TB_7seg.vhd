library ieee;
use ieee.std_logic_1164.all;

entity tb_BinTo7seg is
end tb_BinTo7seg;

architecture tb of tb_BinTo7seg is

    component BinTo7seg
        port (
            clk     : in std_logic;
            MM      : in std_logic_vector (7 downto 0);
            SS      : in std_logic_vector (7 downto 0);
            seg     : out std_logic_vector (6 downto 0);
            POS_OUT : out std_logic_vector (7 downto 0)
        );
    end component;

    signal clk     : std_logic;
    signal MM      : std_logic_vector (7 downto 0);
    signal SS      : std_logic_vector (7 downto 0);
    signal seg     : std_logic_vector (6 downto 0);
    signal POS_OUT : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : BinTo7seg
        port map (
            clk     => clk,
            MM      => MM,
            SS      => SS,
            seg     => seg,
            POS_OUT => POS_OUT
        );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod / 2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    -- Stimuli
    stimuli : process
    begin
        MM <= (others => '0');
        SS <= (others => '0');

        wait for 100 ns;

        -- Nastavíme např. 25 minut a 45 sekund
        MM <= "00011001"; -- 25
        SS <= "00101101"; -- 45

        wait for 2 ms;

        -- Přepneme na jinou hodnotu
        MM <= "00000011"; -- 3
        SS <= "00001010"; -- 10

        wait for 2 ms;

        -- A pak vypneme simulaci
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Konfigurace pro simulátor
configuration cfg_tb_BinTo7seg of tb_BinTo7seg is
    for tb
    end for;
end cfg_tb_BinTo7seg;
