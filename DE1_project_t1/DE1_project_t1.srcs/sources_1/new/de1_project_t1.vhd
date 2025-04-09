----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 02:24:47 PM
-- Design Name: 
-- Module Name: de1_project_t1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity de1_project_t1 is
    port (
          clk              : in    std_logic;  -- Main clock
          btn_reset        : in    std_logic;
          btn_skip         : in    std_logic;
          btn_start_pause  : in    std_logic;
          count            : out integer range 0 to 1500 := 1500
    );
end de1_project_t1;

architecture Behavioral of de1_project_t1 is

-- Signal declarations
signal is_running     : std_logic := '0';
signal is_study_phase : std_logic := '1';  -- 1 = study, 0 = break
signal is_paused      : std_logic := '0';
signal timer          : integer range 0 to 1500 := 1500; -- 25 minutesinteger range 0 to 1500 := 1500; -- 25 minutes

begin

   -- Process block
   process(clk)
   begin
      if rising_edge(clk) then
         -- RESET
         if btn_reset = '1' then
            is_running     <= '0';
            is_paused      <= '0';
            is_study_phase <= '1';
            timer          <= 25 * 60;  -- 25 minutes

         -- SKIP button
         elsif btn_skip = '1' then
            is_study_phase <= not is_study_phase;
            if is_study_phase = '1' then
                timer <= 5 * 60;  -- Break time (5 minutes)
            else
                timer <= 25 * 60; -- Study time (25 minutes)
            end if;

         -- START/PAUSE button
         elsif btn_start_pause = '1' then
            if is_running = '1' then
                is_running <= '0';
                is_paused <= '1';
            else
                is_running <= '1';
                is_paused <= '0';
            end if;

         -- Timer countdown
         elsif rising_edge(clk) then --and is_running = '1' then
            if timer > 0 then
                timer <= timer - 1;
                count <= timer;
            else
                -- Phase finished, switch to the other phase
                is_study_phase <= not is_study_phase;
                if is_study_phase = '1' then
                    timer <= 5 * 60;  -- Break time (5 minutes)
                else
                    timer <= 25 * 60; -- Study time (25 minutes)
                end if;
            end if;
         end if;  -- End of if rising_edge(clk)

      end if;  -- End of process(clk)

   end process;

end Behavioral;
