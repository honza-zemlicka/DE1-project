

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port ( CLK100MHZ : in STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end top_level;

architecture Behavioral of top_level is

signal AN_IN : std_logic_vector(7 downto 0);
signal num : std_logic_vector(3 downto 0);

component bin2seg is
    port(  clear : in std_logic;
           bin : in std_logic_vector(3 downto 0);
           seg : out std_logic_vector(6 downto 0));
end component;

component mux_4_seg_v1_1 is
    port(  EN : in STD_LOGIC;
           mux_RST : in STD_LOGIC;
           clk : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end component;

begin

MUX : mux_4_seg_v1_1
port map(  EN      => '1',
           mux_RST => '0',
           clk     => CLK100MHZ,
           mux_out => AN_IN);

DISP : bin2seg
port map(  clear => open, --'0'
           bin => num,
           seg(6) => CA,
           seg(5) => CB,
           seg(4) => CC,
           seg(3) => CD,
           seg(2) => CE,
           seg(1) => CF,
           seg(0) => CG);

DP <= '1';

with AN_IN select
num <= "0000" when "11110111", -- cislo 0
        "0001" when "11111011", -- cislo 1
        "0010" when "11111101", -- cislo 2
        "0011" when others; -- cislo 3

end behavioral;
