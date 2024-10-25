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
	addr_in   : out std_logic_vector(7 downto 0);
	addr_out  : out std_logic_vector(7 downto 0);
	we        : out std_logic;
    out_mul   : out std_logic_vector(1 downto 0)
    );
end control;

architecture Behavioral of control is
  type fsm_states is (start,
                      load11 ,load22, load12 , load21,
                      muls,subs_adds,subs, absolutes,
                      last_add,store_sumdetI,done);
  signal currstate, nextstate : fsm_states;
  signal counter_in  : unsigned(7 downto 0) := (others => '0'); -- initialze for simulation? --
  signal counter_out : unsigned(7 downto 0) := (others => '0');
  signal inner_we : std_logic;

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
  state_comb : process (currstate,counter_in,start_btn)
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
	    inner_we <= '0';
      out_mul <= "00";
		
	  when load11 =>
	    nextstate <= load22;
	    enReg <= "101110001";
	    inner_we <= '0';
      out_mul <= "00";
	    
      when load22 =>
	    nextstate <= load12;
	    enReg <= "101110010";
	    inner_we <= '0';
      out_mul <= "00";

	     
      when load12 =>
	    nextstate <= load21;
	    enReg <= "101110100";
	    inner_we <= '0';
      out_mul <= "00";

	      

      when load21 =>
	    nextstate <= muls;
	    enReg <= "101111000";
	    inner_we <= '0';
      out_mul <= "00";


      when muls =>
	    nextstate <= subs_adds;
	    enReg <= "101110001";
	    inner_we <= '0';
      out_mul <= "00";

       
      when subs_adds =>
        nextstate <= subs;
        enReg <= "101110010";
        inner_we <= '0';
        out_mul <= "00";

       
      when subs =>
        nextstate <= absolutes;
        enReg <= "101110100";
        inner_we <= '1';
        out_mul <= "00"; -- writing detR --

        
        
      when absolutes =>
        if counter_in > X"21" then  --counter > 32 first non existant matrix
          nextstate <= last_add;
        else
          nextstate <= muls;
        end if;
        enReg <= "111111000";
        inner_we <= '1';
        out_mul <= "01"; --writing detI --

        
      when last_add=>
        nextstate <= store_sumdetI;
        enReg <= "101110000";
        inner_we <= '1';
        out_mul <= "10"; --writing sumDetR --


      when store_sumdetI=>
        nextstate <= done;
        enReg <= "101110000";
        inner_we <= '1';
        out_mul <= "11"; --writing sumDetI --


        
      when done=>
        enReg <= "101110000";
        inner_we <= '0';
        out_mul <= "00";


    end case;
    
  end process;

  -- increment counter_in --
  state_counter_in: process(clk , nextstate)
  begin
    if clk'event and clk = '1' then
		if nextstate = start then
			counter_in <= (others => '0');
			--addr <= std_logic_vector(counter);
		else
			counter_in <= counter_in + 1;
		--else 	
			--counter <= counter;
			--addr <= std_logic_vector(counter);  
		end if;
	end if;
	end process;
	
	state_counter_out: process(clk ,inner_we,rst)
    begin
    if clk'event and clk = '1' then
		if rst = '1' then
			counter_out <= (others => '0');
			--addr <= std_logic_vector(counter);
		else
		  if inner_we = '1' then
			counter_out <= counter_out + 1;
		  else 	
			counter_out <= counter_out;
			--addr <= std_logic_vector(counter);
		  end if;  
		end if;
	end if;
	end process;
   
  -- outside any process, addr follows counter -- 
  addr_in <= std_logic_vector(counter_in);
  addr_out<= std_logic_vector(counter_out);
  --outside any process, we follows inner_we
  we <= inner_we;

end Behavioral;
