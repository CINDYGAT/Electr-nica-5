;PROBLEMA #8 SEGUNDO EXAMEN PARCIAL DE ELECTRONICA 5 FACULTAD DE INGENIERIA SEGUNDO SEMESTRE 2023 UNIVERSIDAD DE SAN CARLOS DE GUATEMALA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Escriba un programa que permita encontrar la masa media del núcleo de 
;cualquiera de los elementos de la tabla periódica, este proceso se debe de realizar 
;como mínimo para 3 átomos diferentes.  Nota: utilice los conceptos de masa atómica. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	AREA codigo, CODE, READONLY, ALIGN=2
	THUMB
	EXPORT Start

Start
    ; ----------------------------- Calcular masa atómica promedio del Carbono ---------------------------------------------
    ; 1. Contribución del C-12
    VLDR.F32 S0, =12.0000             ; S0 = Masa del C-12 (uma)
    VLDR.F32 S1, =0.989       		  ; S1 = Abundancia 98.9%
    VMUL.F32 S2, S0, S1                ; S2 = Masa * Abundancia = 11.868

    ; 2. Contribución del C-13
    VLDR.F32 S3, =13.0034             ; S3 = Masa del C-13 (uma)
    VLDR.F32 S4, =0.011       		  ; S4 = Abundancia 1.1%
    VMUL.F32 S5, S3, S4                ; S5 = Masa * Abundancia = 0.14304

    ; 3. Suma de contribuciones
    VADD.F32 S6, S2, S5                ; S6 = Masa atómica promedio
                                       ; S6= (masa C-12 * abundancia C-12 ) + (masa C-13 * abundancia C-13)= 12.011
									   
	; ----------------------------------- Calcular masa atómica promedio del Oxígeno (O) ------------------------------------------
    ; Contribución del O-16
	VLDR.F32 S7, =15.9949				;S7 = Masa del O-16 (uma)
    VLDR.F32 S8, =0.9976 				;S8 = Abundancia 99.76%
    VMUL.F32 S9, S7, S8                ; S9 = 15.9949 * 0.9976 ˜= 15.957

    ; Contribución del O-17
    VLDR.F32 S10, =16.9991				;S10 = Masa del O-17 (uma)
    VLDR.F32 S11, =0.0004		        ;S11 = Abundancia 0.04%
    VMUL.F32 S12, S10, S11             ; S12 ˜= 16.9991*0.0004 = 0.006799

    ; Contribución del O-18		
    VLDR.F32 S13, =17.9992				;S13 = Masa del O-18 (uma)
    VLDR.F32 S14, =0.0020				;S14 = Abundancia 0.2%		
    VMUL.F32 S15, S13, S14             ; S15 = 17.9992*0.002 = 0.03599

    ; Suma para Oxígeno
    VADD.F32 S16, S9, S12				; S16= (masa 0-16 * abundancia O-16 ) + (masa O-17 * abundancia O-17) = 15.9633
    VADD.F32 S17, S16, S15             ; S17= S16 + (masa O-17 * abundancia O-17) = 15.9993
	
	; ------------------- Calcular masa atómica promedio del Neon (Ne) --------------------------------------------------------------
    ; Contribución del Ne-20
    VLDR.F32 S18, =19.9924				;S18 = Masa del Ne-20 (uma)
    VLDR.F32 S19, =0.9048				;S19 = Abundancia 90.48%
    VMUL.F32 S20, S18, S19             ; S20 ˜= 19.9924 * 0.9048 = 18.0891

    ; Contribución del Ne-21
    VLDR.F32 S21, =20.9938				;S21 = Masa del Ne-21 (uma)
    VLDR.F32 S22, =0.0027				;S22 = Abundancia 0.27%
    VMUL.F32 S23, S21, S22             ; S23 ˜= 20.9938 * 0.0027 = 0.05668

    ; Contribución del Ne-22
    VLDR.F32 S24, =21.9914				;S24 = Masa del Ne-22 (uma)
    VLDR.F32 S25, =0.0925 				;S25 = Abundancia 9.25%
    VMUL.F32 S26, S24, S25             ; S26 ˜= 21.9914 * 0.0925 = 2.0342

    ; Suma para Neón
    VADD.F32 S27, S20, S23				; S27= (masa Ne-20 * abundancia Ne-20 ) + (masa Ne-21 * abundancia Ne-21) = 18.14581
    VADD.F32 S28, S27, S26             ; S28= S27 + (masa Ne-22 * abundancia Ne-22) = 20.1800
 
    ; --- Resultados finales ---
    ; S6  = Masa promedio del Carbono (~12.011 uma)
    ; S17 = Masa promedio del Oxígeno (~15.999 uma)
    ; S28 = Masa promedio del Neón (~20.180 uma)
	
	B       .
	
    ALIGN
    END