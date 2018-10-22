;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

;Memory allocation of arrays must be done prior to the RESET & StopWDT
ARY1		.set	0x0200			;Memory allocation 	ARY1
ARY1S		.set	0x0210			;Memory allocation 	ARYS
ARY2		.set	0x0220			;Memory allocation 	ARY2
ARY2S		.set	0x0230			;Memory allocation 	AR2S

			clr	R4					;Clear Register
			clr	R5					;Clear Register
			clr	R6					;Clear Register

SORT1		mov.w	#ARY1,	R4		;Initialize R4 to point to ARY1  in the memory
			mov.w	#ARY1S,	R6		;Initialize R6 to point to ARY1S in the memory where the sorted ARY1 will be stored
			call	#ArraySetup1	;Create elements are store them in ARY1
			call 	#COPY			;Copy the elements from the ARY1 space to ARY1S space
			call	#SORT			;Calling Subroutine Sort with parameter passing in R4 abd R6

SORT2		mov.w	#ARY2,	R4		;Initialize R4 to point to ARY2  in the memory
			mov.w	#ARY2S,	R6		;Initialize R6 to point to ARY2S in the memory where the sorted ARY2 will be stored
			call	#ArraySetup2	;Create elements are store them in ARY2
			call 	#COPY			;Copy the elements from the ARY2 space to ARY1S space
			call	#SORT			;Calling Subroutine Sort with parameter passing in R4 abd R6

Mainloop	jmp	Mainloop 			;loop in place for ever

;Array element initialization Subroutine
ArraySetup1	mov.b	#10,	0(R4)	;Define the number of elements in the array
			mov.b	#29, 	1(R4)	;store an element
			mov.b	#16, 	2(R4)	;store an element
			mov.b	#-55, 	3(R4)	;store an element
			mov.b	#90, 	4(R4)	;store an element
			mov.b	#17, 	5(R4)	;store an element
			mov.b	#63, 	6(R4)	;store an element
			mov.b	#59, 	7(R4)	;store an element
			mov.b	#-35, 	8(R4)	;store an element
			mov.b	#27, 	9(R4)	;store an element
			mov.b	#55, 	10(R4)	;store an element
			ret

;Array element initialization Subroutine
ArraySetup2	mov.b	#10, 	0(R4)	;Define the number of elements in the array
			mov.b	#43, 	1(R4)	;store an element
			mov.b	#84, 	2(R4)	;store an element
			mov.b	#29, 	3(R4)	;store an element
			mov.b	#-59, 	4(R4)	;store an element
			mov.b	#-51, 	5(R4)	;store an element
			mov.b	#77, 	6(R4)	;store an element
			mov.b	#79, 	7(R4)	;store an element
			mov.b	#69, 	8(R4)	;store an element
			mov.b	#77, 	9(R4)	;store an element
			mov.b	#64, 	10(R4)	;store an element
			ret

;Copy original Array to allocated Array-Sorted space
COPY		mov.b	0(R4), R10		;save n (number of elements) in R10
			inc.b	R10				;increment by 1 to account for the byte n to be copied as well
			mov.w	R4, R5			;copy R4 to R5 so we keep R4 unchanged for later use
			mov.w	R6, R7			;copy R6 to R7 so we keep R6 unchanged for later use
LP			mov.b	@R5+, 0(R7)		;copy elements using R5/R7 as pointers
			inc.w 	R7
			dec		R10
			jnz	LP
			ret

;Sort the copy of Array saved in the allocated Array-Sorted space, while keeping original Array unchanged
;replace the following two lines with your actual sorting algorithm.
;Sort the copy of Array saved in the allocated Array-Sorted sapce, while keeping original Array unchanged
SORT		clr.w R7
			mov.b @R6, R5
			dec R5
firstlp		mov.b @R6, R8
			dec R8
			sub.b R7, R8
			mov.w R6, R10
			inc R10
secondlp	cmp.b @R10+, 0(R10)
			jge skip
			mov.b -1(R10), R9
			mov.b @R10, -1(R10)
			mov.b R9, 0(R10)
skip		dec R8
			jnz secondlp
			inc R7
			dec R5
			jnz firstlp
			ret
;To bubble sort, you need to scan the array n-1 times,
;In every scan, you compare from top down each two consecutive elements, and you swap them if they are not in ascending order.
;Notice that in the first scan you get the largest element (no matter where it is in the array) pushed all the way to the bottom.
;So your next scan should be n-1 iterations, and then n-2 and so on.
;So every time you come back to the top of the array for a new scan, your n (the number of comparisons) must be decremented by 1.
;In the last scan, you need only one comparison.
;Hints:
;Your sorting algorithm starts with R6 as a pointer to the array
;you need to save n (number of elements) in R8, then decrement it by 1 (n-1) to become the number of comparisons.
;Copy R6 to R7 so you keep R6 unchanged as it points to the top of the array for every new scan.
;Copy n-1 to R9 and use R9 as a loop counter, while keeping the current n-1 value in R8 for the next scan.
;In the scan loop get an element and auto increment pointer R7, then get next element without changing R7.
;Compare the two elements, if not in ascending order, swap them.
;Repeat the scan from the top as pointed to by (R6), and every time decrement the number of comparisons (R8).

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
