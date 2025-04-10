;PROBLEMA #3 SEGUNDO EXAMEN PARCIAL DE ELECTRONICA 5 FACULTAD DE INGENIERIA SEGUNDO SEMESTRE 2025 UNIVERSIDAD DE SAN CARLOS DE GUATEMALA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;	Determine el volumen de un cono, cubo y esfera, segun lo escoja el usuario. Debe
;   de preguntar determinar primero, el volumen que se desea averiguar, y luego
;   ingresar los valores para realizar el calculo
	
	AREA codigo, CODE, READONLY, ALIGN=2
	THUMB
	EXPORT Start

Start
    ; menu para seleccionar cono=1, cubo=2 o esfera=3
    LDR R0, =3 ; Opción del menú (1=cono, 2=cubo, 3=esfera)
	
	; Ingreso de datos de cono (altura, radio)
	;VLDR.F32 S1, =8.6	; radio (usuario elige)
    ;VLDR.F32 S2, =4.5 ; altura (usuario elige)
	;VLDR.F32 S3, = 0.333333333	;1/3 Constante
	;VLDR.F32 S4, = 3.141592654 ; PI constante
	
	; Ingreso de datos de cubo (lado)
	;VLDR.F32 S1, = 3.15	; lado (usuario elige)
	
	; Ingreso de datos de esfera (radio - usuario elige)
	VLDR.F32 S1, = 9.5		;Valor de radio (usuario elige)
	VLDR.F32 S3, = 1.333333333	;4/3 Constante
	VLDR.F32 S4, = 3.141592654 ; PI Constante
	
    ; Ordenar los registros 
    BL seleccion


seleccion
	CMP R0, #1 ;si la LDR es 1, ejecutara esta. Sino deja sin modificar las variables
	BEQ Cono ; Si R0=1, salta a Cono
	
	CMP R0, #2 ;si la LDR es 2, ejecutara esta. Sino deja sin modificar las variables
	BEQ Cubo ; Si R0=2, salta a Cubo
	
	CMP R0, #3 ;si la LDR es 3, ejecutara esta. Sino deja sin modificar las variables
	BEQ Esfera ; Si R0=3, salta a Esfera

Cono
	VMUL.F32 S9, S3, S4	; S9 = 1/3 * PI
	VMUL.F32 S8, S1, S1	; S8 = R^2
	VMUL.F32 S8, S8, S2	; S8 = S8 * h = R^2 * h
	VMUL.F32 S7, S9, S8	; S7 = S8 * S9 = 1/3 * PI * R^2 * h
	BX LR

Cubo
	VMUL.F32 S7, S1, S1	; S7 = L^2
	VMUL.F32 S7, S7, S1	; S7 = S7 * lado = L^3
	BX LR
	
Esfera
	VMUL.F32 S7, S3, S4	; S7 = 4/3 * PI
	VMUL.F32 S8, S1, S1	; S8 = R^2
	VMUL.F32 S8, S8, S1	; S8 = S8 * RADIO = R^3
	VMUL.F32 S7, S7, S8	; S7 = S7 * S8 = 4/3 * PI * R^3
	BX LR

    ALIGN
    END