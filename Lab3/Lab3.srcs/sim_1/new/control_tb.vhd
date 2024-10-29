----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2024 02:37:23 PM
-- Design Name: 
-- Module Name: control_tb - Behavioral
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

entity control_tb is
--  Port ( );
end control_tb;

architecture Behavioral of control_tb is

  component control is
  port(
    clk, rst  : in  std_logic;
    start_btn : in  std_logic;
    enReg     : out std_logic_vector(8 downto 0);
    addr_in 	  : out std_logic_vector(9 downto 0);
    addr_out 	  : out std_logic_vector(9 downto 0);
    we        : out std_logic;
    out_mul   : out std_logic_vector(1 downto 0)
  );
  end component;

  signal clk_tb       : std_logic := '0';
  signal rst_tb       : std_logic := '0';
  signal start_btn_tb : std_logic := '0';
  signal enReg_tb     : std_logic_vector(8 downto 0);
  signal addr_in_tb   : std_logic_vector(9 downto 0);
  signal addr_out_tb  : std_logic_vector(9 downto 0);
  signal we_tb       : std_logic;
  signal out_mul_tb  : std_logic_vector(1 downto 0);

  constant clk_period : time := 10 ns; 

begin

  uut : control port map(
    clk          => clk_tb, 
    rst          => rst_tb,
    start_btn    => start_btn_tb,
    enReg        => enReg_tb,
	addr_in      => addr_in_tb,
	addr_out     => addr_out_tb,
	we           => we_tb,
	out_mul      => out_mul_tb
  );
  
  -- clock signal --
  clk_tb <= not clk_tb after clk_period/2;
  
  sim_proc : process
  begin
    wait for 100 ns;
    wait for 10 * clk_period;
  
    rst_tb <= '1';
    wait for 2* clk_period;
    rst_tb <= '0';
    wait for 4*clk_period;
    
    start_btn_tb <= '1';
    wait for 6*clk_period;
    start_btn_tb <= '0';
  
    wait;
  end process;
  
end Behavioral;
