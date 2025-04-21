 ;---------Direcciones de registros------------------------ 
GPIO_PORTE_DATA  EQU 0x400243FC 
GPIO_PORTF_DATA  EQU 0x400253FC 
GPTM_RCGCTIMER_R EQU 0x400FE604 
GPTM_TIMER0_CFG_R EQU 0x40030000 
GPTM_TIMER0_CTL_R EQU 0x4003000C 
GPTM_TIMER0_TAMR_R EQU 0x40030004 
GPTM_TIMER0_IMR_R EQU 0x40030018 
GPTM_TIMER0_ICR_R EQU 0x40030024 
GPTM_TIMER0_RIS_R EQU 0x4003001C 
GPTM_TIMER0_TAILR_R EQU 0x40030028 
 
Tiempo EQU 4000000   
 
    AREA    RESET, DATA, READONLY
    EXPORT  __Vectors
__Vectors
    DCD     0x20004000  ; Stack pointer (ajusta según tu memoria)
    DCD     Start       ; Reset vector (apunta a tu código de inicio)
        
    AREA    |.text|, CODE, READONLY, ALIGN=2
    THUMB
    EXPORT  Start
    IMPORT  Inicializarpuertos 
 
Start 
    BL  Inicializarpuertos  ; Configura puertos 
    BL  ConfTimer           ; Configura Timer0 
    MOV R5, #0              ; Inicializa contador de estados 
 
 
Ciclo 
    LDR R1, =GPTM_TIMER0_RIS_R 
    LDR R0, [R1] 
    CMP R0, #0x1 
    BEQ CambiarEstado 
    B   Ciclo 
 
CambiarEstado 
    ; Limpia bandera de interrupción 
    LDR R1, =GPTM_TIMER0_ICR_R 
    MOV R0, #0x1 
    STR R0, [R1] 
 
    CMP R5, #0 
    BEQ Estado0 
    CMP R5, #1 
    BEQ Estado1 
    CMP R5, #2 
    BEQ Estado2 
    CMP R5, #3 
    BEQ Estado3 
 
    ; Reinicia contador 
    MOV R5, #0 
    B   Ciclo 
 
;------Estados------ 
Estado0  ; PE4  
    LDR R1, =GPIO_PORTE_DATA 
    MOV R0, #0x10 
    STR R0, [R1] 
    LDR R1, =GPIO_PORTF_DATA 
    MOV R0, #0x00  ; Apaga PF1 
    STR R0, [R1] 
    ADD R5, R5, #1 
    B   Ciclo 
 
Estado1  ; PE1 encendido 
    LDR R1, =GPIO_PORTE_DATA 
    MOV R0, #0x02  ; PE1 
    STR R0, [R1] 
    ADD R5, R5, #1 
    B   Ciclo 
 
Estado2  ; PE2 encendido 
 
    LDR R1, =GPIO_PORTE_DATA 
    MOV R0, #0x04  ; PE2 
    STR R0, [R1] 
    ADD R5, R5, #1 
    B   Ciclo 
 
Estado3  ; PF1 encendido 
    LDR R1, =GPIO_PORTE_DATA 
    MOV R0, #0x00  ; Apaga todos los PE 
    STR R0, [R1] 
    LDR R1, =GPIO_PORTF_DATA 
    MOV R0, #0x02  ; Enciende PF1 
    STR R0, [R1] 
    ADD R5, R5, #1 
    B   Ciclo 
 
;------Configuración del Timer------ 
ConfTimer 
    ; Habilita reloj del Timer0 
    LDR R1, =GPTM_RCGCTIMER_R 
    LDR R0, [R1] 
    ORR R0, R0, #0x1 
    STR R0, [R1] 
     
    LDR R1, =GPTM_TIMER0_CFG_R 
    MOV R0, #0x00 
    STR R0, [R1] 
     
    LDR R1, =GPTM_TIMER0_TAMR_R 
    MOV R0, #0x02 
    STR R0, [R1] 
     
    LDR R1, =GPTM_TIMER0_TAILR_R 
    LDR R0, =Tiempo 
    STR R0, [R1] 
    
    LDR R1, =GPTM_TIMER0_IMR_R 
    MOV R0, #0x01 
    STR R0, [R1] 
    
    LDR R1, =GPTM_TIMER0_CTL_R 
    MOV R0, #0x01 
    STR R0, [R1] 
    BX  LR 
 
 
    ALIGN 
    END