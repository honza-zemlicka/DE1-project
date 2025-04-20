library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4_seg is
    Port ( EN : in STD_LOGIC;
           mux_RST : in STD_LOGIC;
           clk : in STD_LOGIC;
           mux_out : out STD_LOGIC_VECTOR (7 downto 0));  -- 8-bit output
end mux_4_seg;

architecture Behavioral of mux_4_seg is

type state_type is (s0, s1, s2, s3);
signal next_state, present_state : state_type;

begin

-- Clock and reset process
process(clk, mux_RST)
    begin
        if mux_RST = '1' then
            present_state <= s0;
        elsif rising_edge(clk) then
            present_state <= next_state;
        end if;
    end process;

-- State machine process to control output
process(present_state, EN)
    begin
        next_state <= present_state;  -- Default, hold state if EN is not '1'

        case present_state is
            when s0 =>
                mux_out <= "11110111";  -- 8-bit value for display 0
                if EN = '1' then
                    next_state <= s1;  -- Move to next state
                end if;

            when s1 =>
                mux_out <= "11111011";  -- 8-bit value for display 1
                if EN = '1' then
                    next_state <= s2;  -- Move to next state
                end if;

            when s2 =>
                mux_out <= "11111101";  -- 8-bit value for display 2
                if EN = '1' then
                    next_state <= s3;  -- Move to next state
                end if;

            when s3 =>
                mux_out <= "11111110";  -- 8-bit value for display 3
                if EN = '1' then
                    next_state <= s0;  -- Move back to the initial state
                end if;

        end case;
    end process;

end Behavioral;
