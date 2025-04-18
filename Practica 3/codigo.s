;Este programa configura dos puertos GPIO en un microcontrolador Tiva TM4C:
;Puerto A (PA4 y PA5): Se usa como entrada para leer un bot?n.
;Puerto C (PC4 y PC5): se usa como salida para controlar un led (indicador visual)


;---------Reloj de la Tiva--------------------------------
SYSCTL_RCGCGPIO_R 	   EQU 0x400FE608
	
;---------------------------------Configuraciones Puerto A------------------------------------------	
;---------Modo Anal?gico----------------------------------
GPIO_PORTA_AMSEL_R     EQU 0x40004528;
;---------Permite desactivarFuncion Alternativa-----------
GPIO_PORTA_PCTL_R      EQU 0x4000452C;
;---------Especificaci?n de direcci?n---------------------
GPIO_PORTA_DIR_R      EQU  0x40004400;
;---------Funciones Alternativas--------------------------
GPIO_PORTA_AFSEL_R    EQU  0x40004420;
;---------Habilita el modo digital------------------------
GPIO_PORTA_DEN_R      EQU   0x4000451C;
;---------Registro Pull-Up para Puerto A-----------------
GPIO_PORTA_PUR_R     EQU 0x40004510    ; Direcci?n del registro PUR para el puerto A
	
	
;-------------------------------------Configuraciones Puerto C-------------------------------------------------	
;---------Modo Anal?gico----------------------------------
GPIO_PORTC_AMSEL_R     EQU 0x40006528;
;---------Permite desactivarFuncion Alternativa-----------
GPIO_PORTC_PCTL_R      EQU 0x4000652C;
;---------Especificaci?n de direcci?n---------------------
GPIO_PORTC_DIR_R      EQU  0x40006400;
;---------Funciones Alternativas--------------------------
GPIO_PORTC_AFSEL_R    EQU  0x40006420;
;---------Habilita el modo digital------------------------
GPIO_PORTC_DEN_R      EQU   0x4000651C;
	


	
;PCTL 	  EQU 2_00110000; Valor del pin utilizado en el puerto A4, A5 Y C4, C5

	
PA4       EQU 0x40004040; Puerto A2 ser? el boton. 
PA5 	  EQU 0x40004080; Puerto A2 ser? el boton.
PC4       EQU 0x40006040; Puerto C5 ser? el LED.
PC5       EQU 0x40006080; Puerto C5 ser? el LED.	
	
	AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
Start
	BL Configuracion
	B LecturaA4
	
Configuracion
;habilita el reloj de la tiva para el puerto F + puerto A
	LDR R1, =SYSCTL_RCGCGPIO_R; Asignaci?n de valores de constante a un registro.
	LDR R0, [R1]
	ORR R0, R0, #0x05 ; Valor para activar el reloj del puerto A + Puerto C
	STR R0, [R1]
	NOP
	NOP
	
	
 ;-------------------------------------------Reloj para el puerto A---------------------------------------------------------------	
;--------Desactiva la funci?n anal?gica------------------
	LDR R1, =GPIO_PORTA_AMSEL_R;
	LDR R0, [R1]	
	BIC R0, R0, #0x30; Valor segun el numero del puerto.
	STR R0, [R1]
;--------Permite deshabilitar las funciones alternativas-
	LDR R1, =GPIO_PORTA_PCTL_R
	LDR R0, [R1]
	BIC R0, R0, #0x00FF0000  ; Limpia nibbles de PA4 (bits 16-19) y PA5 (bits 20-23)
	STR R0, [R1]
;--------Configuraci?n como I/O--------------------------
	LDR R1, =GPIO_PORTA_DIR_R 
	LDR R0, [R1]
	BIC R0, R0, #0x30;  Input. Valor segun el numero del puerto.
	STR R0, [R1]
;--------Deshabilita las funciones alternativas----------	
	LDR R1, =GPIO_PORTA_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x30;  Desabilita las demas funciones. 
	STR R0, [R1]
