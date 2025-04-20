library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Testbench entity does not have any ports
entity top_level_tb is
end top_level_tb;

architecture behavior of top_level_tb is

    -- Component declaration for the unit under test (UUT)
    component top_level
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
    end component;

    -- Signals for connecting the UUT
    signal CLK100MHZ : STD_LOGIC := '0';
    signal CA : STD_LOGIC;
    signal CB : STD_LOGIC;
    signal CC : STD_LOGIC;
    signal CD : STD_LOGIC;
    signal CE : STD_LOGIC;
    signal CF : STD_LOGIC;
    signal CG : STD_LOGIC;
    signal DP : STD_LOGIC;
    signal AN : STD_LOGIC_VECTOR(7 downto 0);
    signal reset : STD_LOGIC := '0';  -- Signal to simulate reset

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: top_level
        Port map (
            CLK100MHZ => CLK100MHZ,
            CA => CA,
            CB => CB,
            CC => CC,
            CD => CD,
            CE => CE,
            CF => CF,
            CG => CG,
            DP => DP,
            AN => AN
        );

    -- Clock generation process
    clk_process : process
    begin
        -- Generate a 100 MHz clock (10 ns period)
        CLK100MHZ <= '0';
        wait for 5 ns;
        CLK100MHZ <= '1';
        wait for 5 ns;
    end process;

    -- Stimulus process to drive the inputs and monitor the outputs
    stim_proc: process
    begin
        -- Initialize signals
        reset <= '1'; -- Assert reset
        wait for 20 ns; -- Hold reset for 20 ns

        reset <= '0'; -- Deassert reset
        wait for 10 ns; -- Wait for a few cycles to allow the system to stabilize

        -- Sequence 1: Observe the 7-segment display behavior (multiplexing for digits 0-3)
        -- Test 1: Display 0
        -- AN_IN should select digit 0, and we expect the `num` signal to show "0000"
        -- Wait for 50 ns to observe the output after reset
        wait for 50 ns;

        -- Test 2: Display 1
        -- AN_IN should select digit 1, and we expect `num` to show "0001"
        wait for 50 ns;

        -- Test 3: Display 2
        -- AN_IN should select digit 2, and we expect `num` to show "0010"
        wait for 50 ns;

        -- Test 4: Display 3
        -- AN_IN should select digit 3, and we expect `num` to show "0011"
        wait for 50 ns;

        -- Test Sequence 2: Check reset functionality
        reset <= '1'; -- Assert reset
        wait for 20 ns; -- Wait for 20 ns
        reset <= '0'; -- Deassert reset
        wait for 20 ns; -- Wait for 20 ns to ensure system stabilizes after reset

        -- Test Sequence 3: Clock pulse and output behavior
        -- Let the system run and observe if the outputs change as expected with each clock pulse
        wait for 500 ns; -- Run for a few cycles

        -- End of the simulation
        assert false report "End of Simulation" severity note;
        wait;
    end process;

end behavior;