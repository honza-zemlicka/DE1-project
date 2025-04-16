

library ieee;
use ieee.std_logic_1164.all;

entity clock_en is
  generic (
    n_periods : integer := 100000000 -- = 1 Hz při 100 MHz
  );
  port (
    clk   : in  std_logic; -- hlavní hodinový signál
    rst   : in  std_logic; -- aktivní na '1'
    pulse : out std_logic  -- výstupní pulz, aktivní 1 cyklus
  );
end entity clock_en;

architecture behavioral of clock_en is

  signal sig_count : integer range 0 to n_periods - 1 := 0;

begin

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        sig_count <= 0;
      elsif sig_count < n_periods - 1 then
        sig_count <= sig_count + 1;
      else
        sig_count <= 0;
      end if;
    end if;
  end process;

  pulse <= '1' when sig_count = n_periods - 1 else '0';

end architecture behavioral;
