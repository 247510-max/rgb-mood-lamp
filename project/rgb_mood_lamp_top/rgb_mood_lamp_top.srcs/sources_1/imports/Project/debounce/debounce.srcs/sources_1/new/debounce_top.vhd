----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2026 05:52:40 PM
-- Design Name: 
-- Module Name: debounce_top - Behavioral
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

entity debounce_top is
    Port ( btnu_in : in STD_LOGIC;
           btnd_in : in STD_LOGIC;
           btnl_in : in STD_LOGIC;
           btnr_in : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           btns : out STD_LOGIC_VECTOR (3 downto 0));
end debounce_top;

architecture Behavioral of debounce_top is

    component debounce is
        Port (
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           btn_state : out STD_LOGIC;
           btn_press : out STD_LOGIC
        );
    end component debounce;
    
    signal btnl_state, btnr_state, btnu_state, btnd_state : std_logic;
    signal btnl_press, btnr_press, btnu_press, btnd_press : std_logic;
    signal btns_int : std_logic_vector(3 downto 0);

begin

    db_l : debounce
        port map(
            clk => clk,
            rst => rst,
            btn_in => btnl_in,
            btn_state => open,
            btn_press => btnl_press
        );
        
    db_r : debounce
        port map(
            clk => clk,
            rst => rst,
            btn_in => btnr_in,
            btn_state => open,
            btn_press => btnr_press
        );
        
    db_u : debounce
        port map(
            clk => clk,
            rst => rst,
            btn_in => btnu_in,
            btn_state => open,
            btn_press => btnu_press
        );

    db_d : debounce
        port map(
            clk => clk,
            rst => rst,
            btn_in => btnd_in,
            btn_state => open,
            btn_press => btnd_press
        );

    p_debounce : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                btns_int <= (others => '0');
            else
                if    btnl_press = '1' then
                    btns_int <= "1000";
                elsif btnr_press = '1' then
                    btns_int <= "0100";
                elsif btnu_press = '1' then
                    btns_int <= "0010";
                elsif btnd_press = '1' then
                    btns_int <= "0001";
                else
                    btns_int <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    btns <= btns_int;

end Behavioral;
