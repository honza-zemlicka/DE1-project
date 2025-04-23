library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4_seg is
    Port (
        EN          : in STD_LOGIC;
        mux_RST     : in STD_LOGIC;
        clk_1kHz    : in STD_LOGIC;  -- Zm?n?no z clk na zpomalený clock
        mux_out     : out STD_LOGIC_VECTOR (7 downto 0);
        anode_index : out STD_LOGIC_VECTOR (1 downto 0)
    );
end mux_4_seg;

architecture Behavioral of mux_4_seg is

    type state_type is (s0, s1, s2, s3);
    signal next_state, present_state : state_type;

begin

    process(clk_1kHz, mux_RST)
    begin
        if mux_RST = '1' then
            present_state <= s0;
        elsif rising_edge(clk_1kHz) then
            present_state <= next_state;
        end if;
    end process;

    process(present_state, EN)
    begin
        next_state <= present_state;

        case present_state is
            when s0 =>
                mux_out     <= "11110111";
                anode_index <= "00";
                if EN = '1' then
                    next_state <= s1;
                end if;

            when s1 =>
                mux_out     <= "11111011";
                anode_index <= "01";
                if EN = '1' then
                    next_state <= s2;
                end if;

            when s2 =>
                mux_out     <= "11111101";
                anode_index <= "10";
                if EN = '1' then
                    next_state <= s3;
                end if;

            when s3 =>
                mux_out     <= "11111110";
                anode_index <= "11";
                if EN = '1' then
                    next_state <= s0;
                end if;
        end case;
    end process;

end Behavioral;
