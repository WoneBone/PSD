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
	component circuit is
		port(
		clk, rst    : in std_logic;
		done 		: out std_logic
	);
	end component;


    signal clk  :std_logic := '0';
    signal reset  :std_logic := '0';

     -- Clock period definitions
    constant clk_period : time := 10 ns;

begin
	
	uut : circuit port map(
	clk => clk ,  
	rst => reset);
	
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
        
        wait;
        
    end process;
    
end Behavioral;
