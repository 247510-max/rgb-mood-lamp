----------------------------------------------------------------------------------
-- Company: Brno University of Technology
-- Engineer: Danat Pustynnikov, Alisher Aitken
-- Design Name: rgb.vhd
-- Module Name: rgb - Behavioral
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY rgb IS
	GENERIC
	(
		CLK_FREQ_HZ : INTEGER := 100_000_000
	);
	PORT
	(
		CLK : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		PARAMS : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- vtupni vektor hodnot parametru
		LED_R : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- 8bitova hodnota jasu cervene slozky RGB
		LED_G : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- 8bitova hodnota jasu zeleny slozky RGB
		LED_B : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  -- 8bitova hodnota jasu modre slozky RGB
	);
END ENTITY rgb;

ARCHITECTURE Behavioral OF rgb IS

	CONSTANT CYCLE_SLOW_TICKS : INTEGER := 10 * CLK_FREQ_HZ;
	CONSTANT CYCLE_FAST_TICKS : INTEGER := CLK_FREQ_HZ / 2;

	CONSTANT STEP_SLOW_TICKS : INTEGER := CYCLE_SLOW_TICKS / 256;
	CONSTANT STEP_FAST_TICKS : INTEGER := CYCLE_FAST_TICKS / 256;

	SIGNAL speed_sel : unsigned(3 DOWNTO 0);
	SIGNAL bright_sel : unsigned(3 DOWNTO 0);

	SIGNAL color_pos : unsigned(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL tick_counter : INTEGER := 0;
	SIGNAL step_limit : INTEGER := STEP_SLOW_TICKS;

	SIGNAL r_base, g_base, b_base : unsigned(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL r_out, g_out, b_out : unsigned(7 DOWNTO 0) := (OTHERS => '0');

BEGIN

	-- PARAMS = SSSSBBBB
	speed_sel <= unsigned(PARAMS(7 DOWNTO 4));
	bright_sel <= unsigned(PARAMS(3 DOWNTO 0));

	-- vypocet rychlosti prelevani
	PROCESS (speed_sel)
		VARIABLE s : INTEGER;
	BEGIN
		s := to_integer(speed_sel);
		step_limit <= STEP_SLOW_TICKS
			- (s * (STEP_SLOW_TICKS - STEP_FAST_TICKS)) / 15;
	END PROCESS;

	-- citac zmeny barvy
	PROCESS (CLK)
	BEGIN
		IF rising_edge(CLK) THEN
			IF RST = '1' THEN
				tick_counter <= 0;
				color_pos <= (OTHERS => '0');
			ELSE
				IF tick_counter >= step_limit - 1 THEN
					tick_counter <= 0;
					color_pos <= color_pos + 1;
				ELSE
					tick_counter <= tick_counter + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	-- zakladni RGB barvy podle color_pos
	PROCESS (color_pos)
		VARIABLE pos : INTEGER RANGE 0 TO 255;
		VARIABLE region : INTEGER RANGE 0 TO 5;
		VARIABLE offs : INTEGER RANGE 0 TO 42;
		VARIABLE level : INTEGER RANGE 0 TO 255;
	BEGIN
		pos := to_integer(color_pos);
		region := pos / 43;
		offs := pos MOD 43;
		level := (offs * 255) / 42;

		CASE region IS
			WHEN 0 =>
				r_base <= to_unsigned(255, 8);
				g_base <= to_unsigned(level, 8);
				b_base <= to_unsigned(0, 8);

			WHEN 1 =>
				r_base <= to_unsigned(255 - level, 8);
				g_base <= to_unsigned(255, 8);
				b_base <= to_unsigned(0, 8);

			WHEN 2 =>
				r_base <= to_unsigned(0, 8);
				g_base <= to_unsigned(255, 8);
				b_base <= to_unsigned(level, 8);

			WHEN 3 =>
				r_base <= to_unsigned(0, 8);
				g_base <= to_unsigned(255 - level, 8);
				b_base <= to_unsigned(255, 8);

			WHEN 4 =>
				r_base <= to_unsigned(level, 8);
				g_base <= to_unsigned(0, 8);
				b_base <= to_unsigned(255, 8);

			WHEN OTHERS =>
				r_base <= to_unsigned(255, 8);
				g_base <= to_unsigned(0, 8);
				b_base <= to_unsigned(255 - level, 8);
		END CASE;
	END PROCESS;

	-- omezeni jasu
	PROCESS (r_base, g_base, b_base, bright_sel)
		VARIABLE bright_int : INTEGER RANGE 0 TO 15;
		VARIABLE r_int : INTEGER RANGE 0 TO 255;
		VARIABLE g_int : INTEGER RANGE 0 TO 255;
		VARIABLE b_int : INTEGER RANGE 0 TO 255;
	BEGIN
		bright_int := to_integer(bright_sel);

		r_int := (to_integer(r_base) * bright_int) / 15;
		g_int := (to_integer(g_base) * bright_int) / 15;
		b_int := (to_integer(b_base) * bright_int) / 15;
		r_out <= to_unsigned(r_int, 8);
		g_out <= to_unsigned(g_int, 8);
		b_out <= to_unsigned(b_int, 8);
	END PROCESS;

	LED_R <= STD_LOGIC_VECTOR(r_out);
	LED_G <= STD_LOGIC_VECTOR(g_out);
	LED_B <= STD_LOGIC_VECTOR(b_out);

END ARCHITECTURE Behavioral;