

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4_seg is
    Port ( EN : in STD_LOGIC;
           mux_RST : in STD_LOGIC;
           clk : in STD_LOGIC;
           mux_out : out STD_LOGIC_VECTOR (3 downto 0));
end mux_4_seg;

architecture Behavioral of mux_4_seg is

type state_type is (s0, s1, s2, s3);
signal next_state, present_state : state_type;

begin

process(clk, mux_RST)
    begin
        if mux_RST = '1' then
            present_state <= s0;
        elsif rising_edge(clk) then
            present_state <= next_state;
        end if;
    end process;

    process(present_state, EN)
    begin
    next_state <= present_state;

    case present_state is

        when s0 =>
            mux_out <= "11110111";
        if EN = '1' then
            next_state <= s1;
        end if;

        when s1 =>
            mux_out <= "11111011";
        if EN = '1' then
            next_state <= s2;
        end if;

        when s2 =>
            mux_out <= "11111101";
        if EN = '1' then
            next_state <= s3;
        end if;

        when s3 =>
            mux_out <= "11111110";
        if EN = '1' then
            next_state <= s0;
        end if;


    end case;

end process;

end Behavioral;






