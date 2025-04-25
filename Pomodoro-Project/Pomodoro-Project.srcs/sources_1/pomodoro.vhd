
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pomodoro is
	port (
		CLK100MHZ : in  std_logic;
		A         : in  std_logic; -- reset
		B         : in  std_logic; -- start/pause/resume
		C         : in  std_logic; -- skip
		MM        : out std_logic_vector(7 downto 0);
		SS        : out std_logic_vector(7 downto 0);
		LED16_B   : out std_logic; -- idle
		LED16_R   : out std_logic; -- work
		LED16_G   : out std_logic -- break
	);
end entity pomodoro;

architecture Behavioral of pomodoro is

	type state_type is (idle, work, short_break, long_break);
	signal state : state_type := idle;
	signal next_state : state_type := work;

	constant WORK_MINUTES : integer := 25;
	constant SHORT_BREAK_MINUTES : integer := 5;
	constant LONG_BREAK_MINUTES : integer := 15;

	signal s_minuty : integer range 0 to 59 := 0;
	signal s_sekundy : integer range 0 to 59 := 0;

	signal preview_minutes : integer range 0 to 59 := WORK_MINUTES;

	signal work_counter : integer range 0 to 3 := 0;

	constant SECOND_TC : natural := 5_000_000; -- real 1Hz time is 100_000_000, for presentation purposes use 5_000_000
	signal count : natural range 0 to SECOND_TC - 1 := 0;
	signal second_tick : std_logic := '0';

	signal A_prev, B_prev, C_prev : std_logic := '0';

	signal is_running : std_logic := '0';

begin

	-- Tik 1Hz
	tick_gen_proc : process (CLK100MHZ)
	begin
		if rising_edge(CLK100MHZ) then
			if count = SECOND_TC - 1 then
				count <= 0;
				second_tick <= '1';
			else
				count <= count + 1;
				second_tick <= '0';
			end if;
		end if;
	end process;

	-- Logika
	Clock : process (CLK100MHZ)
	begin
		if rising_edge(CLK100MHZ) then
			A_prev <= A;
			B_prev <= B;
			C_prev <= C;

			-- RESET (BTNL)
			if A = '1' and A_prev = '0' then
				state <= idle;
				is_running <= '0';
				work_counter <= 0;
				next_state <= work;
			end if;

			-- SKIP (BTNR)
			if C = '1' and C_prev = '0' then
				if state /= idle then
					case state is
						when work =>
							if work_counter = 3 then
								next_state <= long_break;
								work_counter <= 0;
							else
								next_state <= short_break;
								work_counter <= work_counter + 1;
							end if;
						when short_break | long_break =>
							next_state <= work;
						when others => null;
					end case;
					state <= idle;
					is_running <= '0';
				end if;
			end if;

			-- START / PAUSE / RESUME (BTNC)
			if B = '1' and B_prev = '0' then
				if state = idle then
					state <= next_state;
					is_running <= '1';

					case next_state is
						when work =>
							s_minuty <= WORK_MINUTES;
						when short_break =>
							s_minuty <= SHORT_BREAK_MINUTES;
						when long_break =>
							s_minuty <= LONG_BREAK_MINUTES;
						when others =>
							s_minuty <= 0;
					end case;

					s_sekundy <= 0;
				else
					is_running <= not is_running;
				end if;
			end if;

			-- Countdown
			if second_tick = '1' and is_running = '1' then
				if s_minuty = 0 and s_sekundy = 0 then
					case state is
						when work =>
							if work_counter = 2 then
								next_state <= long_break;
								work_counter <= 0;
							else
								next_state <= short_break;
								work_counter <= work_counter + 1;
							end if;
						when short_break | long_break =>
							next_state <= work;
						when others => null;
					end case;
					state <= idle;
					is_running <= '0';
				else
					if s_sekundy = 0 then
						s_sekundy <= 59;
						s_minuty <= s_minuty - 1;
					else
						s_sekundy <= s_sekundy - 1;
					end if;
				end if;
			end if;

			-- Preview (when IDLE)
			if state = idle then
				case next_state is
					when work => preview_minutes <= WORK_MINUTES;
					when short_break => preview_minutes <= SHORT_BREAK_MINUTES;
					when long_break => preview_minutes <= LONG_BREAK_MINUTES;
					when others => preview_minutes <= 0;
				end case;
			end if;
		end if;
	end process;

	-- LED outputs
	LED16_R <= '1' when state = work and is_running = '1' else '0';
	LED16_G <= '1' when (state = short_break or state = long_break) and is_running = '1' else '0';
	LED16_B <= '1' when state = idle else '0';

	-- Time outputs
	MM <= std_logic_vector(to_unsigned(
		preview_minutes, 8)) when state = idle else
		std_logic_vector(to_unsigned(s_minuty, 8));

	SS <= (others => '0') when state = idle else
		std_logic_vector(to_unsigned(s_sekundy, 8));

end Behavioral;
