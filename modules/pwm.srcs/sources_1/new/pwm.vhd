----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2026 04:21:52 PM
-- Design Name: 
-- Module Name: pwm - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           led_in : in STD_LOGIC_VECTOR (7 downto 0);
           led_out : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is

    signal ce_sample: STD_LOGIC;
    signal counter : unsigned (7 downto 0) := (others => '0');
    component clk_en is
    generic ( G_MAX : positive );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        ce  : out std_logic
    );
    end component clk_en;

begin

    clock_0 : clk_en
        generic map (G_MAX => 400)
        port map(
            clk => clk,
            rst => rst,
            ce => ce_sample
        );
        
    process(clk, rst)
    begin
        if rst = '1' then
            counter <= (others => '0');
            led_out <= '0';
        elsif rising_edge (clk) then
            if ce_sample = '1' then
                counter <= counter + 1;
                if counter < unsigned(led_in) then
                    led_out <= '1';
                else led_out <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;
