library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin2seg is
    port ( 
          bin : in STD_LOGIC_VECTOR (3 downto 0);
          seg : out STD_LOGIC_VECTOR (6 downto 0)
    );
end bin2seg;

architecture Behavioral of bin2seg is

begin

    process (bin) is
    begin   
            case bin is
                when "0000" => -- 0
                    seg <= "0000001";
                    
                when "0001" => -- 1
                    seg <= "1001111";
                    
                when "0010" => -- 2
                    seg <= "0010010";
                    
                when "0011" => -- 3
                    seg <= "0000110";
                    
                when "0100" => -- 4
                    seg <= "1001100";
                    
                when "0101" => -- 5
                    seg <= "0100100";
                    
                when "0110" => -- 6
                    seg <= "0100000";
                    
                when "0111" => -- 7
                    seg <= "0001111";
                    
                when "1000" => -- 8
                    seg <= "0000000";
                    
                when "1001" => -- 9
                    seg <= "0000100";
                    
                when "1010" => -- A
                    seg <= "0001000";
                    
                when "1011" => -- B
                    seg <= "1100000";
                    
                when "1100" => -- C
                    seg <= "0110001";
                    
                when "1101" => -- D
                    seg <= "1000010";
                    
                when "1110" => -- E
                    seg <= "0110000";
                    
                when "1111" => -- F
                    seg <= "0111000";
                    
                when others =>
                    seg <= "0111000";
            end case;
    end process;

end Behavioral;
