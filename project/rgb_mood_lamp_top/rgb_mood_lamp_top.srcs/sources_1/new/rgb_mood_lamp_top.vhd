----------------------------------------------------------------------------------
-- Company: Brno University of Technology
-- Engineer: Danat Pustynnikov, Alisher Aitken
-- Design Name: rgb_mood_lamp_top.vhd
-- Module Name: rgb_mood_lamp_top - Behavioral
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
ENTITY rgb_mood_lamp_top IS
	PORT (
		clk : IN STD_LOGIC;
		btnc : IN STD_LOGIC;
		btnu : IN STD_LOGIC;
		btnd : IN STD_LOGIC;
		btnl : IN STD_LOGIC;
		btnr : IN STD_LOGIC;
		led16_r : OUT STD_LOGIC;
		led16_g : OUT STD_LOGIC;
		led16_b : OUT STD_LOGIC);
END rgb_mood_lamp_top;

ARCHITECTURE Behavioral OF rgb_mood_lamp_top IS
	COMPONENT debounce_top IS
		PORT (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			btnu_in : IN STD_LOGIC;
			btnd_in : IN STD_LOGIC;
			btnl_in : IN STD_LOGIC;
			btnr_in : IN STD_LOGIC;
			btns : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT main IS
		PORT (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			btns : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			params : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT rgb IS
		PORT (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			params : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			led_r : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			led_g : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			led_b : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT pwm IS
		PORT (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			led_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			led_out : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL sig_btns : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL sig_params : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL sig_led_r : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL sig_led_g : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL sig_led_b : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN

	debounce_0 : debounce_top
	PORT MAP(
		clk => clk,
		rst => btnc,
		btnu_in => btnu,
		btnd_in => btnd,
		btnl_in => btnl,
		btnr_in => btnr,
		btns => sig_btns
	);

	main_0 : main
	PORT MAP(
		clk => clk,
		rst => btnc,
		btns => sig_btns,
		params => sig_params
	);

	rgb_0 : rgb
	PORT MAP(
		clk => clk,
		rst => btnc,
		params => sig_params,
		led_r => sig_led_r,
		led_g => sig_led_g,
		led_b => sig_led_b
	);

	pwm_r : pwm
	PORT MAP(
		clk => clk,
		rst => btnc,
		led_in => sig_led_r,
		led_out => led16_r
	);

	pwm_g : pwm
	PORT MAP(
		clk => clk,
		rst => btnc,
		led_in => sig_led_g,
		led_out => led16_g
	);

	pwm_b : pwm
	PORT MAP(
		clk => clk,
		rst => btnc,
		led_in => sig_led_b,
		led_out => led16_b
	);

END Behavioral;