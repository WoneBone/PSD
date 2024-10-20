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
    enReg    : out std_logic_vector(8 downto 0);
	addr 	 : out std_logic_vector(9 downto 0)
    );
end control;

architecture Behavioral of control is
  type fsm_states is (start,
                      load11 ,load22, load12 , load21,
                      muls,subs_adds,subs, absolutes,
                      last_add,done);
  signal currstate, nextstate : fsm_states;
  signal counter : signed(9 downto 0) := (others => '0');

begin
  
  state_reg : process (clk)
  
  begin
    if clk'event and clk = '1' then
      if rst = '1' then
        currstate <= start;
		
      else
        currstate <= nextstate;
      end if;
    end if;
  end process;

  state_comb : process (currstate,counter)
  begin  --  process
  
    nextstate <= currstate;  -- by default, does not change the state.
    

    case currstate is
      when start =>
	    nextstate <= load11;
	    enReg <= "101110000";
		
	  when load11 =>
	    nextstate <= load22;
	    enReg <= "101110001";
      when load22 =>
	    nextstate <= load12;
	    enReg <= "101110010"; 

      when load12 =>
	    nextstate <= load21;
	    enReg <= "101110100";  

      when load21 =>
	    nextstate <= muls;
	    enReg <= "101111001"; 

      when muls =>
	    nextstate <= subs_adds;
	    enReg <= "101110001";
       
      when subs_adds =>
        nextstate <= subs;
        enReg <= "101110010";
       
      when subs =>
        nextstate <= absolutes;
        enReg <= "101110100";
        
      when absolutes =>
        if addr = "100100" then  --addr = 36 first non existant matrix
          nextstate <= last_add;
        else
          nextstate <= muls;
          enReg <= "111111000";
        end if;
        
      when last_add=>
        nextstate <= done;
        enReg <= "101110000";
        
      when done=>
        enReg <= "101110000";

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

