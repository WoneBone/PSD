-- Example circuit by Prof. Paulo Flores (2020/21 1S)
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.all;
use ieee.std_logic_signed.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity circuit is
  port (clk        : in  std_logic;
        rst        : in  std_logic;                        -- btnD
        start      : in  std_logic;                        -- btnR
        switches   : in  std_logic_vector (7 downto 0);
        dataIn     : in  std_logic_vector (31 downto 0);
        addrIn     : out std_logic_vector (7 downto 0);
        dataOut    : out std_logic_vector (31 downto 0);
        addrOut    : out std_logic_vector (7 downto 0);
        weOut      : out std_logic;
        statusLeds : out std_logic_vector (15 downto 0));  -- leds
end circuit;

architecture Behavioral of circuit is
  signal cnt                        : std_logic_vector(5 downto 0);
  signal cnt_o                      : std_logic_vector(5 downto 0);
  signal dataInIm, dataInRe         : std_logic_vector(11 downto 0);  -- Q6.6
  signal dataInIm_Q, dataInRe_Q : std_logic_vector(11 downto 0);  -- Q6.6
  signal resRe2, resIm2             : std_logic_vector(23 downto 0);  -- Q12.12
  signal resRe2_Q, resIm2_Q     : std_logic_vector(23 downto 0);  -- Q12.12
  signal sum2, sum2_Q           : std_logic_vector(24 downto 0);  -- Q13.12

  signal signal_ext : std_logic_vector(3 downto 0);

  signal comptMode : std_logic;
  signal we        : std_logic;

begin

  counter : process (clk, rst)
  begin  -- process counter for addr memIn
    if clk'event and clk = '1' then                -- rising clock edge
      if rst = '1' then                            -- synchronous reset
        cnt <= (others => '0');
      elsif comptMode = '1' and cnt(5) = '0' then  -- synchronous count upto
        cnt <= cnt + 1;                            -- 100000 = 32 cycles after start
      end if;
    end if;
  end process counter;

  counter_out_memout_addr : process (clk, rst)
  begin  -- process counter for addr memOut
    if clk'event and clk = '1' then            -- rising clock edge
      if rst = '1' then                        -- synchronous reset
        cnt_o <= (others => '0');
      elsif comptMode = '1' and cnt >= 4 then  -- synchronous count (4 cycles to fill pipeline)
        cnt_o <= cnt_o + 1;
      end if;
    end if;
  end process counter_out_memout_addr;


  data_registers : process (clk, rst)
  begin  -- process registers
    if clk'event and clk = '1' then     -- rising clock edge
      if rst = '1' then                 -- synchronous reset
        dataInIm_Q <= (others => '0');
        dataInRe_Q <= (others => '0');
        resRe2_Q   <= (others => '0');
        resIm2_Q   <= (others => '0');
        sum2_Q     <= (others => '0');
      else
        dataInIm_Q <= dataInIm;
        dataInRe_Q <= dataInRe;
        resRe2_Q   <= resRe2;
        resIm2_Q   <= resIm2;
        sum2_Q     <= sum2;
      end if;
    end if;
  end process data_registers;


  wait_for_start : process (clk, rst)
  begin  -- process wait_for_start
    if clk'event and clk = '1' then     -- rising clock edge
      if rst = '1' then                 -- synchronous reset
        comptMode <= '0';
      elsif cnt(5) = '1' then
        comptMode <= '0';
      elsif start = '1' then            -- synchronous start
        comptMode <= '1';
      end if;
    end if;
  end process wait_for_start;


-- control signals and input address packing
  addrIn <= ("00" & cnt);

  dataInIm <= dataIn(11 downto 0);
  dataInRe <= dataIn(27 downto 16);

  -- Datapath
  resIm2 <=  dataInIm_Q * dataInIm_Q;
  resRe2 <=  dataInRe_Q * dataInRe_Q;


  sum2 <= (resRe2_Q(23) & resRe2_Q) + (resIm2_Q(23) & resIm2_Q);

  -- packing results from Q13.12 (25bits) to Q17.15 (32bit)
  signal_ext <= (others => sum2_Q(24));
  dataOut    <= signal_ext & sum2_Q & "000";


  -- more control signals and output address packing
  addrOut <= ("00" & cnt_o);


  we <=
    '1' when (cnt >= 4) else
    '0';
  weOut <= we;

  statusLeds <= sum2(15 downto 0);

end Behavioral;
