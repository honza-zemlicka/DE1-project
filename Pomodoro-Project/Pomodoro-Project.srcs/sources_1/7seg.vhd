
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BinTo7seg is
	port (
		clk     : in  std_logic;
		MM      : in  std_logic_vector(7 downto 0);
		SS      : in  std_logic_vector(7 downto 0);
		seg     : out std_logic_vector(6 downto 0) := "0000000";
		POS_OUT : out std_logic_vector(7 downto 0) := "00000000"
	);
end entity BinTo7seg;

architecture behavioral of BinTo7seg is
	signal digit0 : integer range 0 to 9;

	signal POS_reg : unsigned(2 downto 0) := (others => '0');

	constant MILISECOND_TC : natural := 25_000;

	signal clk_counter : natural range 0 to MILISECOND_TC - 1 := 0;
	signal milisecond_tick : std_logic := '0';

begin

	-- tick generating process
	tick_gen : process (clk)
	begin
		if rising_edge(clk) then
			if clk_counter = MILISECOND_TC - 1 then
				clk_counter <= 0;
				milisecond_tick <= '1'; -- Generate tick
			else
				clk_counter <= clk_counter + 1;
				milisecond_tick <= '0'; -- Ensure tick remains low
			end if;
		end if;
	end process tick_gen;

	Position_counter : process (clk)
	begin
		if rising_edge(clk) then 
			if milisecond_tick = '1' then 
				if POS_reg = 3 then
					POS_reg <= (others => '0');
				else
					POS_reg <= POS_reg + 1;
				end if;
			end if;
		end if;
	end process Position_counter;

	digit_sep : process (clk)
	begin
		if rising_edge(clk) then
			case TO_INTEGER(POS_reg) is
				when 3 => digit0 <= to_integer(unsigned(MM)) / 10;
				when 2 => digit0 <= to_integer(unsigned(MM)) mod 10;
				when 1 => digit0 <= to_integer(unsigned(SS)) / 10;
				when 0 => digit0 <= to_integer(unsigned(SS)) mod 10;
				when others => digit0 <= 0;
			end case;
		end if;
	end process digit_sep;
	Pos_converter : process (clk)
	begin
		if rising_edge(clk) then
			case TO_INTEGER(POS_reg) is
				when 3 => POS_OUT <= "11011111";
				when 2 => POS_OUT <= "11101111";
				when 1 => POS_OUT <= "11110111";
				when 0 => POS_OUT <= "11111011";
				when others => POS_OUT <= "11111111"; 
			end case;
		end if;
	end process Pos_converter;

	BinToSeg : process (clk)
	begin
		-- code that lights individual segments
		-- make it synchronous
		if rising_edge(clk) then
			case digit0 is -- change the conditions to unsigned
				when 0 => -- x"0" means "0000" in hex
					seg <= "0000001";
				when 1 => -- Display 1
					seg <= "1001111";
				when 2 => -- Display 2
					seg <= "0010010";
				when 3 => -- Display 3
					seg <= "0000110";
				when 4 => -- Display 4
					seg <= "1001100";
				when 5 => -- Display 5
					seg <= "0100100";
				when 6 => -- Display 6
					seg <= "0100000";
				when 7 => -- Display 7
					seg <= "0001111";
				when 8 => -- Display 8
					seg <= "0000000";
				when 9 => -- Display 9
					seg <= "0000100";
				when others =>
					seg <= "0111000";
			end case;
		end if;
	end process;

end architecture behavioral;
