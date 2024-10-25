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

  
  component datapath
  port (
    mux : in std_logic_vector (1 downto 0);
    r11, r12, r21, r22, i11, i12, i21, i22 : in  std_logic_vector (11 downto 0);
    en_r1, en_r2, en_r3, en_r4,en_r5, en_r6, en_r7, en_r8, en_r9  : in  std_logic;
    mem_out : out std_logic_vector (31 downto 0);
    clk, rst      : in  std_logic;
    count_min , count_max : out std_logic_vector(7 downto 0));
    
end component;

  component control 
  port (
    clk, rst  : in  std_logic;
    start_btn : in  std_logic;
    enReg     : out std_logic_vector(8 downto 0);
	addr_in   : out std_logic_vector(7 downto 0);
	addr_out  : out std_logic_vector(7 downto 0);
	we        : out std_logic;
    out_mul   : out std_logic_vector(1 downto 0));
  
    end component;
    
  signal cnt                        : std_logic_vector(5 downto 0);
  signal cnt_o                      : std_logic_vector(5 downto 0);
  signal dataInIm, dataInRe         : std_logic_vector(11 downto 0);  -- Q6.6
  signal dataInIm_Q, dataInRe_Q : std_logic_vector(11 downto 0);  -- Q6.6
  signal resRe2, resIm2             : std_logic_vector(23 downto 0);  -- Q12.12
  signal resRe2_Q, resIm2_Q     : std_logic_vector(23 downto 0);  -- Q12.12
  signal sum2, sum2_Q           : std_logic_vector(24 downto 0);  -- Q13.12
  signal en_Reg     : std_logic_vector(8 downto 0);
  signal signal_ext : std_logic_vector(3 downto 0);
  signal out_mux   :  std_logic_vector(1 downto 0);
  signal comptMode : std_logic;
  signal we        : std_logic;
 

begin

  dataInIm <= dataIn(11 downto 0);
  dataInRe <= dataIn(27 downto 16);

  inst_datapath : datapath port map (
        clk=>clk,
        rst=>rst,
        mux=>out_mux,
        r11=>datainre,
        r12=>datainre,
        r21=>datainre,
        r22=>datainre,
        i11=>datainim,
        i12=>datainim,
        i21=>datainim,
        i22=>datainim,
        en_r1=>en_reg(0),
        en_r2=>en_reg(1),
        en_r3=>en_reg(2),
        en_r4=>en_reg(3),
        en_r5=>en_reg(4),
        en_r6=>en_reg(5),
        en_r7=>en_reg(6),
        en_r8=>en_reg(7),
        en_r9=>en_reg(8),
        mem_out=>dataout,
        count_min=>statusLeds(7 downto 0 ),
        count_max=>statusLeds(15 downto 8)
        );

    inst_control : control port map(
        clk=>clk,
        rst=>rst,
        start_btn=> start,
        enreg=>en_reg,
        addr_in=>addrin,
        addr_out=> addrout,
        we=>weout,
        out_mul=> out_mux  
    );
 

end Behavioral;
