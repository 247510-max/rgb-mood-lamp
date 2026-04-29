----------------------------------------------------------------------------------
-- Company: Brno University of Technology
-- Engineer: Danat Pustynnikov, Alisher Aitken
-- Design Name: debounce_top.vhd
-- Module Name: debounce_top - Behavioral
-- Project Name: RGB Mood Lamp
-- Target Devices: XILINS Nexys ARTIX-7 50T
--
--
-- Copyright (c) 2026 Alisher Aitken, Danat Pustynnikov
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY debounce_top IS
	PORT (
		btnu_in : IN STD_LOGIC;
		btnd_in : IN STD_LOGIC;
		btnl_in : IN STD_LOGIC;
		btnr_in : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		btns : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END debounce_top;

ARCHITECTURE Behavioral OF debounce_top IS

	COMPONENT debounce IS
		PORT (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			btn_in : IN STD_LOGIC;
			btn_state : OUT STD_LOGIC;
			btn_press : OUT STD_LOGIC
		);
	END COMPONENT debounce;

	SIGNAL btnl_press, btnr_press, btnu_press, btnd_press : STD_LOGIC;  --signaly hodnot tlacitek
	SIGNAL btns_int : STD_LOGIC_VECTOR(3 DOWNTO 0);  --vystupni vektor hodnot tlacitek

BEGIN

	db_l : debounce
	PORT MAP(
		clk => clk,
		rst => rst,
		btn_in => btnl_in,
		btn_state => OPEN,
		btn_press => btnl_press
	);

	db_r : debounce
	PORT MAP(
		clk => clk,
		rst => rst,
		btn_in => btnr_in,
		btn_state => OPEN,
		btn_press => btnr_press
	);

	db_u : debounce
	PORT MAP(
		clk => clk,
		rst => rst,
		btn_in => btnu_in,
		btn_state => OPEN,
		btn_press => btnu_press
	);

	db_d : debounce
	PORT MAP(
		clk => clk,
		rst => rst,
		btn_in => btnd_in,
		btn_state => OPEN,
		btn_press => btnd_press
	);

	p_debounce : PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF rst = '1' THEN
				btns_int <= (OTHERS => '0');
			ELSE
				IF btnl_press = '1' THEN
					btns_int <= "1000";
				ELSIF btnr_press = '1' THEN
					btns_int <= "0100";
				ELSIF btnu_press = '1' THEN
					btns_int <= "0010";
				ELSIF btnd_press = '1' THEN
					btns_int <= "0001";
				ELSE
					btns_int <= (OTHERS => '0');
				END IF;
			END IF;
		END IF;
	END PROCESS;

	btns <= btns_int;

END Behavioral;