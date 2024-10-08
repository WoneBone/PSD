library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity datapath is
  port (
    A, B, C, D, E, F              : in  std_logic_vector (15 downto 0);
	sel_reg1, sel_reg2, sel_reg3, sel_reg4, sel_reg5 : in std_logic_vector (1 downto 0);
    sel_mul, sel_alu1, sel_alu2        : in std_logic_vector (1 downto 0);
    en_r1, en_r2, en_r3, en_r4,en_r5, en_r6  : in  std_logic;
    clk, sel_op, rst      : in  std_logic;
    reg1 			 : out std_logic_vector (31 downto 0));
end datapath;

architecture behavioral of datapath is
  signal reg_mux1,reg_mux2,reg_mux3,reg_mux4,reg_mux5 : signed (31 downto 0);
  signal mux_mul, mux_alu1, mux_alu2 : signed (31 downto 0);
  signal res_mul1, res_mul2, res_alu, res_shift : signed (31 downto 0);
  -- the next signal initialization is only considered for simulation
  signal register1,register2,register3,register4,register5,register6 : signed (31 downto 0) := (others => '0');
  signal mul1,mul2 :signed (63 downto 0) := (others => '0');
begin

  reg1 <= std_logic_vector(register1);

  -- register R1
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			register1 <= (others => '0');
      elsif en_r1 = '1' then
        register1 <= reg_mux1;
      end if;
    end if;
  end process;

 -- register R2
 process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			register2 <= (others => '0');
      elsif en_r2 = '1' then
        register2 <= reg_mux2;
      end if;
    end if;
  end process;
  
  --register R3
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			register3 <= (others => '0');
      elsif en_r3 = '1' then
        register3 <= reg_mux3;
      end if;
    end if;
  end process;
 
 --register R4
 process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			register4 <= (others => '0');
      elsif en_r4 = '1' then
        register4 <= reg_mux4;
      end if;
    end if;
  end process;
  
  --register R5
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			register5 <= (others => '0');
		elsif en_r5 = '1' then
        register5 <= reg_mux5;
      end if;
    end if;
  end process;
  
  --register R6
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			register6 <= (others => '0');
      elsif en_r6 = '1' then
        register6 <= resize(signed(F), 32);
      end if;
    end if;
  end process;
  
  --Muxs de registos 
  reg_mux1 <= resize(signed(A), 32) when sel_reg1 = "01" else
              res_mul1 when sel_reg1 = "10" else
              res_alu when sel_reg1 = "11" else
              (others => '0');
              
  reg_mux2 <= resize(signed(B), 32) when sel_reg2 = "01" else
              res_mul1 when sel_reg2 = "10" else
              res_alu when sel_reg2 = "11" else
              (others => '0');            
             
   
  reg_mux3 <= resize(signed(C), 32) when sel_reg3 = "01" else
              res_mul1 when sel_reg3 = "10" else
              (others => '0');
   
  reg_mux4 <= resize(signed(D), 32) when sel_reg4 = "01" else
              res_alu when sel_reg4 = "10" else
              (others => '0');  
                
  reg_mux5 <= resize(signed(E), 32) when sel_reg5 = "01" else
              res_mul2 when sel_reg5 = "10" else
              res_shift when sel_reg5 = "11" else
              (others => '0');
                                              
  --MUXs de operações
  mux_mul <= register1 when sel_mul = "01" else
             register3 when sel_mul = "10" else
             register4 when sel_mul = "11" else
             (others => '0');
             
  mux_alu1 <= register1 when sel_alu1 = "01" else
              register3 when sel_alu1 = "10" else
              register4 when sel_alu1 = "11" else 
              (others => '0');   
              
 mux_alu2 <=  register2 when sel_alu2 = "01" else
              register4 when sel_alu2 = "10" else
              register5 when sel_alu2 = "11" else 
              (others => '0');
                 
 --multiplicador 1
 mul1 <= mux_mul*register2;
 res_mul1 <= mul1(31 downto 0);
 
 --multiplicador 2
 mul2<= register5*register6;
 res_mul2<=mul2(31 downto 0);
 
 --ALU
 res_alu<= mux_alu1+mux_alu2 when sel_op='0' else
           mux_alu2-mux_alu1 when sel_op ='1';
           
 --shift
 res_shift<= shift_right(register5, 2);          
 
      
                 
 
end behavioral;
