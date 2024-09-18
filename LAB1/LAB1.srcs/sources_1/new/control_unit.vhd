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
        rst_1 , rst_2                               : out std_logic;
        sel_alu                    : out std_logic_vector(2 downto 0)
        
    );
end control_unit;

architecture Behavioral of control_unit is
    type fsm_states is (INITIAL ,
                        ADDS,SUBS,MULS,
                        LOGIC, SHIFT,LOAD1,LOAD2,
                        RST,FINAL );
    signal curr_state , next_state : fsm_states;
begin

--turn currstate into next state --
    process(clk) begin
        if clk'event and clk = '1' then begin
            curr_state <= next_state;
        end if;
    end process;
    
--calculate next state based on inputs --
    process(clk,curr_state) begin
        next_state <= curr_state; --default is maintaining state --
        if clk'event and clk = '1' then begin
            if buttons(0) = '1' then
                next_stage <= 
            else 
                case curr_state is
                    when INITIAL =>
                        if (buttons(4 downto 1)    ="0100") then
                            if switch = '0' then
                                next_state <= ADDS;
                            else
                                next_state <= SUBS;
                            end if;
                        elsif (buttons(4 downto 1) ="0010") then
                            next_state <= MULS;
                        elsif (buttons(4 downto 1) ="0001") then
                            if switch = '0' then
                                next_state <= LOGIC;
                            else
                                next_state <= SHIFT;
                            end if;
                        else
                            if switch = '0' then
                                next_state <= LOAD1;
                            else
                                next_state <= LOAD2;
                            end if;
                        end if;
                    when ADDS    =>
                        next_state <= FINAL;
                    when SUBS    =>
                        next_state <= FINAL;
                    when MULS    =>
                        next_state <= FINAL;
                    when LOGIC   =>
                        next_state <= FINAL;
                    when SHIFT   =>
                        next_state <= FINAL;
                    when LOAD1   =>
                        next_state <= FINAL;
                    when LOAD2   =>
                        next_state <= FINAL;
                    when RST     =>
                        next_state <= FINAL;
                    when others  =>  -- FINAL --
                        if ((buttons(4 downto 1) ="0000")and(switch = '0')) then
                            next_state <= INITIAL;
                        end if;
                end case;
            end if;
        end if; 
    end process;
    
--calculate output based on current state ----
    process(clk,curr_state) begin
        if clk'event and clk = '1' then begin
            case curr_state is
                when INITIAL =>
                    sel_mux2 ='0'; sel_mux1 ='0'; load_hold1 ='0'; load_hold2 ='0';
                    rst_1='0'; rst_2='0';
                    sel_alu="000";         
                when ADDS    =>
                    sel_mux2 ='0'; sel_mux1 ='1'; load_hold1 ='0'; load_hold2 ='1';
                    rst_1='0'; rst_2='0';
                    sel_alu="001";
                when SUBS    =>
                    sel_mux2 ='0'; sel_mux1 ='1'; load_hold1 ='0'; load_hold2 ='1';
                    rst_1='0'; rst_2='0';
                    sel_alu="000";
                when MULS    =>
                    sel_mux2 ='0'; sel_mux1 ='1'; load_hold1 ='0'; load_hold2 ='1';
                    rst_1='0'; rst_2='0';
                    sel_alu="1XX";
                when LOGIC   =>
                    sel_mux2 ='0'; sel_mux1 ='1'; load_hold1 ='0'; load_hold2 ='1';
                    rst_1='0'; rst_2='0';
                    sel_alu="011";
                when SHIFT   =>
                    sel_mux2 ='0'; sel_mux1 ='1'; load_hold1 ='0'; load_hold2 ='1';
                    rst_1='0'; rst_2='0';
                    sel_alu="010";
                when LOAD1   =>
                    sel_mux2 ='0'; sel_mux1 ='0'; load_hold1 ='1'; load_hold2 ='0';
                    rst_1='0'; rst_2='0';
                    sel_alu="XXX";
                when LOAD2   =>
                    sel_mux2 ='1'; sel_mux1 ='1'; load_hold1 ='0'; load_hold2 ='1';
                    rst_1='0'; rst_2='0';
                    sel_alu="XXX";
                when RST     =>
                    sel_mux2 ='0'; sel_mux1 ='0'; load_hold1 ='0'; load_hold2 ='0';
                    rst_1='1'; rst_2='1';
                    sel_alu="XXX";
                when others   =>  -- FINAL --
                    sel_mux2 ='0'; sel_mux1 ='0'; load_hold1 =''; load_hold2 ='';
                    rst_1='0'; rst_2='0';
                    sel_alu="000";
            end case;
        end if; 
    end process;
end Behavioral;
