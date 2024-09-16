library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity datapath is
  port (
  		
		load_hold, sel_mux 		: in std_logic_vector (1 downto 0);
		sel_alu 				: in std_logic_vector (2 downto 0);
		clk, rst 				: in std_logic;
  		display 				: out std_logic_vector 15 downto 0));
end datapath;

architecture behavioral of datapath is
	signal data_sg, r1_sg 			: signed (9 downto 0);
	signal mux_r, r2_sg, res_alu 	: signed (15 downto 0);
	signal mux_a 					: std_logic_vector (15 downto 0);
  -- the next signal initialization is only considered for simulation
  signal accum     : std_logic_vector (7 downto 0) := (others => '0');
  -- the next signal initialization is only considered for simulation
  signal register1 : std_logic_vector (7 downto 0) := (others => '0');

begin
	-- Pre-Regs
	data_sg 	<= signed(data_in);

	--muxes
	mux_r 		<= signed(data_in) when sel_mux(1) = '1'  else signed(mux_a);
	mux_a 		<= std_logic_vector(res_alu) when sel_mux(0) = '1' else std_logic_vector(r1_sg);



	--display (Não sei como se faz),
	res_d 		<= std_logic_vector(res_alu) 
  -- adder/subtracter
	
  r1_sg         <= signed(register1);
  accum_sg      <= signed(accum);
  res_addsub    <= std_logic_vector(res_addsub_sg);
  res_addsub_sg <= accum_sg + r1_sg when sel_add_sub = '0' else
                   accum_sg - r1_sg;

  -- logic unit
  res_and <= register1 and accum;

  -- multiplexer
  res_alu <= res_addsub when sel_mux = '0'
             else res_and;

  -- accumulator
  process (clk)
  begin
    if clk'event and clk = '1' then
      if rst_accum = '1' then
        accum <= X"00";
      elsif en_accum = '1' then
        accum <= res_alu;
      end if;
    end if;
  end process;

  -- register R1
  process (clk)
  begin
    if clk'event and clk = '1' then
      if en_r1 = '1' then
        register1 <= data_in;
      end if;
    end if;
  end process;

  -- output
  reg1 <= register1;
  res  <= accum;
end behavioral;
