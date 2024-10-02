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
        done 		: out std_logic;
        
end circuit;

architecture Behavioral of circuit is
    
	component control 
		port (
		clk, rst : in  std_logic;
		sel_reg1,sel_reg2,sel_reg3 : out std_logic_vector(1 downto 0);
		sel_reg4,sel_reg5 : out std_logic_vector(1 downto 0);
		sel_mul , sel_alu1 , sel_alu2 : out std_logic_vector(1 downto 0);
		en1, en2, en3, en4, en5, en6 : out std_logic;
		sel_op, we :out std_logic;
		addr 	:out std_logic_vector(9 downto 0)
	);
	end component;

    
    component datapath
		port (
		A, B, C, D, E, F              : in  std_logic_vector (15 downto 0);
		sel_reg1, sel_reg2, sel_reg3, sel_reg4, sel_reg5 : in std_logic_vector (1 downto 0);
		sel_mul, sel_alu1, sel_alu2        : in std_logic_vector (1 downto 0);
		en_r1, en_r2, en_r3, en_r4,en_r5, en_r6  : in  std_logic;
		clk, sel_op      : in  std_logic;
		reg1 			 : out std_logic_vector (15 downto 0));
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




    signal reset : std_logic;
    signal lh, mux_sel : std_logic_vector(1 downto 0);
    signal alu : std_logic_vector(2 downto 0);
    
begin
    inst_control : control_unit port map (
        clk => clk,
        switch=>switch,
        buttons(0)=>rst,
        buttons(1)=>logic_shift,
        buttons(2)=>muls,
        buttons(3)=>add_sub,
        buttons(4)=>load,
        sel_mux1=>mux_sel(0),
        sel_mux2=>mux_sel(1),
        load_hold1=>lh(0),
        load_hold2=>lh(1),
        sel_alu=> alu,
        rst_1=>reset
		done => done;
        );
     
     inst_datapath : datapath port map (
        clk=>clk,
        rst=>reset,
        data_in=>data_in,
        display=>display,
        load_hold(0)=>lh(0),
        load_hold(1)=>lh(1),
        sel_mux(0)=>mux_sel(0),
        sel_mux(1)=>mux_sel(1),
        sel_alu=>alu
        );        
        
        
end Behavioral;
