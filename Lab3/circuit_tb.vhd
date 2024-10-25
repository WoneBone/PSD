library IEEE;
use IEEE.STD_LOGIC_1164.all;
--The IEEE.std_logic_unsigned contains definitions that allow
--std_logic_vector types to be used with the + operator to instantiate a
--counter.
use IEEE.std_logic_unsigned.all;

use IEEE.std_logic_misc.all;


entity circuit_tb is
	--port (        );
end circuit_tb;

architecture test of circuit_tb is

	component MemIn is
		port (
				 DataRDA : out std_logic_vector(31 downto 0);
				 AddrRDA : in  std_logic_vector(7 downto 0);
				 ClkRDA  : in  std_logic;
				 DataWRB : in  std_logic_vector(7 downto 0);
				 AddrWRB : in  std_logic_vector(9 downto 0);
				 ClkWRB  : in  std_logic;
				 WeWRB   : in  std_logic);
	end component MemIn;


	component circuit is
		port (
				 clk        : in  std_logic;
				 rst        : in  std_logic;
				 start      : in  std_logic;
				 switches   : in  std_logic_vector (7 downto 0);
				 dataIn     : in  std_logic_vector (31 downto 0);
				 addrIn     : out std_logic_vector (7 downto 0);
				 dataOut    : out std_logic_vector (31 downto 0);
				 addrOut    : out std_logic_vector (7 downto 0);
				 weOut      : out std_logic;
				 statusLeds : out std_logic_vector (15 downto 0));
	end component circuit;


  -- buttons signals
	signal btnReset  : std_logic := '0';
	signal btnStart  : std_logic := '0';
	signal btnLoad   : std_logic := '0';
	signal btnCenter : std_logic := '0';
	signal btnLeft   : std_logic := '0';

  -- memIn signals
	signal dataIn : std_logic_vector(31 downto 0);
	signal addrIn : std_logic_vector(7 downto 0);

  -- memOut signals
	signal dataOut : std_logic_vector(31 downto 0);
	signal addrOut : std_logic_vector(7 downto 0);

	signal SW       : std_logic_vector (15 downto 0) := (others => '0');



	signal CLK      : std_logic                      := '0';
	
  -- Clock period definitions
	constant clk_period : time := 10 ns;

begin
  -- Signal renaming

  ----------------------------------------------------------
  ------             Components Inst.                -------
  ----------------------------------------------------------

  -- Input memory
	MemIn_1 : MemIn
	port map (
				 DataRDA => dataIn,
				 AddrRDA => addrIn,
				 ClkRDA  => CLK,
				 DataWRB => "00000000",
				 AddrWRB => (others => '0'),
				 ClkWRB  => CLK,
				 WeWRB   => '0');

  -- developed circuit to implement an algorithm
	circuit_1 : circuit
	port map (
				 clk        => CLK,
				 rst        => btnReset,
				 start      => btnStart,
				 switches   => SW(7 downto 0),
				 dataIn     => dataIn,
				 addrIn     => addrIn,
				 dataOut    => dataOut,
				 addrOut    => addrOut
				 );





  -- Clock process definitions
	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;


  -- Stimulus process
	stim_proc : process
	begin
	-- hold reset state for 100 ns.
		wait for 100 ns;

		wait for clk_period*10;


	-- insert stimulus here
		btnReset <= '1' after 1 us,          -- reset btnD
					'0' after 1.7 us;
	--'1' after 50 ms,
	--'0' after 52 ms;

		btnStart <= '1' after 3 us,          -- start working btnR
					'0' after 3.7 us;
	--'1' after 80 ms,
	--'0' after 81 ms;

		btnLoad <= '1' after 2.0010 ms,          -- load from mem btnU
				   '0' after 2.0017 ms;


		wait;
	end process;



end architecture test;
