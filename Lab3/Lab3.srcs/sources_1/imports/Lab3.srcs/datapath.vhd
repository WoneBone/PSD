library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity datapath is
  port (
    r11, r12, r21, r22, i11, i12, i21, i22 : in  std_logic_vector (11 downto 0);
    en_r1, en_r2, en_r3, en_r4,en_r5, en_r6, en_r7, en_r8, en_r9  : in  std_logic;
    out_sumdetr, out_sumdeti, out_detr, out_deti : out std_logic_vector (31 downto 0);
    clk, rst      : in  std_logic;
    count_min , count_max : out std_logic_vector(7 downto 0));
    
end datapath;

architecture behavioral of datapath is
  --registers of mem in
  signal pre_reg_r11, pre_reg_i11,reg_r11,reg_r12,reg_r21,reg_r22,reg_i11,reg_i12,reg_i21,reg_i22 : signed (11 downto 0);
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
  signal reg_detr, reg_deti, pre_absr, pre_absi, absr,absi : signed (25 downto 0);
  --register of sumdet and alu
  signal reg_sumdetR, reg_sumdetI, pre_sumdetr, pre_sumdeti, sumdetr, sumdeti : signed (31 downto 0);
  --register of absolute
  signal reg_absR, reg_absI : signed (25 downto 0);
  --register fot det_1n
  signal reg_det_1n, det_1n : signed (26 downto 0);
  --comps for max and min
  signal comp_max, comp_min : signed (26 downto 0);
   --reg max min
  signal reg_max, reg_min,max ,min : signed (26 downto 0);
  --counter
  signal cunt, c_max, c_min : unsigned(7 downto 0);
  signal reg_c_max, reg_c_min: unsigned(7 downto 0):="00000000";
begin
  -- registers of mem in r1
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			pre_reg_r11 <= (others => '0');
			pre_reg_i11 <= (others => '0');
      elsif en_r1 = '1' then
            pre_reg_r11 <= signed(r11);
            pre_reg_i11 <= signed(i11);
      end if;
    end if;
  end process;
  
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			reg_r22 <= (others => '0');
			reg_i22 <= (others => '0');
      elsif en_r2 = '1' then
            reg_r22 <= signed(r22);
            reg_i22 <= signed(i22);
      end if;
    end if;
  end process;
  
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			reg_r12 <= (others => '0');
			reg_i12 <= (others => '0');
      elsif en_r3 = '1' then
            reg_r12 <= signed(r12);
            reg_i12 <= signed(i12);
      end if;
    end if;
  end process;
  
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
			reg_r21 <= (others => '0');
			reg_i21 <= (others => '0');
			reg_r11 <= (others => '0');
			reg_i11 <= (others => '0');
      elsif en_r4 = '1' then
            reg_r21 <= signed(r21);
            reg_i21 <= signed(i21);
            reg_r11 <= pre_reg_r11;
            reg_i11 <= pre_reg_i11;
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
      elsif en_r5 = '1' then
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
      elsif en_r6 = '1' then
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
      elsif en_r7 = '1' then
            reg_detr<= alu_detr;
		    reg_deti<= alu_deti;
      end if;
    end if;
  end process;
  
  --register R5
 process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
		    reg_sumdetr<= (others => '0');
		    reg_sumdeti<= (others => '0');
		    reg_absR<=(others => '0');
		    reg_absi<=(others => '0');
		    cunt <= "10000000";
      elsif en_r8 = '1' then
            reg_sumdetr<= sumdetr;
		    reg_sumdeti<= sumdeti;
		    reg_absR<=absr;
		    reg_absi<=absi;
		    cunt<= cunt rol 1;
      end if;
    end if;
  end process;
  
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
		    reg_det_1n<= (others => '0');
      elsif en_r9 = '1' then
            reg_det_1n<= det_1n;
      end if;
    end if;
  end process;
  
  process (clk)
  begin
    if clk'event and clk = '1' then
		if rst = '1' then
		    reg_max<= (others => '0');
		    reg_min<= (others => '0');
		    reg_c_max<=(others => '0');
		    reg_c_min<=(others => '0');
        else 
            reg_max <= max;
		    reg_min <= min;
		    reg_c_max <= c_max;
		    reg_c_min <= c_min;  
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
 alu_sub1<= (reg_r11xr22(23) & reg_r11xr22) - (reg_i11xi22(23) & reg_i11xi22);
 alu_add1<= (reg_r11xi22(23) & reg_r11xi22) + (reg_r22xi11(23) & reg_r22xi11);
 alu_sub2<= (reg_r12xr21(23) & reg_r12xr21) - (reg_i21xi12(23) & reg_i21xi12);
 alu_add2<= (reg_r12xi21(23) & reg_r12xi21) + (reg_r21xi12(23) & reg_r21xi12);
 
 --alus for det
 alu_detr<=(reg_sub11(24) & reg_sub11) - (reg_sub12(24) & reg_sub12);
 alu_deti<=(reg_add11(24) & reg_add11) - (reg_add12(24) & reg_add12);
 
 --sumdet process
 pre_sumdetr <= ((31 downto 26=>reg_detr(25)) & reg_detr);
 pre_sumdeti <= ((31 downto 26=>reg_detr(25)) & reg_detr);
 
 sumdetr<= reg_sumdetr+shift_right(pre_sumdetr,3);
 sumdeti<= reg_sumdeti+shift_right(pre_sumdeti,3);
      
 --abs operations
 pre_absr <= reg_detr;
 pre_absi <= reg_deti;                
 
 absr <= pre_absr when pre_absr(25) = '0' else
        not(pre_absr) + 1; 
  
 absi <= pre_absi when pre_absi(25) = '0' else
        not(pre_absi) + 1;   
            
 -- alu for det 1N
 det_1n<= (reg_absr(25) & reg_absr) + (reg_absi(25) & reg_absi);
 
 --alu for max and min
 comp_max<= reg_det_1n - reg_max;
 comp_min<= reg_det_1n - reg_min;
 
 max<= reg_det_1n when comp_max(26) = '0' else 
           reg_max;
 
 min<= reg_det_1n when comp_min(26) = '1' else
           reg_min; 
 
 c_max<= cunt when comp_max(26) = '0' else
         c_max;   
         
                
  c_min<= cunt when comp_min(26) = '1' else
         c_min;   
 
                             
 --mem outs
 out_sumdetr<=std_logic_vector(reg_sumdetr);
 out_sumdeti<=std_logic_vector(reg_sumdeti); 
 out_detr<=std_logic_vector(((31 downto 26=>reg_detr(25)) & reg_detr));
 out_deti<=std_logic_vector(((31 downto 26=>reg_deti(25)) & reg_deti));
 count_max<= std_logic_vector(reg_c_max);
 count_min<= std_logic_vector(reg_c_min);
end behavioral;
