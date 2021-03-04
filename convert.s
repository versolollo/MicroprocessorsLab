#include <xc.inc>

global convertHex
    
psect udata_acs
result_mult:
	ds	4   ; reserve 4 bytes for multiplication
temp_result:	    
	ds	3   ; copies of the 3 less significant bytes of result_mult
hex_number:
	ds	2
decimal_digits:
	ds	4
; for now say that data are in write

psect	CODE
convertHex:
 	movlw	0x0f		; high byte
	movwf	hex_number,A
	movlw	0xf3		; low byte
	movwf	hex_number+1,A
	
	call	mult_418A	    ; time HEX by 0x418A
	movf	result_mult+0, W, A ; save first decimal digit
	movwf	decimal_digits+0, A
	call	copy_results	    ; save reminder and clear result_mult
	
	call	mult_0A		    ; time reminder by 0x0A (i.e. 10)
	movf	result_mult+0, W, A ; read and save second decimal digit
	movwf	decimal_digits+1, A
	call	copy_results	    ; save reminder and clear result_mult
	
	call	mult_0A		    ; time reminder by 0x0A (i.e. 10)
	movf	result_mult+0, W, A ; read and save third decimal digit
	movwf	decimal_digits+2, A
	call	copy_results	    ; save reminder and clear result_mult
	
	call	mult_0A		    ; time reminder by 0x0A (i.e. 10)
	movf	result_mult+0, W, A ; read and save fourth decimal digit
	movwf	decimal_digits+3, A
	call	copy_results	    ; save reminder and clear result_mult
	
	movlw	0x00
	movlw	0x00
	
	
mult_418A:
	; multiply low(HEX) with 0x8A
	movf	hex_number+1, W, A	; load low(HEX) into write
	mullw	0x8A			; multiply low(HEX) with 0x8A
	movf	PRODL, W, A		; read result (low byte)
	addwfc	result_mult+3, F, A	; save result (low byte)
	movf	PRODH, W, A		; read result (high byte)
	addwfc	result_mult+2, F, A	; save result (high byte)

	; multiply high(HEX) with 0x8A
	movf	hex_number, W, A
	mullw	0x8A
	movf	PRODL, W, A
	addwfc	result_mult+2, F, A
	movF	PRODH, w, A
	addwfc	result_mult+1, F, A
	movlw	0x00
	addwfc	result_mult+0, F, A
	
	; multiply low(N) with 0x41
	movf	hex_number+1, W, A
	mullw	0x41
	movf	PRODL, W, A
	addwfc	result_mult+2, F, A
	movf	PRODH, W, A
	addwfc	result_mult+1, F, A
	movlw	0x00
	addwfc	result_mult+0, F, A
	
	; multiply high(N) with 0x41
	movf	hex_number, W, A
	mullw	0x41
	movf	PRODL, W, A
	addwfc	result_mult+1, F, A
	movf	PRODH, W, A
	addwfc	result_mult+0, F, A
	
	movlw	0x00
	
	return
	
	

mult_0A:
	; multiply low(reminder) with 0x0A
	movf	temp_result+2, W, A
	mullw	0x0A
	movf	PRODL, W, A
	addwfc	result_mult+3, F, A
	movf	PRODH, W, A
	addwfc	result_mult+2, F, A
	
	; multiply high(reminder) with 0x0A
	movf	temp_result+1, W, A
	mullw	0x0A
	movf	PRODL, W, A
	addwfc	result_mult+2, F, A
	movf	PRODH, W, A
	addwfc	result_mult+1, F, A
	movlw	0x00
	addwfc	result_mult+0, F, A
	
	; multiply upper(reminder) with 0x0A
	movf	temp_result+0, W, A
	mullw	0x0A
	movf	PRODL, W, A
	addwfc	result_mult+1, F, A
	movf	PRODH, W, A
	addwfc	result_mult+0, F, A
	
	return
	

copy_results:
	movff	result_mult+3, temp_result+2 ; move result to temporary memory
	movff	result_mult+2, temp_result+1
	movff	result_mult+1, temp_result+0
	clrf	result_mult+0			; clear result bytes 
	clrf	result_mult+1		      
	clrf	result_mult+2
	clrf	result_mult+3
	return