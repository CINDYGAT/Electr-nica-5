;Este programa configura dos puertos GPIO en un microcontrolador Tiva TM4C:
;Puerto A (PA2): Se usa como entrada para leer un botón.
;Puerto F (PF1): Se usa como salida para controlar un LED (indicador visual).
;Puerto B (PB5): se usa como salida para controlar un led (indicador visual)
;Puerto C (PC5): se usa como salida para controlar un led (indicador visual)
;Conecta PA2 a una terminal del SW1 y la otra terminal a GND.
;Si se presiona PA2, se enciende el led PF1, PC5 y PB5 led, si se deja de presionar, se apaga el LED PF1, PC5 y el led PB5.

;---------Reloj de la Tiva--------------------------------
SYSCTL_RCGCGPIO_R 	   EQU 0x400FE608
	
;---------Configuraciones Puerto A-----------------------	
;---------Modo Analógico----------------------------------
GPIO_PORTA_AMSEL_R     EQU 0x40004528;
;---------Permite desactivarFuncion Alternativa-----------
GPIO_PORTA_PCTL_R      EQU 0x4000452C;
;---------Especificación de dirección---------------------
GPIO_PORTA_DIR_R      EQU  0x40004400;
;---------Funciones Alternativas--------------------------
GPIO_PORTA_AFSEL_R    EQU  0x40004420;
;---------Habilita el modo digital------------------------
GPIO_PORTA_DEN_R      EQU   0x4000451C;
	
;---------Configuraciones Puerto B-----------------------	
;---------Modo Analógico----------------------------------
GPIO_PORTB_AMSEL_R     EQU 0x40005528;
;---------Permite desactivarFuncion Alternativa-----------
GPIO_PORTB_PCTL_R      EQU 0x4000552C;
;---------Especificación de dirección---------------------
GPIO_PORTB_DIR_R      EQU  0x40005400;
;---------Funciones Alternativas--------------------------
GPIO_PORTB_AFSEL_R    EQU  0x40005420;
;---------Habilita el modo digital------------------------
GPIO_PORTB_DEN_R      EQU   0x4000551C;
	
;---------Configuraciones Puerto C-----------------------	
;---------Modo Analógico----------------------------------
GPIO_PORTC_AMSEL_R     EQU 0x40006528;
;---------Permite desactivarFuncion Alternativa-----------
GPIO_PORTC_PCTL_R      EQU 0x4000652C;
;---------Especificación de dirección---------------------
GPIO_PORTC_DIR_R      EQU  0x40006400;
;---------Funciones Alternativas--------------------------
GPIO_PORTC_AFSEL_R    EQU  0x40006420;
;---------Habilita el modo digital------------------------
GPIO_PORTC_DEN_R      EQU   0x4000651C;
	
;---------Configuraciones puerto F
;---------Modo Analógico----------------------------------
GPIO_PORTF_AMSEL_R     EQU 0x40025528;
;---------Permite desactivarFuncion Alternativa-----------
GPIO_PORTF_PCTL_R      EQU 0x4002552C;
;---------Especificación de dirección---------------------
GPIO_PORTF_DIR_R      EQU   0x40025400;
;---------Funciones Alternativas--------------------------
GPIO_PORTF_AFSEL_R    EQU   0x40025420;
;---------Habilita el modo digital------------------------
GPIO_PORTF_DEN_R      EQU   0x4002551C;
;---------PIN PF1-----------------------------------------

;---------Registro Pull-Up para Puerto A-----------------
GPIO_PORTA_PUR_R     EQU 0x40004510    ; Dirección del registro PUR para PA2
	
PCTL 	  EQU 2_00000100; Valor del pin utilizado en el puerto A (0x04 en hexadecimal)
PCTL2 	  EQU 2_00100000; Para PB5 y PC5 (0x20 en hexadecimal)
	
