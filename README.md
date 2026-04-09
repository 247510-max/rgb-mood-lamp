# RGB mood lamp
FPGA RGB Mood lamp (VHDL, Nexys A7).  
Cílem projektu je vytvořit RGB Mood lamp na desce Nexys A7 a jazyce VHDL. Projekt používá RGB LED na desce, která přepíná svoje barvy s předem nastavenou rychlostí a jasem.

## Členové týmu
-Danat Pustynnikov (zodpovědný za vedení gitu, moduly rgb_mood_lamp_top, debounce, main)  
-Alisher Aitken (zodpovědný za poster, moduly rgb a pwm)

## Architektura top levelu

![Image alt](https://github.com/247510-max/rgb-mood-lamp/blob/main/images/top_level_architecture.png)

## Popis modulů
### debounce
Přijímá signály tlačítek, vytváří z nich 4bitový vektor a posílá ho na vstup BTNS modulu main.  
Vstupy jsou jednotlivá tlačítka BTNU, BTND, BTNL, BTNR, clock a reset.
### main
Kontroluje nastavení rychlostí přepínání a jasu RGB LED  
Vstupy jsou clock, reset, 4bitový vektor BTNS (vektor hodnot tlačítek).  
Výstupem je 8bitový vektor PARAMS (první 4 bity je parametr jasu, druhé 4 bity je parametr rychlostí).
### rgb
Přijímá parametry rychlostí a jasu RGB z modulu main. Na základě těchto paramtrů řídí celý proces přepínání barev LED.  
Má 6 stavů, které kombinují zvětšení a snížení jasu jednotlivých složek RGB.  
Vstupy jsou CLK, RST a 8bitových vektor PARAMS.  
Výstupem jsou 8butové parametry jasů kanálů LED, které pak následně jdou na PWM moduly.
### pwm
PWM modulace