;--------Habilita el puerto como entrada y salida digital-
	LDR R1, =GPIO_PORTA_DEN_R       
    LDR R0, [R1]                    
    ORR	 R0,#0x30;		Activa el puerto digital.    
    STR R0, [R1]     

;-------------Configura PA2 como entrada con pull-up----------------------
    LDR R1, =GPIO_PORTA_PUR_R  ; Aseg?rate de definir esta direcci?n: 0x40004510
    LDR R0, [R1]
    ORR R0, R0, #0x30          ; Habilita pull-up en PA2
    STR R0, [R1]

;-----------------------------------------------------Puerto C5---------------------------------------------------------------	
;--------Desactiva la funci?n anal?gica------------------
	LDR R1, =GPIO_PORTC_AMSEL_R;
	LDR R0, [R1]	
	BIC R0, R0, #0x30; Valor segun el numero del puerto. PB5
	STR R0, [R1]
;--------Permite deshabilitar las funciones alternativas-
	LDR R1, =GPIO_PORTC_PCTL_R
	LDR R0, [R1]
	BIC R0, R0, #0x00FF0000  ; Limpia nibbles de PC4 (bits 16-19) y Pc5 (bits 20-23)
	STR R0, [R1]
;--------Configuraci?n como I/O--------------------------
	LDR R1, =GPIO_PORTC_DIR_R 
	LDR R0, [R1]
	ORR R0, R0, #0x30;  Output. Valor segun el numero del puerto.
	STR R0, [R1]
;--------Deshabilita las funciones alternativas----------	
	LDR R1, =GPIO_PORTC_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x30;  Desabilita las demas funciones. 
	STR R0, [R1]
;--------Habilita el puerto como entrada y salida digital-
	LDR R1, =GPIO_PORTC_DEN_R       
    LDR R0, [R1]                    
    ORR	 R0,#0x30;		Activa el puerto digital.    
    STR R0, [R1]
	
	
;---------------------------------------leer pin PA5------------------------------------------------------------------	
LecturaA4
    LDR R1, =PA4      
    LDR R0, [R1]      
	AND R0, R0, #0x10  ; A?sla el bit 2 (PA2)
    CMP R0, #0x00      ; Compara si el bot?n est? presionado (LOW, porque est? en pull-up)
    BEQ Activo4         ; Si es 0 (GND), bot?n presionado
    B Apagado4          ; Si es 1, bot?n no presionado
	
;--------Subrutina si el boton est? pulsado A4------------------	
Activo4
	LDR R1, =PC4					; Enciende LED 1 Pc4
	LDR R0, =0x10					
	STR R0, [R1]

    B   LecturaA5
	
;--------Subrutina si el boton no est? pulsado A4------------------		
Apagado4
	LDR R1, =PC4
	MOV R0, #0x00; Apagar el bit.
	STR R0, [R1];

    B   LecturaA5

;-------------------------------leer pin PA5--------------------------------------------
LecturaA5
	LDR R1, =PA5      
    LDR R0, [R1]      
	AND R0, R0, #0x20  ; A?sla el bit 2 (PA2)
    CMP R0, #0x00      ; Compara si el bot?n est? presionado (LOW, porque est? en pull-up)
    BEQ Activo5         ; Si es 0 (GND), bot?n presionado
    B Apagado5          ; Si es 1, bot?n no presionado
;--------Subrutina si el boton est? pulsado A5------------------	
Activo5
	LDR R1, =PC5					; Enciende LED 1 Pc5
	LDR R0, =0x20					
	STR R0, [R1]

    B   LecturaA4


;--------Subrutina si el boton no est? pulsado A5------------------		
Apagado5
	LDR R1, =PC5
	MOV R0, #0x00; Apagar el bit.
	STR R0, [R1];

    B   LecturaA4


    ALIGN                           
    END 