PA2       EQU 0x40004010; Puerto A2 será el boton. 
PF1       EQU 0x40025008; LED Indicador de boton pulsado
PB5       EQU 0x40005080; Puerto B5 será el led.
PC5       EQU 0x40006080; Puerto C5 será el boton.	
	
	AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
Start
	BL Configuracion
	B Lectura
	
Configuracion
;habilita el reloj de la tiva para el puerto F + puerto A
	LDR R1, =SYSCTL_RCGCGPIO_R; Asignación de valores de constante a un registro.
	LDR R0, [R1]
	ORR R0, R0, #0x27 ; Valor para activar el reloj del puerto A + puerto F + Puerto B + Puerto C
	STR R0, [R1]
	NOP
	NOP
	
	
 ;-------------------------------------------Reloj para el puerto A---------------------------------------------------------------	
;--------Desactiva la función analógica------------------
	LDR R1, =GPIO_PORTA_AMSEL_R;
	LDR R0, [R1]	
	BIC R0, R0, #0x04; Valor segun el numero del puerto.
	STR R0, [R1]
;--------Permite deshabilitar las funciones alternativas-
	LDR R1, =GPIO_PORTA_PCTL_R 
	LDR R0, [R1]
	LDR R2, =PCTL
	LDR R3,[R2]
	BIC R0, R0, R3;  Configura el puerto como GPIO. 
	STR R0, [R1]
;--------Configuración como I/O--------------------------
	LDR R1, =GPIO_PORTA_DIR_R 
	LDR R0, [R1]
	BIC R0, R0, #0x04;  Input. Valor segun el numero del puerto.
	STR R0, [R1]
;--------Deshabilita las funciones alternativas----------	
	LDR R1, =GPIO_PORTA_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x04;  Desabilita las demas funciones. 
	STR R0, [R1]
;--------Habilita el puerto como entrada y salida digital-
	LDR R1, =GPIO_PORTA_DEN_R       
    LDR R0, [R1]                    
    ORR	 R0,#0x04;		Activa el puerto digital.    
    STR R0, [R1]     

;-------------Configura PA2 como entrada con pull-up----------------------
    LDR R1, =GPIO_PORTA_PUR_R  ; Asegúrate de definir esta dirección: 0x40004510
    LDR R0, [R1]
    ORR R0, R0, #0x04          ; Habilita pull-up en PA2
    STR R0, [R1]
   
;----------------------------------------Reloj para el puerto B5-------------------------------------------------------------------------	
;--------Desactiva la función analógica------------------
	LDR R1, =GPIO_PORTB_AMSEL_R;
	LDR R0, [R1]	
	BIC R0, R0, #0x20; Valor segun el numero del puerto. PB5
	STR R0, [R1]
;--------Permite deshabilitar las funciones alternativas-
	LDR R1, =GPIO_PORTB_PCTL_R 
	LDR R0, [R1]
	LDR R2, =PCTL2
	LDR R3,[R2]
	BIC R0, R0, R3;  Configura el puerto como GPIO. 
	STR R0, [R1]
;--------Configuración como I/O--------------------------
	LDR R1, =GPIO_PORTB_DIR_R 
	LDR R0, [R1]
	ORR R0, R0, #0x20;  Output. Valor segun el numero del puerto.
	STR R0, [R1]
;--------Deshabilita las funciones alternativas----------	
	LDR R1, =GPIO_PORTB_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x20;  Desabilita las demas funciones. 
	STR R0, [R1]
;--------Habilita el puerto como entrada y salida digital-
	LDR R1, =GPIO_PORTB_DEN_R       
    LDR R0, [R1]                    
    ORR	 R0,#0x20;		Activa el puerto digital.    
    STR R0, [R1]   

;-----------------------------------------------------Puerto C5---------------------------------------------------------------	
;--------Desactiva la función analógica------------------
	LDR R1, =GPIO_PORTC_AMSEL_R;
	LDR R0, [R1]	
	BIC R0, R0, #0x20; Valor segun el numero del puerto. PB5
	STR R0, [R1]
