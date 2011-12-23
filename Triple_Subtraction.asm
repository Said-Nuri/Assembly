; Triple subtraction v1.0

; You can execute it by Simple Simulator. http://es.ewi.utwente.nl/software/simpsim/index.html#download

; Implement the fallowing expression in SimpSim and ensure the program write the
; mathematical result on the small black output screen of SimpSim. Store these values 
; (a=8, b=3, c=2) to memory first and than load them to register from memory. Load R1, 5 for a
; is forbidden for example.
; d = (a-b-c) ( |d| < 10 )

JMP CLEANSCREEN

CLEANSCREEN: ;Print three enter to clean the screen
				LOAD RF,10d 
				LOAD RF,10d 
				LOAD RF,10d 
				JMP  MAINPROCESS


				
MAINPROCESS:	; Load numbers from memory to registers and jump the following process
	LOAD R2,[a]		; R2 = a - First Number
	LOAD R3,[b]		; R3 = b - Second Number
	LOAD R4,[c]		; R4 = c - Third Number
	LOAD R5,48d		; R5 = 48 (For ASCII conversion)
	LOAD R6,255d		; 2's complement mask for XOR
	LOAD R7,1d		; 1 for 2's complement
	LOAD R8,0d		; 0 for comparing the result is whether positive or not

	JMP  TCOFR3		
	
	TCOFR3:			; 2's complement of R3
		XOR R3,R3,R6	; XOR R3 with 255d
		ADDI R3,R3,R7	; Finalize 2's complement by adding 1d to R3
		JMP TCOFR4
	TCOFR4:			; 2's complement of R4
		XOR R4,R4,R6	; XOR R4 with 255d
		ADDI R4,R4,R7	; Finalize 2's complement by adding 1d to R4	
		JMP SUM1
	
	SUM1:
		ADDI R0,R2,R3	; R0 = R2 + R3
		JMP SUM2
	SUM2:
		ADDI R0,R0,R4	; R0 = R0 + R4
		JMP COMPARISON1	
		
	COMPARISON1:
		JMPLE R8<=R0,PRINT	; JMP PRINT IF R0 IS POSITIVE
		JMP COMPARISON2		; JMP COMPARISON2 IF R0<=0
	COMPARISON2:
		JMPEQ R8=R0,PRINT	; JMP PRINT IF R0 = 0
		JMP TCOFR0		; JMP TCOFR0 IF R0 IS NEGATIVE
		
	TCOFR0:
		XOR R0,R0,R6	; XOR R0 with 255d
		ADDI R0,R0,R7	; Finalize 2's complement by adding 1d to R0
		JMP PRINTDASH	; JUMP PRINTDASH
	
	PRINTDASH:
		LOAD RF,[dash] 	; PRINTS DASH TO THE SCREEN IF THE NUMBER IS NEGATIVE
		JMP	 PRINT 	; JUMPS TO PRINT
		
	PRINT:
		ADDI RF,R0,R5 	; PRINT THE CORRESPONDING ASCII CODE OF NUMBER STORED IN R0
		HALT		; HALTING
		

	a:		db 9d     	; a = 9
	b:		db 4d     	; b = 4
	c:		db 3d     	; c = 3
	dash:		db 45d		; DASH(-)
