library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity datapath is
  port (
  		data_in                 : in std_logic_vector (9 downto 0);
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
    signal mul : signed(25 downto 0);
 
  
----------------------------------------------------------------------------
--not all who wander are lost ----------------------------------------------
begin
	-- Pre-Regs
	r1_sg 		<= signed(register1); 
	--muxes
	mux_r 		<= data_in(9) & data_in(9) & data_in(9) & data_in(9) & data_in(9) & data_in(9) & signed(data_in) when sel_mux(1) = '1'  else signed(res_alu);
	mux_a 		<= std_logic_vector(r2_sg) when sel_mux(0) = '1' else r1_sg(9) & r1_sg(9) & r1_sg(9) & r1_sg(9) & r1_sg(9) & r1_sg(9) & std_logic_vector(r1_sg);


	-- registo 1
	process(clk)
	begin
		if clk'event and clk = '1' then
			if rst = '1' then
				register1 <= "00" & x"00";
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
				r2_sg <= (others => '0');
			elsif load_hold(1) = '1' then 
				r2_sg <= mux_r;
			end if;
		end if;
	end process;
	
--ALU
process(clk)
begin
	case sel_alu is
        when "000"=>
            res_alu <= r1_sg-r2_sg;
			mul <= others => 0;
            
        when "001" =>
            res_alu <= r1_sg+r2_sg;
			mul <= others => 0;
            
        when "010"=>
            res_alu <= signed((15 downto 10 => r1_sg(8)) & rotate_left( unsigned(r1_sg), 1));
			mul <= others => 0;
        
        when  "011"=> 
            res_alu <= signed(((15 downto 10 => '0') & std_logic_vector(r1_sg)) and std_logic_vector(r2_sg));
			mul <= others => 0;
         
        when "1XX" => 
            mul <= r1_sg*r2_sg;
            res_alu <= mul(15 downto 0);

        when others =>
            res_alu <= res_alu;      
			mul <= others => 0;
        end case;
end process;   


----------------------- Daqui para baixo não mexi ---------------
  -- output
    display <= mux_a;
    
end behavioral;
