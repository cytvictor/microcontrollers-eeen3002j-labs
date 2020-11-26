#ifndef UTILS_H_ALREADY_INCLUDED
#define UTILS_H_ALREADY_INCLUDED

/*
 * utils.h:
 * A header file that contains all public interface for the utils.s file.
 */
 

// Forward declariation of global functions.

/*
 * Delay a multiple of 50ms (burns cycles)
 *
 * Input:   A = the number of time 50ms the function delay for
 * Outputs: none
 * 
 *
 * Trashes R5,R6 & R7  
 */
EXTRN   CODE   (DELAY)


/*
 * Configure the Xtal oscillator and take it into use
 *
 * Input:   none
 * Outputs: none
 * 
 *
 * Trashes A,B,R5,R6 & R7  
 */
EXTRN	CODE	(ENABLE_XTAL)


#endif // UTILS_H_ALREADY_INCLUDED