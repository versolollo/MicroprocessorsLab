#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message, convertHex  ; external subroutines
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable:
	db	'a','b'
	; data to convert
	myTable_l   EQU	2	; length of data
	align	2

psect	udata_acs
test_data:
	ds	5
    
psect	code, abs	
rst: 	org 0x0
	call	convertHex
	movlw	'B'
	movwf	test_data, A
	movwf	test_data+1,A
	movwf	test_data-1, A
	movlw	0xff
	addlw	0xff
	addlw	0x00
	addlw	0xfe
	addlw	0x00
	movwf	0x00,A
	movlw	0x00
	addwfc	0x00,F,A	
	movf	0x00,W,A
	movf	STATUS, W, A
	movlw	0x00
	
	
	
	
	
	
	; ******* Programme FLASH read Setup Code ***********************
;setup:	bcf	CFGS	; point to Flash program memory  
;	bsf	EEPGD 	; access Flash program memory
;	call	UART_Setup	; setup UART
;	goto	start
;	
;	; ******* Main programme ****************************************
;start: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
;	movlw	low highword(myTable)	; address of data in PM
;	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
;	movlw	high(myTable)	; address of data in PM
;	movwf	TBLPTRH, A		; load high byte to TBLPTRH
;	movlw	low(myTable)	; address of data in PM
;	movwf	TBLPTRL, A		; load low byte to TBLPTRL
;	movlw	myTable_l	; bytes to read
;	movwf 	counter, A		; our counter register
;loop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
;	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
;	decfsz	counter, A		; count down to zero
;	bra	loop		; keep going until finished
;		
;	movlw	myTable_l	; output message to UART
;	lfsr	2, myArray
;	call	UART_Transmit_Message
;
;	goto	$		; goto current line in code
;
;	; a delay subroutine if you need one, times around loop in delay_count
;delay:	decfsz	delay_count, A	; decrement until zero
;	bra	delay
;	return
	end	rst