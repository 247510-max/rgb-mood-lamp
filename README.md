# RGB mood lamp
FPGA RGB Mood lamp (VHDL, Nexys A7).  
Cílem projektu je vytvořit RGB Mood lamp na desce Nexys A7 a jazyce VHDL. Projekt používá RGB LED na desce, která přepíná svoje barvy s nastavitelnou rychlostí a jasem.  
Celkem je 16 úrovní rychlosti a 16 úrovní jasu. Rychlost lze nastavovat pomocí tlačítek BTNR (zrychlit o jednu úroveň) a BTNL (zpomalit o jednu úroveň). Jas se nastavuje tlačítky BTNU (zvětšit jas o jednu úroveň) a BTND (snížit jas o jednu úroveň).

## Členové týmu
-Danat Pustynnikov (zodpovědný za vedení gitu, moduly rgb_mood_lamp_top, debounce, main)  
-Alisher Aitken (zodpovědný za poster, moduly rgb a pwm)

## Architektura top levelu

![Image alt](https://github.com/247510-max/rgb-mood-lamp/blob/main/images/top_level_architecture.png)

## Popis modulů
### debounce_top
Přijímá signály tlačítek, vytváří z nich 4bitový vektor a posílá ho na vstup BTNS modulu main.  
Vstupy jsou jednotlivá tlačítka BTNU, BTND, BTNL, BTNR, clock a reset.  
Popis vstupů a výstupů:  
|**Název portu**|**Směr**|**Typ**|**Popis**|
|:-:|:-:|:--|:--|
|clk|in|std_logic|Hodinový signál 100 MHz|
|rst|in|std_logic|Reset|
|btnu_in|in|std_logic| Horní tlačítko|
|btnd_in|in|std_logic| Dolní tlačítko|
|btnl_in|in|std_logic| Levé tlačítko|
|btnr_in|in|std_logic| Pravé tlačítko|
|btns|out|std_logic_vector (3 downto 0)| Výstup hodnot tlačítek |
#### Testbench

![Image alt](https://github.com/247510-max/rgb-mood-lamp/blob/main/images/testbenches/debounce_top_tb.png)

### main
Kontroluje nastavení rychlostí přepínání a jasu RGB LED  
Vstupy jsou clock, reset, 4bitový vektor BTNS (vektor hodnot tlačítek).  
Výstupem je 8bitový vektor PARAMS (první 4 bity je parametr jasu, druhé 4 bity je parametr rychlostí).  
Popis vstupů a výstupů:
|**Název portu**|**Směr**|**Typ**|**Popis**|
|:-:|:-:|:--|:--|
|clk|in|std_logic|Hodinový signál 100 MHz|
|rst|in|std_logic|Reset|
|btns|in|std_logic_vector (3 downto 0)|Vektor hodnot tlačítek|
|params|out|std_logic_vector (7 downto 0)|Vektor parametrů: (7 downto 4) - parametr jasu; (3 downto 0) - parametr rychlosti|  

#### Testbench

![Image alt](https://github.com/247510-max/rgb-mood-lamp/blob/main/images/testbenches/main_tb.png)

### rgb
Přijímá parametry rychlostí a jasu RGB z modulu main. Na základě těchto paramtrů řídí celý proces přepínání barev LED.  
Má 6 stavů, které kombinují zvětšení a snížení jasu jednotlivých složek RGB.  
Vstupy jsou CLK, RST a 8bitových vektor PARAMS.  
Výstupem jsou 8bitové parametry jasů kanálů LED, které pak následně jdou na PWM moduly.  
Popis vstupů a výstupů:  
|**Název portu**|**Směr**|**Typ**|**Popis**|
|:-:|:-:|:--|:--|
|clk|in|std_logic|Hodinový signál 100 MHz|
|rst|in|std_logic|Reset|
|params|in|std_logic_vector (7 downto 0)|Vektor parametrů|
|led_r|out|std_logic_vektor (7 downto 0)|Vektor jasu červené složky|
|led_g|out|std_logic_vektor (7 downto 0)|Vektor jasu zelené složky|
|led_b|out|std_logic_vektor (7 downto 0)|Vektor jasu modré složky|
### pwm
PWM modulace 8bitového signálu ze vstupu LED_IN.
Používá komponentu clk_en s parametrem G_MAX = 400, což pro 8bitový převodník odpovídá kmitočtu PWM přibližně 1 kHz.  
Popis vstupů a výstupů:  
|**Název portu**|**Směr**|**Typ**|**Popis**|
|:-:|:-:|:--|:--|
|clk|in|std_logic|Hodinový signál 100 MHz|
|rst|in|std_logic|Reset|
|led_in|in|std_logic_vector (7 downto 0)|Vektor jasu|
|led_out|out|std_logic|PWM signál|
#### Testbench

![Image alt](https://github.com/247510-max/rgb-mood-lamp/blob/main/images/testbenches/pwm_tb.png)

### rgb_mood_lamp_top
Top level modul, který sjednocuje všichny moduly dohromady.  
Popis vstupů a výstupů:  
|**Název portu**|**Směr**|**Typ**|**Popis**|
|:-:|:-:|:--|:--|
|clk|in|std_logic|Hodinový signál 100 MHz|
|btnc|in|std_logic|Centrální tlačítko|
|btnu|in|std_logic|Horní tlačítko|
|btnd|in|std_logic|Dolní tlačítko|
|btnl|in|std_logic|Levé tlačítko|
|btnr|in|std_logic|Pravé tlačítko|
|led16_r|out|std_logic|Červená složka RGB LED|
|led16_g|out|std_logic|Zelená složka RGB LED|
|led16_b|out|std_logic|Modrá složka RGB LED|  

Popis signálů:  
|**Název signálu**|**Typ**|**Popis**|
|:-:|:--|:--|
|sig_btns|std_logic_vector (3 downto 0)|Vektor hodnot tlačítek|
|sig_params|std_logic_vector (7 downto 0)|Vektor hodnot parametrů|
|sig_led_r|std_logic_vector (7 downto 0)|Jas červené složky RGB|
|sig_led_g|std_logic_vector (7 downto 0)|Jas zelené složky RGB|
|sig_led_b|std_logic_vector (7 downto 0)|Jas modré složky RGB|
