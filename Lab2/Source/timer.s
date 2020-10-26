#include <c8051F020.h>

/*
 * File          : timer.s
 *
 * Contains various function related to the timer
 * You need to include timer.h in order to gain access to them
 */
 
// Export (from this file) a global function
PUBLIC	INIT_1_SEC_TIMER
PUBLIC	TIMER2_ISR

/*
 * Code Section, give it a name so that we can
 * then make it relocatable (using RSEG)
 */
		TIMER_CODE	SEGMENT		CODE
RSEG	TIMER_CODE    ; making this code segment relocatable




/* 
 * INIT_1_SEC_TIMER subroutine
 * See timer.h for interface description.
 */


INIT_1_SEC_TIMER:
	; Configure Timer 2 for 1 sec period operation with an interupt each time.
	; I'm using timer 2 as it supports 16-bit timer mode with auto-reload (mode 1)

	; Set clock and mode for the timers

	; V's note: To use more accurate time units, specify the "Clock Control Register" (For Timer 2, 5th bit of CKCON) to 0. Ref: Datasheet P226.
	MOV	CKCON , #00000000b  ; Value to set the timers on a clock = sysclk/12 = 22.11 MHz/12 = 1,843,200 Hz.
	; V's note: Set the operation mode to "16-bit Counter/Timer with Auto-Reload" Ref: Datasheet P234.
	MOV	T2CON , #0001b  ; Mode = 1 = 16 bit timer / counter

	; Program the reload registers so as to get a frequency of 1/32 sec

	; V's note: For a frequency of 1/32 sec, fill "32" in the cell E10 Timer2Calculation.xslx and the value for RCAP register is expected appearing in cell E14.
	MOV	RCAP2H , #1FH;
	MOV	RCAP2L , #15H; choose RCAP2L_VAL and RCAP2H_VAL in such a way that the 16-bit timer2 counts n seconds where n is a fractional number much less than 1 sec.

	// Enable T2 interrupt
	SETB ET2
	SETB EA   ;  Global interrupt enable



	SETB TR2  ; Enable timer 2

	RET




/* 
 * Timer 2 Interrupt Service Routine (ISR).
 * Must be jumped to from the interrupt vector located at adress 0x2B
 */
TIMER2_ISR:
	
	;The loop to run your timer N times should be written here. The value of N should be chosen in a way that N*n = 1 second where n is the 
	;time that the timer counts based on RCAP2L_VAL and RCAP2H_VAL chosen in INIT_1_SEC_TIMER subroutine above.
	
	; V;s note: should we call `SETB TR2` first to start the timer?
	; SETB TR2  ; Enable timer 2

	REPEAT: ; V's note: This repeat is for executing
		MOV    R1, #20H ; Set the counter for 32 time loop, take over by 1 each time.
	WAIT:
		JNB    TF2, WAIT ; V's note: Test if the Timer 2 overflows (TF2 is high), if not jump to WAIT.
		DJNZ   R1, REPEAT ; V's note: Take over R1 by 1 first, and test if 32 loops (1 sec) has been completed. If yes, lighting LED actions will be performed; if not, jump to REPEAT.
	
	
	; Increment value on LEDs by 1. The LEDs are in the MS nibble of port 5. 
	;Here the code for blinking the LEDs should be written. This part of the code is the same as you wrote in Lab1.

	; Copied from Lab1
	MOV		A, P5		; start of read/modify/write operation
	ADD     A, #01H  	; steps MS nibble by 1 each time
	ANL 	A, #0F0H	; clears LS nibble
	MOV     P5, A		; write back to port 5 - end of read/modift/write operation
	
	EXIT_TIMER2_ISR:
	CLR		TF2         ; Very important. Clear interrupt flag

	RETI


END
