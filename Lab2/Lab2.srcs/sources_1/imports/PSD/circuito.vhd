library IEEE;
use IEEE.STD_LOGIC_1164.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity circuito is
  port (
    clk, rst, exec : in  std_logic;
    instr          : in  std_logic_vector(1 downto 0);
    data_in        : in  std_logic_vector(7 downto 0);
    reg1, res      : out std_logic_vector(7 downto 0)
    );
end circuito;

architecture Behavioral of circuito is
  component control
    port(
      clk, rst, exec : in  std_logic;
      instr          : in  std_logic_vector (1 downto 0);
      enables        : out std_logic_vector (1 downto 0);
      selectors      : out std_logic_vector (1 downto 0)
      );
  end component;
  component datapath
    port(
      data_in              : in  std_logic_vector (7 downto 0);
      sel_add_sub, sel_mux : in  std_logic;
      en_accum, en_r1      : in  std_logic;
      clk, rst_accum       : in  std_logic;
      res, reg1            : out std_logic_vector (7 downto 0)
      );
  end component;

  signal enables : std_logic_vector(1 downto 0);
  signal sels    : std_logic_vector(1 downto 0);

begin
  inst_control : control port map(
    clk       => clk,
    rst       => rst,
    exec      => exec,
    instr     => instr,
    enables   => enables,
    selectors => sels
    );
  inst_datapath : datapath port map(
    data_in     => data_in,
    rst_accum   => rst,
    en_accum    => enables(1),
    en_r1       => enables(0),
    sel_add_sub => sels(0),
    sel_mux     => sels(1),
    clk         => clk,
    reg1        => reg1,
    res         => res
    );

end Behavioral;
