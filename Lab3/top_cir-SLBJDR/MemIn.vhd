--BRAM_TDP_MACRO : In order to incorporate this function into the design,
--     VHDL      : the following instance declaration needs to be placed
--   instance    : in the architecture body of the design code.  The
--  declaration  : (BRAM_TDP_MACRO_inst) and/or the port declarations
--     code      : after the "=>" assignment maybe changed to properly
--               : reference and connect this function to the design.
--               : All inputs and outputs must be connected.

--    Library    : In addition to adding the instance declaration, a use
--  declaration  : statement for the UNISIM.vcomponents library needs to be
--      for      : added before the entity declaration.  This library
--    Xilinx     : contains the component declarations for all Xilinx
--   primitives  : primitives and points to the models that will be used
--               : for simulation.

--  Copy the following four statements and paste them before the
--  Entity declaration, unless they already exist.

library ieee;
use ieee.std_logic_1164.all;

library UNISIM;
use UNISIM.vcomponents.all;

library UNIMACRO;
use UNIMACRO.vcomponents.all;


entity MemIn is
  port (
    DataRDA : out std_logic_vector(31 downto 0);
    AddrRDA : in  std_logic_vector(7 downto 0);
    ClkRDA  : in  std_logic;
    DataWRB : in  std_logic_vector(7 downto 0);
    AddrWRB : in  std_logic_vector(9 downto 0);
    ClkWRB  : in  std_logic;
    WeWRB   : in  std_logic
    );
end entity MemIn;


architecture Xmacro of MemIn is

  signal webVector : std_logic_vector(0 downto 0);
  signal addra10   : std_logic_vector(9 downto 0);
  signal addrb12   : std_logic_vector(11 downto 0);

begin

--  <-----Cut code below this line and paste into the architecture body---->

-- BRAM_TDP_MACRO: True Dual Port RAM
--                 Artix-7
-- Xilinx HDL Language Template, version 2016.4

-- Note -  This Unimacro model assumes the port directions to be "downto".
--         Simulation of this model with "to" in the port directions could lead to erroneous results.

--------------------------------------------------------------------------
-- DATA_WIDTH_A/B | BRAM_SIZE | RAM Depth | ADDRA/B Width | WEA/B Width --
-- ===============|===========|===========|===============|=============--
-- A 512x16           8Kb     (8)  256w        8
--     19-36      |  "36Kb"   |    1024   |    10-bit     |    4-bit    --
-- A   10-18      |  "36Kb"   |    2048   |    11-bit     |    2-bit    --
--     10-18      |  "18Kb"   |    1024   |    10-bit     |    2-bit    --
-- B 1kx8b            8Kb      (10)1024w       10
-- B    5-9       |  "36Kb"   |    4096   |    12-bit     |    1-bit    --
--      5-9       |  "18Kb"   |    2048   |    11-bit     |    1-bit    --
--      3-4       |  "36Kb"   |    8192   |    13-bit     |    1-bit    --
--      3-4       |  "18Kb"   |    4096   |    12-bit     |    1-bit    --
--        2       |  "36Kb"   |   16384   |    14-bit     |    1-bit    --
--        2       |  "18Kb"   |    8192   |    13-bit     |    1-bit    --
--        1       |  "36Kb"   |   32768   |    15-bit     |    1-bit    --
--        1       |  "18Kb"   |   16384   |    14-bit     |    1-bit    --
--------------------------------------------------------------------------

  Inst_BRAM_TDP_MACRO : BRAM_TDP_MACRO
    generic map (
      BRAM_SIZE           => "36Kb",    -- Target BRAM, "18Kb" or "36Kb"
      DEVICE              => "7SERIES",  -- Target Device: "VIRTEX5", "VIRTEX6", "7SERIES", "SPARTAN6"
      DOA_REG             => 0,  -- Optional port A output register (0 or 1)
      DOB_REG             => 0,  -- Optional port B output register (0 or 1)
      INIT_A              => X"000000000",  -- Initial values on A output port
      INIT_B              => X"000000000",  -- Initial values on B output port
      INIT_FILE           => "NONE",
      READ_WIDTH_A        => 32,  -- Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
      READ_WIDTH_B        => 8,  -- Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
      SIM_COLLISION_CHECK => "ALL",  -- Collision check enable "ALL", "WARNING_ONLY",
      -- "GENERATE_X_ONLY" or "NONE"
      SRVAL_A             => X"000000000",  -- Set/Reset value for A port output
      SRVAL_B             => X"000000000",  -- Set/Reset value for B port output
      WRITE_MODE_A        => "WRITE_FIRST",  -- "WRITE_FIRST", "READ_FIRST" or "NO_CHANGE"
      WRITE_MODE_B        => "WRITE_FIRST",  -- "WRITE_FIRST", "READ_FIRST" or "NO_CHANGE"
      WRITE_WIDTH_A       => 32,  -- Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
      WRITE_WIDTH_B       => 8,  -- Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")

      -- The following INIT_xx declarations specify the initial contents of the RAM
      --.........../..07..\/..06..\/..05..\/..04..\/..03..\/..02..\/..01..\/..00..\
      INIT_00 => X"D4200FA2C5250C48B4C20107A6D7051FDFED0D9CC5640586B0310B29AE460464",
      INIT_01 => X"DBF10513C6CD0330B0F100F8A54F0F8BD5410149C10B0520B35A0CEBACC40BA8",
      INIT_02 => X"DA110863CB9F0DA7B9870A6EA5490F57DA950880C1A80029B03C0CF8A7940C22",
      INIT_03 => X"D5FB075ACFC504C5B8D300E8AA1B0C95DBA407DBC28C0A8FB54E0A5BA9500D6B",
      INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000001",
      INIT_06 => X"000000000000000000000000000000000000000000000000000000000000002A",
      INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000042",
      INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",

      -- The next set of INIT_xx are valid when configured as 36Kb
      INIT_40 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_41 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",

      -- The next set of INITP_xx are for the parity bits
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",

      -- The next set of INIT_xx are valid when configured as 36Kb
      INITP_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
    port map (
      DOA    => DataRDA,  -- Output port-A data, width defined by READ_WIDTH_A parameter
      DOB    => open,  -- Output port-B data, width defined by READ_WIDTH_B parameter
      ADDRA  => addra10,  -- Input port-A address, width defined by Port A depth
      ADDRB  => addrb12,  -- Input port-B address, width defined by Port B depth
      CLKA   => ClkRDA,                 -- 1-bit input port-A clock
      CLKB   => ClkWRB,                 -- 1-bit input port-B clock
      DIA    => "00000000000000000000000000000000",  -- Input port-A data, width defined by WRITE_WIDTH_A parameter
      DIB    => DataWRB,  -- Input port-B data, width defined by WRITE_WIDTH_B parameter
      ENA    => '1',                    -- 1-bit input port-A enable
      ENB    => '1',                    -- 1-bit input port-B enable
      REGCEA => '1',   -- 1-bit input port-A output register enable
      REGCEB => '1',   -- 1-bit input port-B output register enable
      RSTA   => '0',                    -- 1-bit input port-A reset
      RSTB   => '0',                    -- 1-bit input port-B reset
      WEA    => "0000",  -- Input port-A write enable, width defined by Port A depth
      WEB    => webVector  -- Input port-B write enable, width defined by Port B depth
      );



  webVector <= (0 => WeWRB);
  addra10   <= ("00" & AddrRDA);        -- AddrRDA to 10 bits
  addrb12   <= ("00" & AddrWRB);        -- AddrWRB to 12 bits

-- End of BRAM_TDP_MACRO_inst instantiation

end Xmacro;
