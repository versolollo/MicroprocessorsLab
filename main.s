	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw	0x0
	movwf	TRISC, A	; set PORT C all outputs
	movwf	TRISB, A	; set PORT B all outputs
	movwf	PORTC, A	; initialise ports at 0
	movwf	PORTB, A  
	movwf	TRISD, A
	movwf	PORTD, A
	call	delay	
delay:
	movlw	0x00
	movwf	0x05, A		; reset loop timer
	movwf	0x06, A		; reset looptwo timer
	call	loop
	return
looptwo:
	movff	0x06,PORTC	; move timer value in PORTC
	movlw	0x08		; load max value into w
	cpfslt	0x06		; compare timer value with max value
	return
	incf	0x06,F,A	; increase timer value
	goto	looptwo		; call again loop
loop:
	movlw	0x0
	movwf	0x06, A
	movff	0x05,PORTD	; move timer value into PORTD
	call looptwo
	movlw	0x02		; load max timer value into W
	cpfslt	0x05, A		
	return
	incf	0x05,F,A
	goto	loop
	

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
