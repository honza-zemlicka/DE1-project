
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
	port (
		CLK100MHZ : in  std_logic; -- Clock 10 ns
		BTNC      : in  std_logic;
		BTNL      : in  std_logic;
		BTNR      : in  std_logic;
		LED16_B   : out std_logic;
		LED16_R   : out std_logic;
		LED16_G   : out std_logic;
		CA        : out std_logic;
		CB        : out std_logic;
		CC        : out std_logic;
		CD        : out std_logic;
		CE        : out std_logic;
		CF        : out std_logic;
		CG        : out std_logic;
		DP        : out std_logic;
		AN        : out std_logic_vector(7 downto 0)
	);
end entity top_level;

architecture behavioral of top_level is

	component BinTo7seg is
		port (
			clk     : in  std_logic;
			MM      : in  std_logic_vector(7 downto 0);
			SS      : in  std_logic_vector(7 downto 0);
			seg     : out std_logic_vector(6 downto 0) := "0000000";
			POS_OUT : out std_logic_vector(7 downto 0) := "00000000"
		);
	end component;

	component pomodoro is
		port (
			clk100MHz : in  std_logic;
			A         : in  std_logic;
			B         : in  std_logic;
			C         : in  std_logic;
			MM        : out std_logic_vector(7 downto 0);
			SS        : out std_logic_vector(7 downto 0);
			LED16_B   : out std_logic;
			LED16_R   : out std_logic;
			LED16_G   : out std_logic
		);
	end component;

	component debounce is
		generic (
			DB_TIME : time := 25 ms
		);
		port (
			clk     : in  std_logic;
			btn_in  : in  std_logic;
			btn_out : out std_logic;
			edge    : out std_logic;
			rise    : out std_logic;
			fall    : out std_logic
		);
	end component debounce;

	-- signals for buttons
	signal SIG_BTNC : std_logic;
	signal SIG_BTNR : std_logic;
	signal SIG_BTNL : std_logic;

	-- Mode signal
	signal MM_sig : std_logic_vector(7 downto 0);
	signal SS_sig : std_logic_vector(7 downto 0);

begin

	B27S : BinTo7seg
	port map(
		clk     => CLK100MHZ,
		MM      => MM_sig,
		SS      => SS_sig,
		seg(6)  => CA,
		seg(5)  => CB,
		seg(4)  => CC,
		seg(3)  => CD,
		seg(2)  => CE,
		seg(1)  => CF,
		seg(0)  => CG,
		POS_OUT => AN
	);

	pomodoro_timer : pomodoro
	port map(
		clk100MHz => CLK100MHZ,
		A         => SIG_BTNL,
		B         => SIG_BTNC,
		C         => SIG_BTNR,
		MM        => MM_sig,
		SS        => SS_sig,
		LED16_B   => LED16_B,
		LED16_R   => LED16_R,
		LED16_G   => LED16_G
	);

	Debounce_BTNC : debounce
	port map(
		clk     => CLK100MHZ,
		btn_in  => BTNC,
		btn_out => SIG_BTNC,
		edge    => open,
		rise    => open,
		fall    => open
	);

	Debounce_BTNR : debounce
	port map(
		clk     => CLK100MHZ,
		btn_in  => BTNR,
		btn_out => SIG_BTNR,
		edge    => open,
		rise    => open,
		fall    => open
	);

	Debounce_BTNL : debounce
	port map(
		clk     => CLK100MHZ,
		btn_in  => BTNL,
		btn_out => SIG_BTNL,
		edge    => open,
		rise    => open,
		fall    => open
	);

	DP <= '1';

end architecture behavioral;