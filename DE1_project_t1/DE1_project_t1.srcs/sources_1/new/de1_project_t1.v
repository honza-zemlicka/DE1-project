-------------------------------------------------
--! @brief VHDL example for basic logic gates.
--! @version 1.1
--! @copyright (c) 2019-2025 Tomas Fryza, MIT license
--!
--! The entity 'gates' defines an interface for implementing
--! 2-input AND, OR, and XOR gates. The architecture
--! implements the behavior of these gates with specified delays.
--!
--! Developed using TerosHDL, Vivado 2020.2, and EDA Playground.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity project is
    port (
            
    );
end entity project;

-------------------------------------------------

architecture behavioral of project is

signal is_running     : std_logic := '0';
signal is_study_phase : std_logic := '1';  -- 1 = studium, 0 = pauza
signal is_paused      : std_logic := '0';
signal timer          : integer range 0 to 1500 := 1500; -- 25 min

begin

       if timer > 0 then
                timer <= timer - 1;
            else
                -- fáze skon?ila, p?epnout
                is_study_phase <= not is_study_phase;
                if is_study_phase = '1' then
                    timer <= 5 * 60;
                else
                    timer <= 25 * 60;
                end if;
            end if;

end architecture behavioral;