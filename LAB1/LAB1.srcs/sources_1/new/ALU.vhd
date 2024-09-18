library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity ALU is
    port (
  		
  		data_in_1, data_in_2     : in std_logic_vector (15 downto 0);
  		sel_alu : in std_logic_vector(2 downto 0);
  		res_alu 	  			: out std_logic_vector (15 downto 0));
end ALU;

architecture Behavioral of ALU is
    signal data_1, data_2 : signed(15 downto 0);
    signal add_sub_mul : signed (15 downto 0);
    signal logic_shift : unsigned(15 downto 0);
    
    begin
        case sel_alu is
            when sel_alu = "000"=>
                data_1<= signed(data_in_1);
                data_2<= signed(data_in_2);
                add_sub_mul<= data_1-data_2;
                res_alu<=std_logic_vector(add_sub_mul);
                
            when sel_alu = "001" =>
                data_1<= signed(data_in_1);
                data_2<= signed(data_in_2);
                add_sub_mul<= data_1+data_2;
                res_alu<=std_logic_vector(add_sub_mul);
                
            when sel_alu = "010"=>
                logic_shift <= rotate_left(data_in_2;1);
                
                
            
            when others => 
            
        end case;     
            
    

end Behavioral;
