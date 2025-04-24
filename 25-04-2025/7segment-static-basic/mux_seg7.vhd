library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_seg7 is
    Port (
        clk   : in  STD_LOGIC;
        s_out : out STD_LOGIC_VECTOR (7 downto 0)
    );
end mux_seg7;

architecture Behavioral of mux_seg7 is

type state_type is (s0, s1, s2, s3);
signal present_state : state_type := s0;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            case present_state is
                when s0 =>
                    s_out <= "11110111";
                    present_state <= s1;
                when s1 =>
                    s_out <= "11111011";
                    present_state <= s2;
                when s2 =>
                    s_out <= "11111101";
                    present_state <= s3;
                when s3 =>
                    s_out <= "11111110";
                    present_state <= s0;
            end case;
        end if;
    end process;

end Behavioral;
