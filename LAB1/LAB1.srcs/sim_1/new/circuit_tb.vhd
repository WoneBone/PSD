----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2024 06:56:15 PM
-- Design Name: 
-- Module Name: circuit_tb - Behavioral
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

entity circuit_tb is
--  Port ( );
end circuit_tb;

architecture Behavioral of circuit_tb is
    component circuit
        port(
            clk, rst, ADD_SUB, LOAD, MULS, LOGIC_SHIFT, switch     : in std_logic;
            data_in                                        : in std_logic_vector(9 downto 0);
            display                                        : out std_logic_vector(15 downto 0));
            
    end component;

    signal clk  :std_logic := '0';
    signal reset  :std_logic := '0';
    signal  ADD_SUB, LOAD, MULS, LOGIC_SHIFT, switch     :  std_logic := '0';
	signal data 	: std_logic_vector(9 downto 0);

     -- Clock period definitions
    constant clk_period : time := 10 ns;

begin
	
	uut : circuit port map(
	clk => clk ,  
	rst => reset ,
	ADD_SUB => ADD_SUB,
	LOAD => LOAD,
	LOGIC_SHIFT => LOGIC_SHIFT,
	MULS=> MULS,
	switch => switch,
	data_in => data);
	
	 -- Clock definition
    clk <= not clk after clk_period/2;
    
    stim_proc : process
        begin
    -- hold reset state for 100 ns.
        wait for 100 ns;

        wait for clk_period*10;
        
        -- insert stimulus here
    -- note that input signals should never change at the positive edge of the clock
        reset <= '1' after 20 ns,
                 '0' after 40 ns;
        
        data <= "00" & X"04" after 40  * 2 ns,
                "00" & X"08" after 80  * 2 ns,
                "00" & X"0E" after 140  * 2 ns,
                "00" & X"02" after 320  * 2 ns,
                "00" & X"05" after 360  * 2 ns;
        
        
        LOAD <= '1' after 40  * 2 ns,
                '0' after 60  * 2 ns,
                '1' after 80  * 2 ns,
                '0' after 100  * 2 ns,
                '1' after 140  * 2 ns,
                '0' after 160  * 2 ns,
                '1' after 320  * 2 ns,
                '0' after 340  * 2 ns;
                
                 
        switch <= '1' after 80  * 2 ns,
                  '0' after 140  * 2 ns,
                  '1' after 200  * 2 ns,
                  '0' after 280  * 2 ns;  
        
        ADD_SUB <= '1' after 120  * 2 ns,
                   '0' after 140  * 2 ns,
                   '1' after 160  * 2 ns,
                   '0' after 180  * 2 ns,
                   '1' after 300  * 2 ns,
                   '0' after 320  * 2 ns;
                   
        LOGIC_SHIFT <= '1' after 180  * 2 ns,
                       '0' after 200  * 2 ns,
                       '1' after 220  * 2 ns,
                       '0' after 240  * 2 ns;  
        
        MULS <= '1' after 260  * 2 ns,
                '0' after 280  * 2 ns,
                '1' after 340  * 2 ns,
                '0' after 360  * 2 ns;
        wait;
        
    end process;
    
end Behavioral;
