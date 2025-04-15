
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bin2seg is
    Port ( clear : in STD_LOGIC;
           bin : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end bin2seg;

architecture Behavioral of bin2seg is

begin

    process (clear, bin) is
    begin
        
        if (clear = '1') then
            seg <= "1111111";
        else
            case bin is
                when x"0" =>
                    seg <= "0000001";
                    
                when "0001" =>
                    seg <= "1001111";
                    
                when "0010" =>
                    seg <= "0010010";
                    
                when "0011" =>
                    seg <= "0000110";
                    
                when "0100" =>
                    seg <= "1001100";
                    
                when "0101" =>
                    seg <= "0100100";
                    
                when "0110" =>
                    seg <= "0100000";
                    
                when "0111" =>
                    seg <= "0001111";
                    
                when "1000" =>
                    seg <= "0000000";
                    
                when "1001" =>
                    seg <= "0000100";
                    
                when "1010" =>
                    seg <= "0001000";
                    
                when "1011" =>
                    seg <= "1100000";
                    
                when "1100" =>
                    seg <= "0110001";
                    
                when "1101" =>
                    seg <= "1000010";
                    
                when "1110" =>
                    seg <= "0110000";
                    
                when "1111" =>
                    seg <= "0111000";
                    
                when others =>
                    seg <= "0111000";
            end case;
        end if;
    
    end process;

end Behavioral;
