	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw	0x00
	movwf	TRISD, A	    ; set PORTD to output
	movwf	TRISH, A	    ; set PORTH to output
	movlw	0x05		    
	movwf	PORTD, A	    ; deactivate output enabler for latches
	setf	TRISC, A	    ; set PORTC to input (need first bit)
	setf	TRISB, A	    ; set PORTB to input
	setf	TRISE, A	    ; initialise PORTE to input (avoid short circuits)
	banksel	PADCFG1		    ; change bank
	bsf	REPU		    ; PORTE pull-ups
	bsf	RBPU	
loop:
	BTFSS	PORTC, 0, A	    ; if 0, read
	call	read
	BTFSC	PORTC, 0, A	    ; if 1, write
	call	write
	goto	loop		    ; repeat loop
write:
	movlw	0x00
	BSF	PORTD, 0, A	    ; disable output enablers
	BSF	PORTD, 2, A	    
	movwf	TRISE, A	    ; set PORTE to output
	movf	PORTB, W, A	    ; load value to write in W
	movwf	PORTE, A	    ; write W into PORTE
	BTFSS	PORTC, 1, A
	goto	clock1
	goto	clock2
clock1:	BSF	PORTD, 1, A	    ; turn 1 clock on
	call	delay
	BCF	PORTD, 1, A	    ; turn 1 clock off
	goto	endwrite
clock2:	BSF	PORTD, 3, A	    ; turn 2 clock on
	call	delay
	BCF	PORTD, 3, A	    ; turn 2 clock off
endwrite:
	movlw	0xFF
	movwf	TRISE, A	    ; set PORTE back to input
	return
read:	
	movlw	0xFF
	movwf	TRISE, A	    ; set PORTE to input
	BTFSS	PORTC, 1, A	    ; if bit is 0
	BCF	PORTD, 0, A	    ; enable latch number 1
	BTFSC	PORTC, 1, A	    ; if bit is 1
	BCF	PORTD, 2, A	    ; enable latch number 0
	call	delay
	movf	PORTE, W, A	    ; read value in PORTE
	movwf	PORTH, A	    ; write value into PORTH
	BSF	PORTD, 0, A	    ; deactivate OE
	BSF	PORTD, 2, A
	return
delay:
	movlw	0x00
	movwf	0x06, A		; reset looptwo timer
	call	timer
	return
timer:
	movlw	0x03		; load max timer value into W
	cpfslt	0x06, A		
	return
	incf	0x06,F,A
	goto	timer
end main
