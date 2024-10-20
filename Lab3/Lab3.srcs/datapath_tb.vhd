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

entity datapath_tb is
--  Port ( );
end datapath_tb;

architecture Behavioral of datapath_tb is
	component datapath is
	  port (
		r11, r12, r21, r22, i11, i12, i21, i22 : in  std_logic_vector (11 downto 0);
		sel_reg1, sel_reg2, sel_reg3, sel_reg4, sel_reg5 : in std_logic_vector (1 downto 0);
		en_r1, en_r2, en_r3, en_r4,en_r5, en_r6, en_r7  : in  std_logic;
		clk, rst      : in  std_logic;
		reg1 			 : out std_logic_vector (31 downto 0));
	end component;


    signal clk  :std_logic := '0';
    signal reset  :std_logic := '0';
	signal sel_reg1, sel_reg2, sel_reg3, sel_reg4, sel_reg5 :   std_logic_vector (1 downto 0) := "11"; 
	signal en_r1, en_r2, en_r3, en_r4,en_r5, en_r6, en_r7  :    std_logic := '1';

     -- Clock period definitions
    constant clk_period : time := 20 ns;
	constant r11 std_logic_vector (11 downto 0):= x"000";
	constant r22 std_logic_vector (11 downto 0):= x"000";
	constant r12 std_logic_vector (11 downto 0):= x"001";
	constant r21 std_logic_vector (11 downto 0):= x"001";
	constant i11 std_logic_vector (11 downto 0):= x"001";
	constant i22 std_logic_vector (11 downto 0):= x"001";
	constant i21 std_logic_vector (11 downto 0):= x"000";
	constant i12 std_logic_vector (11 downto 0):= x"000";

begin
	
	
	uut : datapath port map(
	clk => clk ,  
	rst => reset,
	r11 => r11,
	r12 => r12,
	r21 => r21,
	r22 => r22,
	i11 => i11,
	i12 => i12,
	i21 => i21,
	i22 => i22,
	sel_reg1 =>sel_reg1,
	sel_reg2 =>sel_reg2,
	sel_reg3 =>sel_reg3,
	sel_reg4 =>sel_reg4,
	sel_reg5 =>sel_reg5,
	en_r1 => en r1,
	en_r2 => en r2,
	en_r3 => en r3,
	en_r4 => en r4,
	en_r5 => en r5,
	en_r6 => en r6,
	en_r7 => en r7,

	);
	
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
