library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
  port (
    clk, rst : in  std_logic;
    sel_reg1,sel_reg2,sel_reg3 : out std_logic_vector(1 downto 0);
    sel_reg5 : out std_logic_vector(1 downto 0);
    sel_mul , sel_alu1 , sel_alu2 : out std_logic_vector(1 downto 0);
    en1, en2, en3, en5, en6 : out std_logic;
    sel_op, we, done :out std_logic;
	addr 	:out std_logic_vector(9 downto 0)
    );
end control;

architecture Behavioral of control is
  type fsm_states is (st0, st0_1, st1,st2,st3,st4,st5, st6, st_done);
  signal currstate, nextstate : fsm_states;
  signal counter : signed(9 downto 0) := (others => '0');

begin
  
  state_reg : process (clk)
  
  begin
    if clk'event and clk = '1' then
      if rst = '1' then
        currstate <= st0;
		
      else
        currstate <= nextstate;
      end if;
    end if;
  end process;

  state_comb : process (currstate,counter)
  begin  --  process
  
    nextstate <= currstate;  -- by default, does not change the state.
    

    case currstate is
      when st0 =>
        sel_reg1 <= "01"; sel_reg2 <= "01"; sel_reg3 <= "01";
        sel_reg5 <= "01";
        sel_mul <=  "00"; sel_alu1 <= "00"; sel_alu2 <= "00";
        en1<= '1'; en2<= '1'; en3<= '1'; en5<= '1'; en6<= '1';
        sel_op <= '0';
		nextstate <= st0_1;  
		we <= '0';
		done <= '0';
		
		when st0_1 =>
        sel_reg1 <= "01"; sel_reg2 <= "01"; sel_reg3 <= "01";
        sel_reg5 <= "01";
        sel_mul <=  "00"; sel_alu1 <= "00"; sel_alu2 <= "00";
        en1<= '1'; en2<= '1'; en3<= '1'; en5<= '1'; en6<= '1';
        sel_op <= '0';
		nextstate <= st1;  
		we <= '0';
		done <= '0';

      when st1 =>
        sel_reg1 <= "00"; sel_reg2 <= "00"; sel_reg3 <= "10";
        sel_reg5 <= "10";
        sel_mul <=  "01"; sel_alu1 <= "10"; sel_alu2 <= "10";
        en1<= '0'; en2<= '0'; en3<= '1'; en5<= '1'; en6<= '0';
        sel_op <= '0';
		nextstate <= st2;  
		we <= '0';
		done <= '0';

      when st2 =>
        sel_reg1 <= "11"; sel_reg2 <= "10"; sel_reg3 <= "00";
        sel_reg5 <= "11";
        sel_mul <=  "11"; sel_alu1 <= "01"; sel_alu2 <= "11";
        en1<= '1'; en2<= '1'; en3<= '0'; en5<= '1'; en6<= '0';
        sel_op <= '0';
		nextstate <= st3;  
		we <= '0';
		done <= '0';

      when st3 =>
        sel_reg1 <= "10"; sel_reg2 <= "11"; sel_reg3 <= "00";
        sel_reg5 <= "00";
        sel_mul <=  "01"; sel_alu1 <= "11"; sel_alu2 <= "11";
        en1<= '1'; en2<= '1'; en3<= '0'; en5<= '0'; en6<= '0';
        sel_op <= '0';
		nextstate <= st4;  
		we <= '0';
		done <= '0';

      when st4 =>
        sel_reg1 <= "00"; sel_reg2 <= "10"; sel_reg3 <= "00";
        sel_reg5 <= "00";
        sel_mul <=  "10"; sel_alu1 <= "00"; sel_alu2 <= "00";
        en1<= '0'; en2<= '1'; en3<= '0'; en5<= '0'; en6<= '0';
        sel_op <= '0';
		nextstate <= st5;  
		we <= '0';
		done <= '0';
       
       when st5 =>
        sel_reg1 <= "11"; sel_reg2 <= "00"; sel_reg3 <= "00";
        sel_reg5 <= "00";
        sel_mul <=  "00"; sel_alu1 <= "01"; sel_alu2 <= "01";
        en1<= '1'; en2<= '0'; en3<= '0'; en5<= '0'; en6<= '0';
        sel_op <= '1';
		we <= '0';
		done <= '0';
		nextstate <= st6; 
		
      when st6 =>
		sel_reg1 <= "00"; sel_reg2 <= "00"; sel_reg3 <= "00";
		sel_reg5 <= "00";
		sel_mul <=  "00"; sel_alu1 <= "00"; sel_alu2 <= "00";
		en1<= '0'; en2<= '0'; en3<= '0'; en5<= '0'; en6<= '0';
		sel_op <= '0';
		we <= '1';
		done <= '0';
		if counter = "0000001111" then
			nextstate <= st_done;  
		else
			nextstate <= st0;  
		end if;

      when st_done =>
        sel_reg1 <= "00"; sel_reg2 <= "00"; sel_reg3 <= "00";
        sel_reg5 <= "00";
        sel_mul <=  "00"; sel_alu1 <= "00"; sel_alu2 <= "00";
        en1<= '0'; en2<= '0'; en3<= '0'; en5<= '0'; en6<= '0';
        sel_op <= '0';
		done <= '1';
		we <= '0';

    end case;
    
  end process;

  process(counter, currstate,clk,rst)
    begin
    if clk'event and clk = '1' then
		if rst='1' then
			counter <= (others => '0');
			--addr <= std_logic_vector(counter);
		elsif currstate = st6 and rst='0'  then
			
			counter <= counter + 1;
			--addr <= std_logic_vector(counter);    
		--else 	
			--counter <= counter;
			--addr <= std_logic_vector(counter);  
		end if;
	end if;
	
   end process;
addr <= std_logic_vector(counter);

end Behavioral;

