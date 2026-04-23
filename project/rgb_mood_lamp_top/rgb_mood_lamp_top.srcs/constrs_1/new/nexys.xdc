## Clock 100 MHz
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports {clk}]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0.000 5.000} [get_ports {clk}]

## Buttons
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports {btnc}]  ;# Center button (used as Reset)
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports {btnu}]  ;# Up
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports {btnd}]  ;# Down
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports {btnl}]  ;# Left
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports {btnr}]  ;# Right

## RGB LED16 (LD16)
set_property -dict { PACKAGE_PIN N15 IOSTANDARD LVCMOS33 } [get_ports {led16_r}]  ;# Red
set_property -dict { PACKAGE_PIN M16 IOSTANDARD LVCMOS33 } [get_ports {led16_g}]  ;# Green
set_property -dict { PACKAGE_PIN R12 IOSTANDARD LVCMOS33 } [get_ports {led16_b}]  ;# Blue