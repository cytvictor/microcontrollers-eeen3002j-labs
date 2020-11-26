#ifndef TIMER_H_ALREADY_INCLUDED
#define TIMER_H_ALREADY_INCLUDED

/*
 * timer.h:
 * A header file that contains all public interface for the timer.s file.
 */
 

// Forward declariation of global functions.

/*
 * Configure the 1 second timer and the ISR
 *
 * Input:   none
 * Outputs: none
 * 
 *
 * Trashes ??
 */
EXTRN	CODE	(INIT_1_SEC_TIMER)

/*
 * Timer 2's ISR
 *
 * Input:   none
 * Outputs: none
 * 
 *
 * Trashes: A, R7
 * Normally I'd never allow an ISR to modify A, but as the main code is doing nothing
 * it is just about ok. A better solution would be to have the ISR push A (and R7)
 * onto a stack for safe keeping and pop them atthe end to restore thier values.
 */
EXTRN	CODE	(TIMER2_ISR)

#endif // TIMER_H_ALREADY_INCLUDED