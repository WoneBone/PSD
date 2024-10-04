----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2024 06:02:45 PM
-- Design Name: 
-- Module Name: circuit - Behavioral
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

entity circuit is
    port(
        clk, rst    : in std_logic;
        done, we 		: out std_logic;
        addr 	:out std_logic_vector(9 downto 0);
        dataOUT : out  std_logic_vector(31 downto 0)
        );
end circuit;

architecture Behavioral of circuit is
    
	component control 
		port (
		clk, rst : in  std_logic;
		sel_reg1,sel_reg2,sel_reg3 : out std_logic_vector(1 downto 0);
		sel_reg5 : out std_logic_vector(1 downto 0);
		sel_mul , sel_alu1 , sel_alu2 : out std_logic_vector(1 downto 0);
		en1, en2, en3, en5, en6 : out std_logic;
		sel_op, we,done :out std_logic;
		addr 	:out std_logic_vector(9 downto 0)
	);
	end component;

    
    component datapath
		port (
		A, B, C, D, E, F              : in  std_logic_vector (15 downto 0);
		sel_reg1, sel_reg2, sel_reg3, sel_reg4, sel_reg5 : in std_logic_vector (1 downto 0);
		sel_mul, sel_alu1, sel_alu2        : in std_logic_vector (1 downto 0);
		en_r1, en_r2, en_r3, en_r4,en_r5, en_r6  : in  std_logic;
		clk, sel_op,rst      : in  std_logic;
		reg1 			 : out std_logic_vector (31 downto 0));
	end component;


	component MemIN 
	  port (
		clk    : in  std_logic;
		addr   : in  std_logic_vector(9 downto 0);
		A, B, C, D, E, F : out std_logic_vector(15 downto 0)
		);
	end component;


	component memOUT 
	  port (
		clk     : in  std_logic;
		addr    : in  std_logic_vector(9 downto 0);
		we      : in  std_logic;
		dataIN  : in  std_logic_vector(31 downto 0);
		dataOUT : out  std_logic_vector(31 downto 0)
		);
	end component;




    signal A, B, C, D, E, F              :  std_logic_vector (15 downto 0);
    signal sel_reg1, sel_reg2, sel_reg3, sel_reg5 : std_logic_vector (1 downto 0);
	signal sel_mul, sel_alu1, sel_alu2        : std_logic_vector (1 downto 0);
	signal en_r1, en_r2, en_r3, en_r4,en_r5, en_r6, sel_op, wen  : std_logic;
	signal address    :   std_logic_vector(9 downto 0);
	signal dataIN  :   std_logic_vector(31 downto 0);
    
begin

    addr <= address;
    we <= wen;
    
    inst_control : control port map (
        clk => clk,
		done => done,
        rst => rst,
        sel_reg1 => sel_reg1,
        sel_reg2 => sel_reg2,
        sel_reg3 => sel_reg3,
        sel_reg5 => sel_reg5,
        en1 => en_r1,
        en2 => en_r2,
        en3 => en_r3,
        en5 => en_r5,
        en6 => en_r6,
        sel_mul => sel_mul,
        sel_alu1 => sel_alu1,
        sel_alu2 => sel_alu2,
        sel_op => sel_op,
        we => wen,
        addr => address  
        );
     
     inst_datapath : datapath port map (
	 	rst => rst,
        clk=>clk,
        A => A,
        B => B,
        C => C,
        D => D,
        E => E,
        F => F,
        sel_reg1 => sel_reg1,
        sel_reg2 => sel_reg2,
        sel_reg3 => sel_reg3,
        sel_reg4 => sel_reg3,
        sel_reg5 => sel_reg5,
        en_r1 => en_r1,
        en_r2 => en_r2,
        en_r3 => en_r3,
        en_r4 => en_r3,
        en_r5 => en_r5,
        en_r6 => en_r6,
        sel_mul => sel_mul,
        sel_alu1 => sel_alu1,
        sel_alu2 => sel_alu2,
        sel_op => sel_op,
        reg1 => dataIN 
        
        );       
        
     inst_MemIN :MemIN port map (
        clk=>clk,
        A => A,
        B => B,
        C => C,
        D => D,
        E => E,
        F => F,
        addr => address
     );
     
     inst_memOUT :memOUT port map (
        clk => clk,
        addr => address,
        we => wen,
        dataIN => dataIN,
        dataOUT => dataOUT
        
     );
        
end Behavioral;