;--------Permite deshabilitar las funciones alternativas-
	LDR R1, =GPIO_PORTC_PCTL_R 
	LDR R0, [R1]
	LDR R2, =PCTL2
	LDR R3,[R2]
	BIC R0, R0, R3;  Configura el puerto como GPIO. 
	STR R0, [R1]
;--------Configuración como I/O--------------------------
	LDR R1, =GPIO_PORTC_DIR_R 
	LDR R0, [R1]
	ORR R0, R0, #0x20;  Output. Valor segun el numero del puerto.
	STR R0, [R1]
;--------Deshabilita las funciones alternativas----------	
	LDR R1, =GPIO_PORTC_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x20;  Desabilita las demas funciones. 
	STR R0, [R1]
;--------Habilita el puerto como entrada y salida digital-
	LDR R1, =GPIO_PORTC_DEN_R       
    LDR R0, [R1]                    
    ORR	 R0,#0x20;		Activa el puerto digital.    
    STR R0, [R1]
	
	
;--------------------------------------------------Puerto F -------------------------------------------------------------------------------------
;--------Desactiva la función analógica------------------
	LDR R1, =GPIO_PORTF_AMSEL_R;
	LDR R0, [R1]
	BIC R0, R0, #0x02; Valor segun el numero del puerto. 
	STR R0, [R1]
;--------Permite deshabilitar las funciones alternativas-
	LDR R1, =GPIO_PORTF_PCTL_R 
	LDR R0, [R1]
	BIC R0, R0, #2_00000010;  Configura el puerto como GPIO. 
	STR R0, [R1]
;--------Configuración como I/O--------------------------
	LDR R1, =GPIO_PORTF_DIR_R 
	LDR R0, [R1]
	ORR R0, R0, #0x02;  Output. Valor segun el numero del puerto.
	STR R0, [R1]
;--------Deshabilita las funciones alternativas----------	
	LDR R1, =GPIO_PORTF_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x02;  Desabilita las demas funciones. 
	STR R0, [R1]
;--------Habilita el puerto como entrada y salida digital-
	LDR R1, =GPIO_PORTF_DEN_R       
    LDR R0, [R1]                    
    ORR	 R0,#0x02;		Activa el puerto digital.    
    STR R0, [R1]   
;--------Salto, regresa a la linea posterior al salto BL---
	BX LR
      
	
;--------Lee el estado del puerto PA2----------------------	
Lectura
    LDR R1, =PA2      
    LDR R0, [R1]      
	AND R0, R0, #0x04  ; Aísla el bit 2 (PA2)
    CMP R0, #0x00      ; Compara si el botón está presionado (LOW, porque está en pull-up)
    BEQ Activo         ; Si es 0 (GND), botón presionado
    B Apagado          ; Si es 1, botón no presionado

	
;--------Ciclo de comparación--------------------------------
Ciclo
	CMP R0, #0x04; Boton pulsado                 
    BEQ Activo                  
    CMP R0, #0x00; Boton sin presionar                   
    BEQ Apagado                                 
    B   Lectura
;--------Subrutina si el boton está pulsado------------------	
Activo
	LDR R1, =PF1
	MOV R0, #0x02; Encender el bit.
	STR R0, [R1];
	
	LDR R1, =PB5					; Enciende LED 1 PB5
	LDR R0, =0x20					
	STR R0, [R1]
	
	LDR R1, =PC5					; Enciende LED 1 PC5
	LDR R0, =0x20					
	STR R0, [R1]
	
    B   Lectura
;--------Subrutina si el boton no está pulsado------------------		
Apagado
	LDR R1, =PF1
	MOV R0, #0x00; Apagar el bit.
	STR R0, [R1];
	
	LDR R1, =PB5					; Apaga LED 1 PB5
	LDR R0, =0x00					
	STR R0, [R1]
	
	LDR R1, =PC5					; Apaga LED 1 PC5
	LDR R0, =0x00					
	STR R0, [R1]
	
    B   Lectura


    ALIGN                           
    END 