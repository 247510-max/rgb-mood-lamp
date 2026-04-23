----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2026 10:54:02 PM
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
    Port ( 
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        btns   : in  STD_LOGIC_VECTOR(3 downto 0);  -- [3]=Left, [2]=Right, [1]=Up, [0]=Down
        params : out STD_LOGIC_VECTOR(7 downto 0)   -- [7:4] Brightness, [3:0] Speed
    );
end main;

architecture Behavioral of main is

    signal brightness : unsigned(3 downto 0) := "1000";
    signal speed      : unsigned(3 downto 0) := "1000";
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                brightness <= "1000";
                speed      <= "1000";
            else
                if btns(1) = '1' then          -- UP
                    brightness <= brightness + 1;

                elsif btns(0) = '1' then       -- DOWN
                    brightness <= brightness - 1;

                elsif btns(3) = '1' then       -- LEFT
                    speed <= speed - 1;

                elsif btns(2) = '1' then       -- RIGHT
                    speed <= speed + 1;
                end if;
            end if;
        end if;
    end process;

    params <= std_logic_vector(brightness) & std_logic_vector(speed);

end Behavioral;
