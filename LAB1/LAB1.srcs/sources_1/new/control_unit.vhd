----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2024 05:15:51 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
    Port ( 
        ---------- buttons=( BTNL , BTNU , BTNR , BTND , BTNC ) -----------
        buttons                          : in std_logic_vector(4 downto 0);
        switch                           : in std_logic;
        clk                              : in std_logic;
        sel_mux2 ,sel_mux1 , load_hold1 ,load_hold2 : out std_logic;
        rst_1                                         : out std_logic;
        sel_alu                    : out std_logic_vector(2 downto 0)
        
    );
end control_unit;

architecture Behavioral of control_unit is
    type fsm_states is (INITIAL ,
                        ADDS,SUBS,MULS,
                        LOGIC, SHIFT,LOAD1,LOAD2,
                        FINAL );
    signal curr_state , next_state : fsm_states;
begin
    
--turn currstate into next state --
    process(clk) begin
        
        -- reset machine --
        if clk'event and clk = '1' then
            if (buttons(0) = '1') then 
            	rst_1 <= '1';
            	sel_mux1 <= '1'; --default display is reg2--
                curr_state <= FINAL;
                
        
            else 
                rst_1 <='0';
                curr_state <= next_state;
            end if;
        end if;
    end process;

    next_state <= ADDS    when (curr_state = INITIAL) and (buttons(4 downto 1) = "0100") and (switch = '0') else
                  SUBS    when (curr_state = INITIAL) and (buttons(4 downto 1) = "0100") and (switch = '1') else
                  MULS    when (curr_state = INITIAL) and (buttons(4 downto 1) = "0010") else
                  LOGIC   when (curr_state = INITIAL) and (buttons(4 downto 1) = "0001") and (switch = '0') else
                  SHIFT   when (curr_state = INITIAL) and (buttons(4 downto 1) = "0001") and (switch = '1') else
                  LOAD1   when (curr_state = INITIAL) and (buttons(4 downto 1) = "1000") and (switch = '0') else
                  LOAD2   when (curr_state = INITIAL) and (buttons(4 downto 1) = "1000") and (switch = '1') else
                  INITIAL when ((curr_state = FINAL) or(curr_state=INITIAL) )and (buttons(4 downto 1) = "0000") else
                  FINAL;

    sel_mux2   <= '1' when curr_state = LOAD2 else
                  '0';

    sel_mux1   <= '0' when curr_state = LOAD1 else
                  '1';

    load_hold1 <= '1' when curr_state = LOAD1 else 
                  '0';

    load_hold2 <= '0' when curr_state = LOAD1 or curr_state = INITIAL or curr_state = FINAL else
                  '1';

    sel_alu    <= "000" when curr_state = INITIAL or curr_state = SUBS or curr_state = FINAL else
                  "001" when curr_state = ADDS else
                  "100" when curr_state = MULS else
                  "011" when curr_state = LOGIC else
                  "010" when curr_state = SHIFT else
                  "XXX";        
                  
end Behavioral;
