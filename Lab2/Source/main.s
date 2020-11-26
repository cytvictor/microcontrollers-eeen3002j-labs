/*
 * Example program
 * File          : blink.s
 *
 * Hardware      : C8051F020 with clock frequency 2MHz
 *
 * Description   : cycles from 0000b to 1111b on the 4 on board LEDs continuously, everu 0.5sec
 *
 */
 
; UNCHECK the box that says "define 8051 SFR Names" in target options (A51 tab)
; and load this definition file instead
#include <c8051F020.h>
#include "utils.h"
#include "timer.h"




ORG 0000H
	JMP MAIN


ORG	002BH ; TIMER 2 Interrupt vector
	JMP	TIMER2_ISR
	
;
; MAIN PROGRAM
;
CSEG ; this is a code segment - program memory
		ORG		0080h	; starting at address 0x80, avoiding interrupts

MAIN:
; Setup code (run once)
		; Disable Watchdog!
		CLR 	EA ; disable all interrupts
		MOV		WDTCN,#0DEh ; disable software watchdog timer
		MOV		WDTCN,#0ADh

		; Take the xrystal into use.
		CALL	ENABLE_XTAL
	


		; Configure LED pin as an output.
		; There are 4xLEDs on port 5, bits 4 to 7.
		; P74OUT register desiption contains this:
		; Bit3: P5H: Port5 Output Mode High Nibble Bit.
		;  0: P5.[7:4] configured as Open-Drain.
		;  1: P5.[7:4] configured as Push-Pull.
		; It is not bit-addressable so read reg, set bit 3 to 1, and write back again
		MOV	A      , P74OUT
		ORL A      , #08h
		MOV P74OUT , A
		

		; Configure the 1 second timer and the ISR
		CALL INIT_1_SEC_TIMER


; Infinite loop (runs forever after setup code)
LOOP_FOREVER: 
		JMP $;


END
