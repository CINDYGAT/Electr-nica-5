;---------Direcciones de registros------------------------ 
GPIO_PORTE_DATA  EQU 0x400243FC 
GPIO_PORTF_DATA  EQU 0x400253FC
GPIO_PORTA_DATA  EQU 0x400403FC	
GPTM_RCGCTIMER_R EQU 0x400FE604 
GPTM_TIMER0_CFG_R EQU 0x40030000 
GPTM_TIMER0_CTL_R EQU 0x4003000C 
GPTM_TIMER0_TAMR_R EQU 0x40030004 
GPTM_TIMER0_IMR_R EQU 0x40030018 
GPTM_TIMER0_ICR_R EQU 0x40030024 
GPTM_TIMER0_RIS_R EQU 0x4003001C 
GPTM_TIMER0_TAILR_R EQU 0x40030028 
 
Tiempo EQU 4000000  
PA2       EQU 0x40004010; Puerto A2 será el boton. 
PA3       EQU 0x40004020; Puerto A3 será el boton. 	
 
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
	MOV R6, #1              ; Inicializa nivel actual (1 o 2)
 
 
Ciclo 
    LDR R1, =GPTM_TIMER0_RIS_R 
    LDR R0, [R1] 
    CMP R0, #0x1 
    BEQ CambiarEstado
	;BEQ BotonNivel
    B   Ciclo 
 
CambiarEstado 
    ; Limpia bandera de interrupción 
    LDR R1, =GPTM_TIMER0_ICR_R 
    MOV R0, #0x1 
    STR R0, [R1] 
 
	; Determina el estado actual basado en el nivel
	CMP R6, #1
    BEQ ManejarNivel1
    CMP R6, #2
    BEQ ManejarNivel2
    CMP R6, #3
    BEQ ManejarNivel3
    CMP R6, #4
    BEQ ManejarNivel4
    CMP R6, #5
    BEQ ManejarNivel5
    B   Ciclo 
    

	; ------ Manejo de niveles ------
ManejarNivel1
	; Solo Estado 0 (PE0)
    LDR R1, =GPIO_PORTE_DATA 
    MOV R0, #0x01 ; PE0 
    STR R0, [R1] 
	B EsperarTimerApagar

ManejarNivel2
    ; Estados 0 y 1
    CMP R5, #0
    BEQ Estado0
    CMP R5, #1
    BEQ Estado1
	B   EsperarTimerApagar
    B   Ciclo

ManejarNivel3
    ; Estados 0 y 1
    CMP R5, #0
    BEQ Estado0
    CMP R5, #1
    BEQ Estado1
	CMP R5, #2
	BEQ Estado2
	B   EsperarTimerApagar
    B   Ciclo

ManejarNivel4
    ; Estados 0 y 1
    CMP R5, #0
    BEQ Estado0
    CMP R5, #1
    BEQ Estado1
	CMP R5, #2
	BEQ Estado2
	CMP R5, #3
	BEQ Estado3
	B   EsperarTimerApagar
    B   Ciclo
	
ManejarNivel5
    ; Estados 0 y 1
    CMP R5, #0
    BEQ Estado0
    CMP R5, #1
    BEQ Estado1
	CMP R5, #2
	BEQ Estado2
	CMP R5, #3
	BEQ Estado3
	CMP R5, #4
	BEQ Estado4
	B   EsperarTimerApagar
    B   Ciclo
;------Estados------ 
Estado0  ; PE0  
    LDR R1, =GPIO_PORTE_DATA 
    MOV R0, #0x01 ;PE0 
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
 
Estado3  ; PE3 encendido 
    LDR R1, =GPIO_PORTE_DATA 
    MOV R0, #0x08  ; PE3 
    STR R0, [R1] 
    ADD R5, R5, #1 
    B   Ciclo 

Estado4  ; PE4 encendido 
    LDR R1, =GPIO_PORTE_DATA 
    MOV R0, #0x10  ; PE4 
    STR R0, [R1] 
    ADD R5, R5, #1 
    B   Ciclo 
	
;-------------------------------------------------------------------------------------------------------------
;----------------------------------- Acabar la cuenta del timer anterior y empezar una nueva --------------------------------------
    ; Esperar interrupción del timer para verificar temporizador
EsperarTimerApagar
    LDR R1, =GPTM_TIMER0_RIS_R ;termino la cuenta anterior
    LDR R0, [R1]
    CMP R0, #0x1
    BNE EsperarTimerApagar
	
	;Limpia la interrupcion y apaga los LEDS
    LDR R1, =GPTM_TIMER0_ICR_R ;resetear para empezar una nueva cuenta
    MOV R0, #0x1
    STR R0, [R1]   ; Limpiar interrupción

    LDR R1, =GPIO_PORTE_DATA 
    MOV R0, #0x00   ; Apagar PE0
    STR R0, [R1]  

    B EsperarSuelto

;-------------------------------------------------------------------------------------------------------------
;----------------------------- Logica de Botones -------------------------------------------------------------
EsperarSuelto
	LDR R1, =GPTM_TIMER0_RIS_R ;se acabo la cuenta anterior, momento de iniciar una nueva
    LDR R0, [R1]
    CMP R0, #0x1
    BNE EsperarSuelto
	
	;Limpia la interrupcion y apaga los LEDS
    LDR R1, =GPTM_TIMER0_ICR_R ;se reinicia la cuenta para este proce
    MOV R0, #0x1
    STR R0, [R1]   ; Limpiar interrupción
	
	;Verifica si esta suelto para luego presionarlo
	LDR R4, =PA2
    LDR R7, [R4]
    AND R7, R7, #0x04   ; Aislar PA2
	CMP R7,#0x00
    BEQ EsperarSuelto     ; Mientras esté presionado (0), seguir esperando
	B EsperarPresionado
	
    
    ; Esperar a que el botón SEA presionado
EsperarPresionado
	LDR R1, =GPTM_TIMER0_RIS_R
    LDR R0, [R1]
    CMP R0, #0x1
    BNE EsperarPresionado
	
	;Limpia la interrupcion y apaga los LEDS
    LDR R1, =GPTM_TIMER0_ICR_R
    MOV R0, #0x1
    STR R0, [R1]   ; Limpiar interrupción
	
	;LDR R1, =PA2
    LDR R7, [R4]
    AND R7, R7, #0x04
	CMP R7,#0x04
    BEQ EsperarPresionado ; Mientras no esté presionado (1), seguir esperando
    
    ; Anti-rebote, se asegura que el boton este presionado un cierto tiempo y no sea un falso contacto o falsa lectura
    MOV R2, #50       ; Valor de delay

DelayRebote
    SUBS R2, R2, #1
    BNE DelayRebote
    
    ; Verificar que sigue presionado después del rebote
    LDR R7, [R4]
	AND R7, R7, #0x04
    CMP R7, #0x04 ;revisa que el boton siga presionado unos segundos y no existan falsas lecturas. Si no esta presionado, vuelve a iniciar.
    BEQ EsperarSuelto      ; Si fue rebote, volver a empezar
	
EsperarSoltarBoton
	;Lee el estado del boton y espera hasta que el usuario lo suelte para continuar al siguiente nivel. No reinicio RIC e ICR xq no se modifica R1
	LDR R7, [R4]
    AND R7, R7, #0x04
	CMP R7,#0x00
    BEQ EsperarSoltarBoton
	
    ; Botón soltado confirmado - cambiar de nivel
	ADD R6, R6, #1
	MOV R5, #0
    B Ciclo


 
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