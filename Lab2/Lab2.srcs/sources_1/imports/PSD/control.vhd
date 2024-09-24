library IEEE;
use IEEE.STD_LOGIC_1164.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
  port (
    clk, rst, exec : in  std_logic;
    instr          : in  std_logic_vector (1 downto 0);
    enables        : out std_logic_vector (1 downto 0);
    selectors      : out std_logic_vector (1 downto 0));
end control;

architecture Behavioral of control is
  type fsm_states is (s_initial, s_end, s_sub, s_add, s_and, s_load);
  signal currstate, nextstate : fsm_states;

begin
  state_reg : process (clk)
  begin
    if clk'event and clk = '1' then
      if rst = '1' then
        currstate <= s_initial;
      else
        currstate <= nextstate;
      end if;
    end if;
  end process;

  state_comb : process (currstate, instr, exec)
  begin  --  process

    nextstate <= currstate;  -- by default, does not change the state.

    case currstate is
      when s_initial =>
        if exec = '1' then
          if instr = "11" then
            nextstate <= s_load;
          elsif instr = "00" then
            nextstate <= s_add;
          elsif instr = "01" then
            nextstate <= s_sub;
          elsif instr = "10" then
            nextstate <= s_and;
          end if;
        end if;
        selectors <= "00";
        enables   <= "00";

      when s_add =>
        nextstate <= s_end;
        selectors <= "00";
        enables   <= "10";

      when s_sub =>
        nextstate <= s_end;
        selectors <= "01";
        enables   <= "10";

      when s_and =>
        nextstate <= s_end;
        selectors <= "10";
        enables   <= "10";

      when s_load =>
        nextstate <= s_end;
        selectors <= "11";
        enables   <= "01";

      when s_end =>
        if exec = '0' then
          nextstate <= s_initial;
        end if;
        selectors <= "00";
        enables   <= "00";

    end case;
  end process;

end Behavioral;

