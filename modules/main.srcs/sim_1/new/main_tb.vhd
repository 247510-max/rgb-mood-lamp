----------------------------------------------------------------------------------
-- Realistic Testbench for main module
-- Takes into account real behavior of debounce_top (one-shot pulses on btns)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main_tb is
end main_tb;

architecture Behavioral of main_tb is

    component main
        Port ( 
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            btns   : in  STD_LOGIC_VECTOR(3 downto 0);
            params : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal clk    : std_logic := '0';
    signal rst    : std_logic := '1';
    signal btns   : std_logic_vector(3 downto 0) := (others => '0');
    signal params : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Unit Under Test
    uut: main
        port map (
            clk    => clk,
            rst    => rst,
            btns   => btns,
            params => params
        );

    -- Clock generator
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Realistic stimulus: short and long button presses
    stim_proc: process
    begin

        -- Initial reset
        rst  <= '1';
        btns <= "0000";
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -------------------------------------------------
        -- 1. Short press on UP (Brightness +1)
        -------------------------------------------------
        btns <= "0010";     -- Up pulse (one clock from debounce)
        wait for 20 ns;     -- pulse width ~2 clocks
        btns <= "0000";
        wait for 200 ns;

        -------------------------------------------------
        -- 2. Long hold on UP (should still produce only ONE pulse)
        -------------------------------------------------
        btns <= "0010";     -- Up "pressed" - but in reality debounce gives only one pulse
        wait for 800 ns;    -- simulate long physical hold
        btns <= "0000";     -- release
        wait for 200 ns;

        -------------------------------------------------
        -- 3. Short press on DOWN (Brightness -1)
        -------------------------------------------------
        btns <= "0001";
        wait for 20 ns;
        btns <= "0000";
        wait for 200 ns;

        -------------------------------------------------
        -- 4. Long hold on RIGHT (Speed +1, only one change)
        -------------------------------------------------
        btns <= "0100";
        wait for 1200 ns;   -- long hold
        btns <= "0000";
        wait for 200 ns;

        -------------------------------------------------
        -- 5. Short press on LEFT (Speed -1)
        -------------------------------------------------
        btns <= "1000";
        wait for 20 ns;
        btns <= "0000";
        wait for 200 ns;

        -------------------------------------------------
        -- 6. Multiple quick presses (different buttons)
        -------------------------------------------------
        btns <= "0010";  wait for 30 ns;  btns <= "0000";  wait for 150 ns;  -- Up
        btns <= "0010";  wait for 30 ns;  btns <= "0000";  wait for 150 ns;  -- Up again
        btns <= "0100";  wait for 30 ns;  btns <= "0000";  wait for 150 ns;  -- Right
        btns <= "1000";  wait for 30 ns;  btns <= "0000";  wait for 150 ns;  -- Left

        -------------------------------------------------
        -- 7. Simultaneous press simulation (only highest priority works)
        -------------------------------------------------
        btns <= "0110";     -- Up + Right at the same time → only Right should win (priority)
        wait for 30 ns;
        btns <= "0000";
        wait for 200 ns;

        wait for 500 ns;

        -- End simulation
        wait;
        
    end process;

end Behavioral;