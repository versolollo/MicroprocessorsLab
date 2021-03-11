#include <xc.inc>
global	setup_message, message_body, print_message
extrn	heart_beats, LCD_Write_Message
    
psect	data    
message_head_program:	    ; message data initially stored in program memory
	db	'P','u','l','s','e',':',0x0a
	message_head_l   EQU	7	; length of data
	align	2
message_tail_program:
	db	'H','z', 0x0a
	message_tail_l	EQU	3	; length of data
	
	align	2
	
psect	udata_acs   ; space in RAM for output message
message_head:	ds  0x07    ; filled with message_head_program
message_body:	ds  0x03    ; filled with measured  number of pulses
message_tail:	ds  0x03    ; filled with message_tail_program
    total_length    EQU 13  ; Total length of message
   
psect	udata_acs
counter:	ds  1

    
psect	code
setup_message:					; transfer message from program memory to RAM
	lfsr	0, message_head			; transfer head of message
	movlw	low highword(message_head_program)	; address of data in PM
	movwf	TBLPTRU, A			; load upper bits to TBLPTRU
	movlw	high(message_head_program)		; address of data in PM
	movwf	TBLPTRH, A			; load high byte to TBLPTRH
	movlw	low(message_head_program)		; address of data in PM
	movwf	TBLPTRL, A			; load low byte to TBLPTRL
	movlw	message_head_l			; bytes to read
	movwf 	counter, A			; our counter register
	call	copy_loop				; transfer message
	
	lfsr	0, message_tail			; transfer tail of message
	movlw	low highword(message_tail_program)	; address of data in PM
	movwf	TBLPTRU, A			; load upper bits to TBLPTRU
	movlw	high(message_tail_program)		; address of data in PM
	movwf	TBLPTRH, A			; load high byte to TBLPTRH
	movlw	low(message_tail_program)		; address of data in PM
	movwf	TBLPTRL, A			; load low byte to TBLPTRL
	movlw	message_tail_l			; bytes to read
	movwf 	counter, A			; our counter register
	call	copy_loop				; transfer message
	return
copy_loop: 	
	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	copy_loop		; keep going until finished
	return
print_message:
	lfsr	2, message_head
	movlw	total_length
	call	LCD_Write_Message  
	return
    