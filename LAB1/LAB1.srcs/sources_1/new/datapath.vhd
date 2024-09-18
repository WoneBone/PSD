library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity datapath is
  port (
  		
		load_hold, sel_mux 		: in std_logic_vector (1 downto 0);
		sel_alu 				: in std_logic_vector (2 downto 0);
		clk, rst 				: in std_logic;
  		display 				: out std_logic_vector (15 downto 0));
end datapath;

architecture behavioral of datapath is
	signal r1_sg 			: signed (9 downto 0);
	signal mux_r, r2_sg, res_alu 	: signed (15 downto 0);
	signal mux_a, logic    			: std_logic_vector (15 downto 0);
	signal register1 				: std_logic_vector (9 downto 0);
	signal data_1, data_2 : signed(15 downto 0);
    signal add_sub , mul : signed (15 downto 0);
    signal shift : unsigned(15 downto 0);
	
  -- the next signal initialization is only considered for simulation
  signal accum     : std_logic_vector (7 downto 0) := (others => '0');	
  -- the next signal initialization is only considered for simulation
  signal register1 : std_logic_vector (7 downto 0) := (others => '0');
  
----------------------------------------------------------------------------
--not all who wander are lost ----------------------------------------------
begin
	-- Pre-Regs
	r1_sg 		<= signed(register1); 
	--muxes
	mux_r 		<= signed(data_in) when sel_mux(1) = '1'  else signed(mux_a);
	mux_a 		<= std_logic_vector(r2_sg) when sel_mux(0) = '1' else std_logic_vector(r1_sg);


	-- registo 1
	process(clk)
	begin
		if clk'event and clk = '1' then
			if rst = '1' then
				r1_sg <= '0';
			elsif load_hold(0) = '1' then 
				register1 <= data_in;
			end if;
		end if;
	end process;
-- Registo 2	

	process(clk)
	begin
		if clk'event and clk = '1' then
			if rst = '1' then
				r2_sg <= '0';
			elsif load_hold(1) = '1' then 
				r2_sg <= mux_r;
			end if;
		end if;
	end process;
	
--ALU	
	case sel_alu is
        when sel_alu = "000"=>
            add_sub<= r1_sg-r2_sg;
            res_alu<= add_sub;
            
        when sel_alu = "001" =>
            add_sub<= r1_sg+r2_sg;
            res_alu<= add_sub;
            
        when sel_alu = "010"=>
            shift <= unsigned(r1_sg);
            shift <= rotate_left(shift ; 1);
            res_alu<=signed(shift);
        
        when sel_alu = "011"=> 
            logic<= std_logic_vector(r1_sg) and std_logic_vector(r2_sg);
            res_alu<=signed(logic);
         
        when others => 
            mul<=r1_sg*r2_sg;
            res_alu<=mul;
            
        end case;     


----------------------- Daqui para baixo não mexi ---------------
  -- output
  reg1 <= register1;
  res  <= accum;
end behavioral;
