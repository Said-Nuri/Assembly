; Division v1.0 24.12.2011
; Author: Furkan Tektaş

; You can execute it by Simple Simulator. http://es.ewi.utwente.nl/software/simpsim/index.html#download

; Write a program that finds the division of two positive integer numbers a, b. If the
; result c (c=a/b) is lower than 10 (c<10), write the result on the output screen in the format
; of "rslt=c" otherwise write "wrn: cannot show the result!". Check for the division by zero
; error and if it's occurs, write "err: division by zero" on output screen.

	
JMP CLEANSCREEN

CLEANSCREEN: 								;Print three enter to clean the screen
				LOAD RF,10d 
				LOAD RF,10d 
				LOAD RF,10d 
				LOAD RF,10d 
				JMP  MAINPROCESS



MAINPROCESS:								; Load numbers from memory to registers and jump the following process
	LOAD R2,[a]							; R1 Numerator
	LOAD R3,[b]							; R2 Denominator
	LOAD R5,48d							; R5 = 48 (For ASCII conversion)
	LOAD R6,255d							; 2's complement mask for XOR
	LOAD R7,1d							; 1 for 2's complement, increasing the result holder in DIVIDE, and decide the finishing process in FINISHORJMPRESULT 
	LOAD R8,0d							; For division by zero comparison
	LOAD RA,0d							; Result holder
	
	LOAD R0,0d							; R0 = 0 for division by zero comparison
	JMPEQ R3=R0, PRINTDIVISIONERROR
	JMP DIVISIONLOOP
	
	DIVISIONLOOP:
		JMP R3TWOSCOMPLEMENT 					; Converting R3 to -R3

		R3TWOSCOMPLEMENT:
			XOR RB,R3,R6					; XOR R3 with 255d and move it to RB(Temporary negative denominator holder)
			ADDI RB,RB,R7					; Finalize 2's complement by adding 1d to RB
			JMP DIVIDE	

		DIVIDE:
			ADDI R2,RB,R2					; R2 = RB + R2(Note that RB is the negative of denominator)
			ADDI RA,RA,R7					; Increase the RA(result holder)
			MOVE R0,R3					; MOVE R3 to R0 to be able to compare it
			JMPLE R2<=R0,ENDLOOP				; JMP ENDLOOP if R2<=R3
			JMP DIVISIONLOOP				; JMP DIVISIONLOOP untill R2<=R3			
	ENDLOOP:
		JMPEQ R2=R0,INCREASERESULT				; JMP INCREASERESULT if result equals numerator
		JMP COMPARERESULT					; JMP COMPARERESULT if result is smaller than numerator
		
		INCREASERESULT:
				ADDI RA,RA,R7				; Increasing the result
				JMP COMPARERESULT			; JMP COMPARERESULT
				
		COMPARERESULT:
			LOAD R0,9d					; R0=9 for comparison (Result should be <10)
			JMPLE RA<=R0,PRINTRESULT			; If result is smaller than 10, print the result
			JMP CANTSHOWWARNING				; If the result(RA) is bigger than 9, JMP CANTSHOWWARNING
		
		CANTSHOWWARNING:
			LOAD R1,warn     				; Load the string of warn label.
			JMP PRINTMESSAGE				; Jump to print the warning
			
		PRINTMESSAGE:						; Stolen from hello world example :)
			LOAD    R2,1        				; 1 for increase the order of current character
			LOAD    R0,0        				; Define the terminator
			PRINTCHAR:
					LOAD    RF,[R1]    		; Get character and print it
					ADDI    R1,R1,R2    		; Increase character counter(memory address)
					JMPEQ   RF=R0,FINISHORJMPRESULT	; If we reach the terminator, JMP FINISHORJMPRESULT
					JMP     PRINTCHAR   		; If not, JMP PRINTCHAR for printing the next character
			FINISHORJMPRESULT:
					LOAD R1,1d			; LOAD 1d to R1 to be able to decide where to jump
					MOVE R0,RD			; Move RD to R0 to be able to jump FINISHPRINTINGRESULT if we will print the result.
					JMPEQ R1=R0,FINISHPRINTINGRESULT; We haven't print the result, jmp FINISHPRINTINGRESULT to print it
					JMP FINISH			; warn or err printed, halt the program
				

		
		PRINTRESULT:
			LOAD RD,1					; This helps us jump PRINTRESULT back
			LOAD R1,res					; Load "rslt=" label to R1
			JMP PRINTMESSAGE				; JMP PRINTMESSAGE for printing it.
			FINISHPRINTINGRESULT:				; Prints the numerical result after the "rslt=" label and halts.
				ADDI RA,RA,R5				; Print the corresponding ASCII code of number stored in the result holder(RA)
				MOVE RF,RA				; Print result
				JMP FINISH				; Halt program after printing the result
			
		PRINTDIVISIONERROR:
			LOAD R1,err					; Print error if the denominator is 0
			JMP PRINTMESSAGE				; JMP PRINTMESSAGE to print the error



			FINISH:   HALT					; Halt program if message is printed.				

	
a:		db 8d 								; Numerator
b:		db 2d 								; Denominator	
res:		db "rslt="
		db 0								; Result message
warn:		db "wrn: cannot show the result!",10				; Warning for bigger results than 9
		db 0								; Terminator
err:		db "err: division by zero",10					; Error for division by zero
		db 0
