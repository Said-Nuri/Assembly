; Array Sum v1.0 24.12.2011
; Author: Furkan Tektaş

; You can execute it by Simple Simulator. http://es.ewi.utwente.nl/software/simpsim/index.html#downLOAD

; Write a program that find the sum of an arbitrary integer array placed in memory.
; Array can be in any size and the program will be coded in a manner that the array will be
; easily changed.

	
JMP CLEANSCREEN

CLEANSCREEN: 								;Print three enter to clean the screen
				LOAD RF,10d 
				LOAD RF,10d 
				LOAD RF,10d 
				LOAD RF,10d 
				JMP  MAINPROCESS


MAINPROCESS:
	LOAD RC,0							; Result Holder
	LOAD R1,array		     					; Load the string of warn label.
	JMP SUM								
			
		SUM:							; Stolen from hello world example :)
			LOAD    R2,1       				; 1 for increase the order of current array element
			
			SUMLOOP:
					LOAD    RD,[R1]				; RD is the curent element holder (temporary)
					LOAD	R3,100d				; Read the note below
					MOVE	R0,RD				; For comparison
					JMPLE	R3<=R0,ERR			; Read the note below
					;JMPLE	RC<=R0,ERR			; Read the note below
					LOAD    R0,255d        		; Define the terminator
					JMPEQ   RD=R0,FINISHSUM		; If we reach the terminator, JMP FINISHSUM					
					ADDI    RC,RC,RD    		; RC = RC + Current Array Element
					ADDI    R1,R1,R2    		; Increase order holder(memory address)					
					JMP     SUMLOOP   		; If not, JMP SUMLOOP
		FINISHSUM:
			LOAD R0,9d						; To compare whether the  result is bigger than 9 or not
			JMPLE RC<=R0,PRINTSUM1			; For the result smaller than 9
			JMP PRINTSUM2					; For the result bigger than 9
			
		PRINTSUM1:
			LOAD RD,48d
			ADDI RF,RC,RD
			HALT


PRINTSUM2:								; Load numbers from memory to registers and jump the following process
	MOVE R2,RC							; RC holds the sum.
	LOAD R5,48d							; R5 = 48 (For ASCII conversion)
	LOAD R7,1d							; 1 for 2's complement, increasing the result holder in DIVIDE, and decide the finishing process in FINISHORJMPRESULT 
	LOAD RA,0d							; Result holder
	JMP DIVIDE

		DIVIDE:
			LOAD R0,-10d					; Denominator (we need 10)
			ADDI R2,R0,R2					; R2 = RB + R2(Note that RB is the negative of denominator)
			ADDI RA,RA,R7					; Increase the RA(result holder)
			LOAD R0,10d						; For comparing result is smaller than 11
			JMPLE R2<=R0,ENDLOOP			; JMP ENDLOOP if R2<=R3
			JMP DIVIDE						; JMP DIVISIONLOOP untill R2<=R3			
	ENDLOOP:
		JMPEQ R2=R0,INCREASERESULT				; JMP INCREASERESULT if result equals numerator
		JMP PRINTFIRSTDIGIT					; JMP COMPARERESULT if result is smaller than numerator
		
		INCREASERESULT:
				ADDI RA,RA,R7				; Increasing the result
				JMP PRINTFIRSTDIGIT			; JMP COMPARERESULT
				
			PRINTFIRSTDIGIT:
				LOAD RE,10d	
				MOVE R0,RA
				JMPLE RE<=R0,Err					; If first digit is bigger than 9; jmp err
				
				LOAD R5,48d				; R5 = 48 (For ASCII conversion); Prints the numerical result after the "rslt=" label and halts.
				ADDI RF,RA,R5			; Prints the corresponding ASCII code of first digit
				ADDI RF,R2,R5			; Prints the corresponding ASCII code of second digit
				HALT					; Halt program if message is printed.				
		ERR:							; Hello World Example
		LOAD    R1,Err     				; The start of the string
        LOAD    R2,1        			; Increase step
        LOAD    R0,0        			; String-terminator
		NextChar:LOAD    RF,[R1]     	; Get character and print it on screen
				ADDI    R1,R1,R2    	; Increase address
				JMPEQ   RF=R0,Ready 	; When string-terminator, then ready
				JMP     NextChar    	; Next character
		Ready:   HALT
Err:    db      10
        db      "Error !!",10
        db      "Result cannot be",10
		db		"bigger than 99"
         db      0           			;Terminator
			
		
array:									; Array to sum. Sum can be between [0]-[99]
		db 1
		db 7
		db 28
		db 55
		db 255d								; 255 = Terminator
		
; Note:
; 100d is for comparison whether either current array element or current sum is bigger than 99
; Assigning different values to R0	and using two conditional jumps decrease the performance but it's required to handle errors.
; If current element is bigger than 100 (eg: 255), our result holder register would hold wrong result.
; If the result of the former loop is bigger than 100 (eg: 190), current loop's result would exess the capability of result holder register.(eg: 190 + 90). 
; So I prefer safer but slower algorithm.