----------------------------------------------------------------------------------
-- Company: Brno University of Technology
-- Engineer: Danat Pustynnikov, Alisher Aitken
-- Design Name: main.vhd
-- Module Name: main - Behavioral
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

ENTITY main IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		btns : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- tlacitka: [3]=leve tlacitko, [2]=prave tlacitko, [1]=horni tlacitko, [0]=dolni tlacitko
		params : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- parametry: [7:4]=jas, [3:0]=rychlost
	);
END main;

ARCHITECTURE Behavioral OF main IS

	SIGNAL brightness : unsigned(3 DOWNTO 0) := "1000"; -- vychozi hodnota jasu
	SIGNAL speed : unsigned(3 DOWNTO 0) := "1000";  -- vychozi hodnota rychlosti prelevani
BEGIN

	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF rst = '1' THEN
				brightness <= "1000";
				speed <= "1000";
			ELSE
				IF btns(1) = '1' THEN -- zvysit jas
					brightness <= brightness + 1;

				ELSIF btns(0) = '1' THEN -- snizit jas
					brightness <= brightness - 1;

				ELSIF btns(3) = '1' THEN -- zpomalit
					speed <= speed - 1;

				ELSIF btns(2) = '1' THEN -- zrychlit
					speed <= speed + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	params <= STD_LOGIC_VECTOR(brightness) & STD_LOGIC_VECTOR(speed); --vystupni vektor parametru

END Behavioral;