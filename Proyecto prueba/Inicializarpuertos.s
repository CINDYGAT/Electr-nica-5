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
 
PCTL  EQU 0x00000002  ; Configuración para PF1 
PCTL2 EQU 0x00000010  ; Configuración para PE4 
 
    AREA    |.text|, CODE, READONLY, ALIGN=2 
    THUMB 
    EXPORT  Inicializarpuertos 
 
Inicializarpuertos 
;---------Habilita reloj para puertos E y F--------------- 
    LDR R1, =SYSCTL_RCGCGPIO_R 
    LDR R0, [R1] 
    ORR R0, R0, #0x30  ; Habilita E (0x20) y F (0x10) 
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
 
;---------Configuración del Puerto E (PE4, PE1, PE2)-- 
    ; Desactiva modo analógico 
    LDR R1, =GPIO_PORTE_AMSEL_R 
    LDR R0, [R1] 
    BIC R0, R0, #0x17  ;  
    STR R0, [R1] 
     
    LDR R1, =GPIO_PORTE_PCTL_R 
    LDR R0, [R1] 
    BIC R0, R0, #0x000F000F   
    STR R0, [R1] 
   
    LDR R1, =GPIO_PORTE_DIR_R 
    LDR R0, [R1] 
    ORR R0, R0, #0x17   
    STR R0, [R1] 
   ;--------Deshabilita las funciones alternativas--------- 
 LDR R1, =GPIO_PORTE_AFSEL_R 
 LDR R0, [R1] 
 BIC R0, R0, #0x17  
 STR R0, [R1] 
    ; Habilita digital 
    LDR R1, =GPIO_PORTE_DEN_R 
 
    LDR R0, [R1] 
    ORR R0, R0, #0x17   
    STR R0, [R1] 
 
    BX  LR   
    ALIGN 
    END 