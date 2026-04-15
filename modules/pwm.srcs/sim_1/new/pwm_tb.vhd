library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_pwm is
-- Testbench has no ports
end tb_pwm;

architecture Behavioral of tb_pwm is

    -- Component Declaration for the Unit Under Test (UUT)
    component pwm
    Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        led_in : in STD_LOGIC_VECTOR (7 downto 0);
        led_out : out STD_LOGIC
    );
    end component;

    -- Signals to connect to UUT
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal led_in  : std_logic_vector(7 downto 0) := (others => '0');
    signal led_out : std_logic;

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: pwm PORT MAP (
          clk => clk,
          rst => rst,
          led_in => led_in,
          led_out => led_out
        );

    -- Clock generation process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- 1. Apply Reset
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        
        -- 2. Test 25% Duty Cycle
        -- led_in = 64 (out of 256)
        led_in <= std_logic_vector(to_unsigned(64, 8));
        wait for 2 ms; 

        -- 3. Test 50% Duty Cycle
        -- led_in = 128 (out of 256)
        led_in <= std_logic_vector(to_unsigned(128, 8));
        wait for 2 ms;

        -- 4. Test 75% Duty Cycle
        -- led_in = 192 (out of 256)
        led_in <= std_logic_vector(to_unsigned(192, 8));
        wait for 2 ms;
        
        -- 5. Test 100% Duty Cycle
        -- led_in = 255 (out of 256)
        led_in <= std_logic_vector(to_unsigned(240, 8));
        wait for 2 ms;
        
        -- 6. Test 0% Duty Cycle
        led_in <= std_logic_vector(to_unsigned(0, 8));
        wait for 2 ms;

        wait;
    end process;

end Behavioral;