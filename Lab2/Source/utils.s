#include <c8051F020.h>

/*
 * File          : utils.s
 *
 * Contains various utiliy functions.
 * You need to include utils.h in order to gain access to them
 */
 
// Export (from this file) a global function
PUBLIC	DELAY
PUBLIC	ENABLE_XTAL

/*
 * Code Section, give it a name so that we can
 * then make it relocatable (using RSEG)
 */
		UTILS_CODE	SEGMENT		CODE
RSEG	UTILS_CODE    ; making this code segment relocatable



/* 
 * enable_xtal subroutine
 * See utils.h for interface description.
 */
ENABLE_XTAL:
 	MOV 	OSCXCN , #067h; OSCMD = 6, and XFCN = 7, Configure to use extral 22.1184 MHz Xtal Oscillator

	MOV		A  , #01    ; set delay length for 1x50ms = 50 ms
	CALL	DELAY   	; call software delay routine

	
	; Make sure its stable
	; Wait for bit 7 of OSCXCN register to be a '1'
	WAIT_XTAL_STABLE:
		MOV  B   , OSCXCN
		JNB  B.7 , WAIT_XTAL_STABLE ; Loop until bit 7 is = 1


	MOV	OSCICN , #08h ; Take the Xtal oscillator into use, the big switch over!

	RET   ; End of enable xtal routine



/*
 * Delay subroutine
 * See utils.h for interface description.
 * Delay c.=50*A ms
 */
DELAY:
		MOV	  R5, A					; set number of repetitions for outer loop
DLY2:   	MOV   R7, #130			; middle loop repeats 130 times         
DLY1:			MOV   R6, #255   	; inner loop repeats 255 times      
					DJNZ  R6, $		; inner loop 255 x 3 cycles = 765 cycles            
				DJNZ  R7, DLY1		; + 5 to reload, x 130 = 100100 cycles
			DJNZ  R5, DLY2			; + 5 to reload = 100105 cycles = 50.053 ms @ 2MHz
       	RET							; return from subroutine

END
