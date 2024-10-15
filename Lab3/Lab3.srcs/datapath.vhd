library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity datapath is
  port (
    r11, r12, r21, r22, i11, i12, i21, i22 : in  std_logic_vector (11 downto 0);
	sel_reg1, sel_reg2, sel_reg3, sel_reg4, sel_reg5 : in std_logic_vector (1 downto 0);
    sel_mul, sel_alu1, sel_alu2        : in std_logic_vector (1 downto 0);
    en_r1, en_r2, en_r3, en_r4,en_r5, en_r6, en_r7  : in  std_logic;
    clk, rst      : in  std_logic;
    reg1 			 : out std_logic_vector (31 downto 0));
end datapath;

architecture behavioral of datapath is
  --registers of mem in
  signal reg_r11,reg_r12,reg_r21,reg_r22,reg_i11,reg_i12,reg_i21,reg_i22 : signed (11 downto 0);
  --,muls after mem in
  signal mul1,mul2,mul3,mul4,mul5,mul6,mul7,mul8 : signed (23 downto 0);
  --registers after mul
  signal reg_r11xr22,reg_i11xi22,reg_r11xi22,reg_r22xi11,reg_r12xr21,reg_i21xi12 ,reg_r12xi21 ,reg_r21xi12 : signed (23 downto 0);
  --Alu's after muls
  signal alu_sub1,alu_sub2,alu_add1,alu_add2 : signed (24 downto 0);
  --registers for sum and sub of mul
  signal reg_sub11, reg_sub12, reg_add11, reg_add12 : signed (24 downto 0);
  --final alu for det
  signal alu_detr,alu_deti: signed (25 downto 0) ;
  -- registrs for DET
  signal reg_detr, reg_deti : signed (25 downto 0);
  --register of sumdet
  signal reg_sumdetR, reg_sumdetI : signed (31 downto 0);
  --register of absolute
  signal reg_abdR, reg_absI : signed (25 downto 0);
  --register fot det_1n
  signal reg_det_1n : signed (26 downto 0);
   --reg max min
  signal reg_max, reg_min : signed (26 downto 0);
begin
  -- registers of mem in
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			reg_r11 <= (others => '0');
			reg_r12 <= (others => '0');
			reg_r21 <= (others => '0');
			reg_r22 <= (others => '0');
			reg_i11 <= (others => '0');
			reg_i12 <= (others => '0');
			reg_i21 <= (others => '0');
			reg_i22 <= (others => '0');
      elsif en_r1 = '1' then
            reg_r11 <= signed(r11);
			reg_r12 <= signed(r12);
			reg_r21 <= signed(r21);
			reg_r22 <= signed(r22);
			reg_i11 <= signed(i11);
			reg_i12 <= signed(i12);
			reg_i21 <= signed(i21);
			reg_i22 <= signed(i22);
      end if;
    end if;
  end process;

 -- register R2
 process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			reg_r11xr22<= (others => '0');
			reg_i11xi22<= (others => '0');
			reg_r11xi22<= (others => '0');
			reg_r22xi11<= (others => '0');
			reg_r12xr21<= (others => '0');
			reg_i21xi12<= (others => '0');
			reg_r12xi21<= (others => '0');
			reg_r21xi12<= (others => '0');
      elsif en_r2 = '1' then
            reg_r11xr22<= mul1;
			reg_i11xi22<= mul2;
			reg_r11xi22<= mul3;
			reg_r22xi11<= mul4;
			reg_r12xr21<= mul5;
			reg_i21xi12<= mul6;
			reg_r12xi21<= mul7;
			reg_r21xi12<= mul8;
      end if;
    end if;
  end process;
  
   --register R3
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			reg_sub11<= (others => '0');
		    reg_sub12<= (others => '0');
		    reg_add11<= (others => '0');
		    reg_add12<= (others => '0');
      elsif en_r3 = '1' then
            reg_sub11<= alu_sub1;
		    reg_sub12<= alu_sub2;
		    reg_add11<= alu_add1;
		    reg_add12<= alu_add2;
      end if;
    end if;
  end process;
  
   --register R4
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
		    reg_detr<= (others => '0');
		    reg_deti<= (others => '0');
      elsif en_r4 = '1' then
            reg_detr<= alu_detr;
		    reg_deti<= alu_deti;
      end if;
    end if;
  end process;
  
 
 
 --multiplicadores
 mul1 <= reg_r11*reg_r22;
 mul2 <= reg_i11*reg_i22;
 mul3 <= reg_r11*reg_i22;
 mul4 <= reg_i11*reg_r22;
 mul5 <= reg_r12*reg_r21;
 mul6 <= reg_i12*reg_i21;
 mul7 <= reg_r12*reg_i21;
 mul8 <= reg_r21*reg_i12;
 
 --First ALU stage
 alu_sub1<= reg_r11xr22-reg_i11xi22;
 alu_add1<= reg_r11xi22+reg_r22xi11;
 alu_sub2<= reg_r12xr21-reg_i21xi12;
 alu_add2<= reg_r12xi21+reg_r21xi12;
 
 --alus for det
 alu_detr<=reg_sub11-reg_sub12;
 alu_deti<=reg_add11-reg_add12;
 
 
      
                 
 
end behavioral;
