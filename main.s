#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message  ; external subroutines
extrn	LCD_Setup
extrn	setup_message
global	heart_beats
    
psect	udata_acs
heart_beats:	ds 2	; number of heart beats in 10 seconds. 2 bytes reserved
heart_rate:	ds 2	; heart rate in HEX


psect	code, abs	
rst: 	org 0x0	    ; start of main code. Beware, interrupt starts at 0x08!!
 	goto	setup

	; ******* Setup Code ***********************
setup:	
	call	LCD_Setup	; setup (small) LCD
	call	setup_message	; required before printing messages

	; ******* Main programme ****************************************
start: 	movlw	0x00
    
    
 
loop: 	; start timer of 10 seconds
	; count number of pulses
		; 1) check interrupt flag
		; 2) check voltage value
		; 3) check rising edge and update count
		; 4) goto 1)
		; if  interrupt flag is triggered, stop timer, switch flag off 
		; and return
	
	; multiply number of pulses in 10 seconds by (e.g.) 6
	; print rate on screen
	; go to beginning of loop

	end	rst
	
	
