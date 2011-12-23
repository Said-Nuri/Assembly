; Find the Biggest Digit v1.0 23.12.2011

; You can execute it by Simple Simulator. http://es.ewi.utwente.nl/software/simpsim/index.html#download

; Write a program that finds the maximum of four arbitrary numbers a, b, c, d. You can
; directly load the values to the registers. Note that a,b,c and d should be between 0 and 10.

JMP CLEANSCREEN

CLEANSCREEN: 					;Print three enter to clean the screen
	LOAD RF,10d 
	LOAD RF,10d 
	LOAD RF,10d 
	JMP  MAINPROCESS
				
MAINPROCESS:					;Load Numbers to registers and begin comparison
	LOAD R2,2d				; R2 = 2 - First Number
	LOAD R3,5d				; R3 = 5 - Second Number
	LOAD R4,1d				; R4 = 1 - Third Number
	LOAD R5,3d				; R5 = 3 - Fourth Number
	LOAD R6,48d				; R6 = 48 (For ASCII conversion)
	jmp  R2vsR3		
	
	R2vsR3:					; Comparison of R2 ve R3 registers.
		MOVE 	R0,R2			; R2 should be moved to R0 to comparison
		JMPLE	R3<=R0, R2vsR4 		; jump R2vsR4 if R3<=R2
		JMP		R3vsR4		; jump R3vsR4 if R3>R2
	R2vsR4:					; Keep in mind that R2 is still in the R0
		JMPLE	R4<=R0, R2vsR5 		; jump R2vsR5 if R4<=R2 
		JMP		R4vsR5		; jump R4vsR5 if R4>R2
	R2vsR5:					; Keep in mind that R2 is still in the R0
		JMPLE	R5<=R0, echoR2 		; if R5<=R2 jump to echoR2
		JMP		echoR5		; if R5>R2 jump to echoR5
	
	R3vsR4:
		MOVE 	R0,R3			; R3 should be moved to R0 to comparison
		JMPLE	R4<=R0, R3vsR5 		; if R4<=R3 jump R3vsR5
		JMP		R4vsR5		; if R4>R3 jump R4vsR5
	R3vsR5:					; Keep in mind that R3 is still in the R0
		JMPLE	R5<=R0, echoR3 		; if R5<=R3 jump echoR3
		JMP		echoR5		; if R5>R3 jump echoR5
	
	R4vsR5:
		MOVE 	R0,R4			; R4 should be moved to R0 to comparison
		JMPLE	R5<=R0, echoR4 		; if R5<=R4 jump echoR4
		JMP		echoR5		; if R5>R4 jump echoR5			

		
	echoR2:					; First number is the biggest
		MOVE	R0,R2			; Move R2 to R0 then jump PRINT
		JMP		PRINT
	echoR3:					; Second number is the biggest
		MOVE	R0,R3			; Move R3 to R0 then jump PRINT
		JMP		PRINT
	echoR4:					; Third number is the biggest
		MOVE	R0,R4			; Move R4 to R0 then jump PRINT
		JMP		PRINT
	echoR5:					; Fourth number is the biggest
		MOVE	R0,R5			; Move R5 to R0 then jump PRINT
		JMP		PRINT
	
	PRINT:					; Print the corresponding ASCII code of biggest number
		ADDI	R0,R0,R6		; Converting biggest digit to the ASCII by adding 48d
		MOVE	RF,R0			; Printing the ASCII by moving the contents of R0 to RF
		HALT				; Halting
