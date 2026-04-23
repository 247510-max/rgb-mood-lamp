----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2026 02:14:13 PM
-- Design Name: 
-- Module Name: rgb_mood_lamp_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rgb_mood_lamp_top is
    Port ( clk : in STD_LOGIC;
           btnc : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnr : in STD_LOGIC;
           led16_r : out STD_LOGIC;
           led16_g : out STD_LOGIC;
           led16_b : out STD_LOGIC);
end rgb_mood_lamp_top;

architecture Behavioral of rgb_mood_lamp_top is
    component debounce_top is 
        port(
            clk : in std_logic;
            rst : in std_logic;
            btnu_in : in std_logic;
            btnd_in : in std_logic;
            btnl_in : in std_logic;
            btnr_in : in std_logic;
            btns : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component main is
        port(
            clk : in std_logic;
            rst : in std_logic;
            btns : in std_logic_vector (3 downto 0);
            params : out std_logic_vector (7 downto 0)
        );
    end component;
            
    component rgb is
        port(
            clk : in std_logic;
            rst : in std_logic;
            params : in std_logic_vector (7 downto 0);
            led_r : out std_logic_vector (7 downto 0);
            led_g : out std_logic_vector (7 downto 0);
            led_b : out std_logic_vector (7 downto 0)
        );
    end component;
    
    
    component pwm is
        port(
            clk : in std_logic;
            rst : in std_logic;
            led_in : in std_logic_vector(7 downto 0);
            led_out : out std_logic
        );
    end component;
        
    signal sig_btns : std_logic_vector (3 downto 0);
    signal sig_params : std_logic_vector (7 downto 0);
    signal sig_led_r : std_logic_vector (7 downto 0);
    signal sig_led_g : std_logic_vector (7 downto 0);
    signal sig_led_b : std_logic_vector (7 downto 0);

begin

    debounce_0 : debounce_top
        port map(
            clk => clk,
            rst => btnc,
            btnu_in => btnu,
            btnd_in => btnd,
            btnl_in => btnl,
            btnr_in => btnr,
            btns => sig_btns
        );
        
    main_0 : main
        port map(
            clk => clk,
            rst => btnc,
            btns => sig_btns,
            params => sig_params
        );
        
    rgb_0 : rgb
        port map(
            clk => clk,
            rst => btnc,
            params => sig_params,
            led_r => sig_led_r,
            led_g => sig_led_g,
            led_b => sig_led_b
        );
        
    pwm_r : pwm
        port map(
            clk => clk,
            rst => btnc,
            led_in => sig_led_r,
            led_out => led16_r
        );
        
    pwm_g : pwm
        port map(
            clk => clk,
            rst => btnc,
            led_in => sig_led_g,
            led_out => led16_g
        );
        
    pwm_b : pwm
        port map(
            clk => clk,
            rst => btnc,
            led_in => sig_led_b,
            led_out => led16_b
        );

end Behavioral;
