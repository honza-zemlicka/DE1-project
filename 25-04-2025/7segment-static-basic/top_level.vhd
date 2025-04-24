
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

entity clk_div is
    Port (clk     : in  STD_LOGIC;    -- 100 MHz vstupní hodinový signál
          clk_out : out STD_LOGIC);     -- výstupní 1 kHz signál
end clk_div;

entity mux_seg7 is
    Port ( clk : in STD_LOGIC;
           s_out : out STD_LOGIC_VECTOR (7 downto 0));
end mux_seg7;

entity bin2seg is
    Port ( clear : in STD_LOGIC;
           bin : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end bin2seg;

architecture Behavioral of top_level is

signal num : std_logic_vector(3 downto 0);
signal an_in : std_logic_vector(7 downto 0);
signal clk_1khz : std_logic;

begin

cnt : clk_div
    port map (  clk => CLK100MHZ,
                clk_out => clk_1khz);
                
mux : mux_seg7
    port map (  clk => clk_1khz,
                s_out => an_in);
                
disp: bin2seg
    port map(clear => '0',
             bin => num,
             seg(6) => CA,
             seg(5) => CB,
             seg(4) => CC,
             seg(3) => CD,
             seg(2) => CE,
             seg(1) => CF,
             seg(0) => CG);

AN <= an_in; 
DP <= '1';
             
    with an_in select
num <= "0001" when "11110111", -- cislice 1
        "0010" when "11111011", -- cislice 2
        "0011" when "11111101", -- cislice 3
        "0100" when others; -- cislice 4
              
end Behavioral;
