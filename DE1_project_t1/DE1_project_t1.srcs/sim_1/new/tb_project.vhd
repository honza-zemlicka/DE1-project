----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 02:24:47 PM
-- Design Name: 
-- Module Name: de1_project_t1_tb
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench for de1_project_t1
-- 
-- Dependencies: de1_project_t1.vhdl
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity de1_project_t1_tb is
end de1_project_t1_tb;

architecture behavior of de1_project_t1_tb is

    -- Component declaration for the Unit Under Test (UUT)
    component de1_project_t1
        port (
            clk              : in    std_logic;
            btn_reset        : in    std_logic;
            btn_skip         : in    std_logic;
            btn_start_pause  : in    std_logic;
            count            : out integer range 0 to 1500 := 1500
        );
    end component;

    -- Signals to connect to the UUT
    signal clk              : std_logic := '0';
    signal btn_reset        : std_logic := '0';
    signal btn_skip         : std_logic := '0';
    signal btn_start_pause  : std_logic := '0';
    signal count            : integer range 0 to 1500 := 1500; -- 25 minutes

    -- Clock period (50 MHz clock, so 20 ns period)
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: de1_project_t1
        port map (
            clk              => clk,
            btn_reset        => btn_reset,
            btn_skip         => btn_skip,
            btn_start_pause  => btn_start_pause,
            count            => count
        );

    -- Clock generation process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Reset the system
        btn_reset <= '1';
        wait for 40 ns;
        btn_reset <= '0';

        -- Start the study phase
        btn_start_pause <= '1'; -- Start/pause button pressed
        wait for 40 ns;
        btn_start_pause <= '0';

        -- Simulate countdown for study time
        wait for 1000 ns; -- Wait for a period (example time for the study phase)

        -- Skip to break phase
        btn_skip <= '1'; -- Skip button pressed
        wait for 40 ns;
        btn_skip <= '0';

        -- Simulate countdown for break time
        wait for 1000 ns; -- Wait for a period (example time for the break phase)

        -- Resume study phase
        btn_skip <= '1'; -- Skip button pressed again
        wait for 40 ns;
        btn_skip <= '0';

        -- Simulate another cycle
        wait for 1000 ns;

        -- End of simulation
        wait;
    end process;

end behavior;
