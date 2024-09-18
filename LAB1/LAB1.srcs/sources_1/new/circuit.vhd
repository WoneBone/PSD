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
        clk, rst, ADD_SUB, LOAD, MULS, LOGIC_SHIFT, switch     : in std_logic;
        data_in                                        : in std_logic_vector(9 downto 0);
        display                                        : out std_logic_vector(15 downto 0));
        
end circuit;

architecture Behavioral of circuit is
    component control_unit
        Port ( 
            ---------- buttons=( BTNL , BTNU , BTNR , BTND , BTNC ) -----------
            buttons                          : in std_logic_vector(4 downto 0);
            switch                           : in std_logic;
            clk                              : in std_logic;
            sel_mux2 ,sel_mux1 , load_hold1 ,load_hold2 : out std_logic;
            rst_1                                         : out std_logic;
            sel_alu                    : out std_logic_vector(2 downto 0)
            
        );
    end component;
    
    component datapath
        port (
            data_in                 : in std_logic_vector (9 downto 0);
            load_hold, sel_mux 		: in std_logic_vector (1 downto 0);
            sel_alu 				: in std_logic_vector (2 downto 0);
            clk, rst 				: in std_logic;
            display 				: out std_logic_vector (15 downto 0));
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
