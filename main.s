	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw	0x00
	movwf	TRISD, A	    ; set PORTD to output
	movlw	0x11		    
	movwf	PORTD, A	    ; deactivate output enabler for latches
	movlw	0xFF	
	movwf	TRISC, A	    ; first bit of PORTC selects latch
	movwf	TRISB, A	    ; set PORTB to input
	movwf	TRISE, A	    ; initialise PORTE to input (avoid short circuits)
write:
	movlw	0x00
	BSF	PORTD, 0, A	    ; disable output enablers
	BSF	PORTD, 8, A	    
	movlw	0xFF
	movwf	TRISE, A	    ; set PORTE to output
	movf	PORTB, W, A	    ; load value to write in W
	movwf	PORTE, A	    ; write W into PORTE
	BTFSS	PORTC, 0, A
	
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
	

;start:
;	movlw 	0x0
;	movwf	TRISC, A	    ; Port C all outputs
;	bra 	test
;loop:
;	movff 	0x06, PORTC
;	incf 	0x06, W, A  ; increase file and put result into W
;test:
;	movwf	0x06, A	    ; Test for end of loop condition
;	movlw 	0x63
;	cpfsgt 	0x06, A
;	bra 	loop		    ; Not yet finished goto start of loop again
;	goto 	0x0		    ; Re-run program from start
;
;	end	main
end main
