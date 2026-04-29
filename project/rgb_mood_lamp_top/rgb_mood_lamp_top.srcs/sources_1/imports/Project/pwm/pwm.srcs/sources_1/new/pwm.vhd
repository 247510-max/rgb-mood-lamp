----------------------------------------------------------------------------------
-- Company: Brno University of Technology
-- Engineer: Danat Pustynnikov, Alisher Aitken
-- Design Name: pwm.vhd
-- Module Name: pwm - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

ENTITY pwm IS
	PORT
	(
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		led_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- vstupni vektor jasu
		led_out : OUT STD_LOGIC); -- vystupni PWM signal
END pwm;

ARCHITECTURE Behavioral OF pwm IS

	SIGNAL ce_sample : STD_LOGIC; -- signal clk_en
	SIGNAL counter : unsigned (7 DOWNTO 0) := (OTHERS => '0'); -- citac
	COMPONENT clk_en IS
		GENERIC
			(G_MAX : POSITIVE);
		PORT
		(
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			ce : OUT STD_LOGIC
		);
	END COMPONENT clk_en;

BEGIN

	clock_0 : clk_en
	GENERIC
	MAP(G_MAX => 400) -- hodnota G_MAX pro 8bitovy prevodnik, odpovida kmitoctu PWM prevodniku priblizne 1 kHz
	PORT MAP
	(
		clk => clk,
		rst => rst,
		ce => ce_sample
	);

	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			counter <= (OTHERS => '0');
			led_out <= '0';
		ELSIF rising_edge (clk) THEN
			IF ce_sample = '1' THEN
				counter <= counter + 1;
				IF counter < unsigned(led_in) THEN  -- hodnota vystupu prevodniku v periode bude HIGH dokud citac nenarazi na prevadenou hodnou, pak bude v LOW
					led_out <= '1';
				ELSE
					led_out <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS;

END Behavioral;