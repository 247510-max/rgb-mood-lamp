-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 09 Apr 2026 19:29:42 GMT
-- Request id : cfwk-fed377c2-69d7fe262d684

library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce_top is
end tb_debounce_top;

architecture tb of tb_debounce_top is

    component debounce_top
        port (btnu_in : in std_logic;
              btnd_in : in std_logic;
              btnl_in : in std_logic;
              btnr_in : in std_logic;
              rst     : in std_logic;
              clk     : in std_logic;
              btns    : out std_logic_vector (3 downto 0));
    end component;

    signal btnu_in : std_logic;
    signal btnd_in : std_logic;
    signal btnl_in : std_logic;
    signal btnr_in : std_logic;
    signal rst     : std_logic;
    signal clk     : std_logic;
    signal btns    : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : debounce_top
    port map (btnu_in => btnu_in,
              btnd_in => btnd_in,
              btnl_in => btnl_in,
              btnr_in => btnr_in,
              rst     => rst,
              clk     => clk,
              btns    => btns);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        btnu_in <= '0';
        btnd_in <= '0';
        btnl_in <= '0';
        btnr_in <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        btnu_in <= '1';
        wait for 100 ns;
        
        btnl_in <= '1';
        wait for 100 ns;
        
        btnl_in <= '0';
        wait for 100 ns;
        
        wait for 200 ns;
        
        
        btnr_in <= '1';
        
        btnd_in <= '1';
        
        
        
--        btnu_in <= '0';
--        wait for 100 ns;
        
--        btnr_in <= '1';
--        btnd_in <= '1';
        
--        wait for 100ns;
        
--        btnl_in <= '0';
--        btnr_in <= '0';
--        btnu_in <= '0';
--        btnd_in <= '0';


        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_debounce_top of tb_debounce_top is
    for tb
    end for;
end cfg_tb_debounce_top;