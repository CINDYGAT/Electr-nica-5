;---------Reloj de la Tiva-------------------------------- 
SYSCTL_RCGCGPIO_R     EQU 0x400FE608 
;---------PUERTO F---------------------------------------- 
GPIO_PORTF_AMSEL_R     EQU 0x40025528 
GPIO_PORTF_PCTL_R      EQU 0x4002552C 
GPIO_PORTF_DIR_R       EQU 0x40025400 
GPIO_PORTF_AFSEL_R     EQU 0x40025420 
GPIO_PORTF_DEN_R       EQU 0x4002551C 
;---------PUERTO E---------------------------------------- 
GPIO_PORTE_AMSEL_R     EQU 0x40024528 
GPIO_PORTE_PCTL_R      EQU 0x4002452C 
GPIO_PORTE_DIR_R       EQU 0x40024400 
GPIO_PORTE_AFSEL_R     EQU 0x40024420 
GPIO_PORTE_DEN_R       EQU 0x4002451C 
	
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
;---------Registro Pull-Up para Puerto A-----------------
GPIO_PORTA_PUR_R     EQU 0x40004510    ; Dirección del registro PUR para PA2
 
PCTL 	  EQU 2_00001100; Valor del pin utilizado en el puerto A (0x04 + 0x08 en hexadecimal)
PCTL2 EQU 0x00011001  ; Configuración para PE4 

PA2       EQU 0x40004010; Puerto A2 será el boton. 
PA3       EQU 0x40004020; Puerto A3 será el boton. 
 
    AREA    |.text|, CODE, READONLY, ALIGN=2 
    THUMB 
    EXPORT  Inicializarpuertos 
 
Inicializarpuertos 
;---------Habilita reloj para puertos E y F--------------- 
    LDR R1, =SYSCTL_RCGCGPIO_R 
    LDR R0, [R1] 
    ORR R0, R0, #0x31  ; Habilita E (0x20) y F (0x10) 
    STR R0, [R1] 
    NOP 
    NOP 
    NOP 
 
;---------Configuración del Puerto F (PF1)---------------- 
    ; Desactiva modo analógico 
    LDR R1, =GPIO_PORTF_AMSEL_R 
    LDR R0, [R1] 
    BIC R0, R0, #0x02  ; PF1 
 
    STR R0, [R1] 
    ; Configura como GPIO 
    LDR R1, =GPIO_PORTF_PCTL_R 
    LDR R0, [R1] 
    BIC R0, R0, #0x000000F0   
    STR R0, [R1] 
     
    LDR R1, =GPIO_PORTF_DIR_R 
    LDR R0, [R1] 
    ORR R0, R0, #0x02  ; PF1 como salida 
    STR R0, [R1] 
   ;--------Deshabilita las funciones alternativas--------- 
 LDR R1, =GPIO_PORTF_AFSEL_R 
 LDR R0, [R1] 
 BIC R0, R0, #0x02;  Desabilita las demas funciones.  
 STR R0, [R1] 
    ; Habilita digital 
    LDR R1, =GPIO_PORTF_DEN_R 
    LDR R0, [R1] 
    ORR R0, R0, #0x02  ; Habilita PF1 
    STR R0, [R1] 
 
;---------Configuración del Puerto E (PE0, PE1, PE2, PE3, PE4)-- 
    ; Desactiva modo analógico 
    LDR R1, =GPIO_PORTE_AMSEL_R 
    LDR R0, [R1] 
    BIC R0, R0, #0x1F  ;  
    STR R0, [R1] 
     
    LDR R1, =GPIO_PORTE_PCTL_R 
    LDR R0, [R1] 
    BIC R0, R0, #0x000F000F   
    STR R0, [R1] 
   
    LDR R1, =GPIO_PORTE_DIR_R 
    LDR R0, [R1] 
    ORR R0, R0, #0x1F   
    STR R0, [R1] 
   ;--------Deshabilita las funciones alternativas--------- 
    LDR R1, =GPIO_PORTE_AFSEL_R 
    LDR R0, [R1] 
    BIC R0, R0, #0x1F  
    STR R0, [R1] 
    ; Habilita digital 
    LDR R1, =GPIO_PORTE_DEN_R 
    LDR R0, [R1] 
    ORR R0, R0, #0x1F   
    STR R0, [R1] 
	
	;-------------------------------------------Reloj para el puerto A---------------------------------------------------------------	
;--------Desactiva la función analógica------------------
	LDR R1, =GPIO_PORTA_AMSEL_R;
	LDR R0, [R1]	
	BIC R0, R0, #0x0C; Valor segun el numero del puerto.
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
	BIC R0, R0, #0x0C;  Input. Valor segun el numero del puerto.
	STR R0, [R1]
;--------Deshabilita las funciones alternativas----------	
	LDR R1, =GPIO_PORTA_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x0C;  Desabilita las demas funciones. 
	STR R0, [R1]
;--------Habilita el puerto como entrada y salida digital-
	LDR R1, =GPIO_PORTA_DEN_R       
    LDR R0, [R1]                    
    ORR	 R0,#0x0C;		Activa el puerto digital.    
    STR R0, [R1]     

;-------------Configura PA2 como entrada con pull-up----------------------
    LDR R1, =GPIO_PORTA_PUR_R  ; Asegúrate de definir esta dirección: 0x40004510
    LDR R0, [R1]
    ORR R0, R0, #0x0C          ; Habilita pull-up en PA2
    STR R0, [R1]
 
    BX  LR   
    ALIGN 
    END 