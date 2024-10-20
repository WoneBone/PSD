library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
  port (
    clk, rst  : in  std_logic;
    start_btn : in  std_logic;
    enReg     : out std_logic_vector(8 downto 0);
	addr 	  : out std_logic_vector(9 downto 0);
	we        : out std_logic
    );
end control;

architecture Behavioral of control is
  type fsm_states is (start,
                      load11 ,load22, load12 , load21,
                      muls,subs_adds,subs, absolutes,
                      last_add,done);
  signal currstate, nextstate : fsm_states;
  signal counter : signed(9 downto 0) := (others => '0'); -- initialze for simulation? --

begin

  -- store state ,transition to next state --
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

  -- calculate next state and output values --
  state_comb : process (currstate,counter,start_btn)
  begin  --  process
  
    nextstate <= currstate;  -- by default, does not change the state.

    case currstate is
      when start =>
        if start_btn = '0' then
	      nextstate <= start;
	    else
          nextstate <= load11;
        end if;   
	    enReg <= "101110000";
	    we <= '0';
		
	  when load11 =>
	    nextstate <= load22;
	    enReg <= "101110001";
	    we <= '0';
	    
      when load22 =>
	    nextstate <= load12;
	    enReg <= "101110010";
	    we <= '0';
	     
      when load12 =>
	    nextstate <= load21;
	    enReg <= "101110100";
	    we <= '0';
	      

      when load21 =>
	    nextstate <= muls;
	    enReg <= "101111001";
	    we <= '0'; 

      when muls =>
	    nextstate <= subs_adds;
	    enReg <= "101110001";
        -- se a primeira já tiver passado
        --ESTOU A ASSUMIR QUE ESCREVER NA MEMORIA É 1 CICLO, PODE SER PRECISO MEXER/ESTENDER	    
	    if counter > X"04" then
	      we <= '1';
	    else
	      we <= '0'; 
	    end if;
       
      when subs_adds =>
        nextstate <= subs;
        enReg <= "101110010";
        we <= '0';
       
      when subs =>
        nextstate <= absolutes;
        enReg <= "101110100";
        we <= '0';
        
        
      when absolutes =>
        if counter > X"1F" then  --counter > 31 first non existant matrix
          nextstate <= last_add;
        else
          nextstate <= muls;
          enReg <= "111111000";
        end if;
        we <= '0';
        
      when last_add=>
        nextstate <= done;
        enReg <= "101110000";
        we <= '1';
        
      when done=>
        enReg <= "101110000";
        we <= '0';

    end case;
    
  end process;

  -- increment counter --
  state_counter: process(clk , currstate)
    begin
    if clk'event and clk = '1' then
		if currstate = start then
			counter <= (0=>'1',others => '0');
			--addr <= std_logic_vector(counter);
		else
			counter <= counter + 1;
		--else 	
			--counter <= counter;
			--addr <= std_logic_vector(counter);  
		end if;
	end if;
	
   end process;
  -- outside of any process, addr follows counter -- 
  addr <= std_logic_vector(counter);

end Behavioral;

