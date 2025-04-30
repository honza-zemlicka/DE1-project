
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_level is
end entity tb_top_level;

architecture tb of tb_top_level is
    signal CLK100MHZ : std_logic := '0';
    signal BTNC      : std_logic := '0';
    signal BTNL      : std_logic := '0';
    signal BTNR      : std_logic := '0';
    signal LED16_B   : std_logic;
    signal LED16_R   : std_logic;
    signal LED16_G   : std_logic;
    signal CA, CB, CC, CD, CE, CF, CG, DP : std_logic;
    signal AN        : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 50 ps;

begin
    uut: entity work.top_level
        port map (
            CLK100MHZ => CLK100MHZ,
            BTNC      => BTNC,
            BTNL      => BTNL,
            BTNR      => BTNR,
            LED16_B   => LED16_B,
            LED16_R   => LED16_R,
            LED16_G   => LED16_G,
            CA        => CA,
            CB        => CB,
            CC        => CC,
            CD        => CD,
            CE        => CE,
            CF        => CF,
            CG        => CG,
            DP        => DP,
            AN        => AN
        );

    clk_process : process
    begin
        while now < 4 ms loop
            CLK100MHZ <= '0';
            wait for CLK_PERIOD/2;
            CLK100MHZ <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    stimulus_process : process
    begin
        wait for 20 us;
    
        -- (start)
        BTNC <= '1';  
        wait for 300 us;
        BTNC <= '0';
    
        wait for 200 us;
    
        -- (pause)
        BTNC <= '1';   
        wait for 300 us;
        BTNC <= '0';  
        wait for 200 us;
        
        -- (resume)
        BTNC <= '1';   
        wait for 300 us;
        BTNC <= '0';   
    
        wait for 200 us;
    
        -- (skip)
        BTNR <= '1';    
        wait for 300 us;
        BTNR <= '0';    
    
        wait for 200 us;
    
        -- (resume)
        BTNC <= '1';   
        wait for 300 us;
        BTNC <= '0';    
    
        wait for 200 us;
    
        -- (reset)
        BTNL <= '1';   
        wait for 300 us;
        BTNL <= '0';  
 
        -- (resume)
        BTNC <= '1'; 
        wait for 300 us;
        BTNC <= '0';   
    
        wait for 200 us;
        
        wait;
    end process;
    
end architecture tb;
