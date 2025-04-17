# Electronica-5
Documentos relacionados al curso de Electrónica 5 - Ensamblador usando Keil Version Placa tm4c123gh6pm

Reloj puerto F = 0x20

Led Rojo = 0x02, PF1 = 0x40025008, BIC R0, R0, #2_00000010;

Led Azul = 0x04,  PF2 = 0x40025010, BIC R0, R0, #2_00001100;

Led Verde = 0x08, PF3 = 0x40025020

Led Morado = 0x06, PF1 + PF2 = 0x40025038, BIC R0, R0, #0x000000FF;

** Botones **
Registro	Función
SYSCTL_RCGCGPIO_R	Habilita reloj para GPIO.

GPIO_PORTF_DIR_R	Configura pines como entrada/salida.

GPIO_PORTF_PUR_R	Activa resistencias Pull-Up para botones.

GPIO_PORTF_DEN_R	Habilita modo digital.

GPIO_PORTF_DATA_R	Lee/escribe estados de pines (botones/LEDs).
