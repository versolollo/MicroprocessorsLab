	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0 
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	call 	SPI_MasterInit
	movlw	0x0f
	bra	SPI_Master_Transmit
	
	
SPI_MasterInit:
	bcf	CKE
	movlw	(SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK)
	MOVWF	SSP2CON1, A
	bcf	TRISD, PORTD_SDO2_POSN, A
	bcf	TRISD, PORTD_SCK2_POSN, A
	bcf	TRISD, PORTD_RD0_POSN, A
	bcf	PORTD, PORTD_RD0_POSN, A
	bsf	PORTD, PORTD_RD0_POSN, A
	return
	
SPI_Master_Transmit:
	movwf	SSP2BUF, A
Wait_Transmit:
	btfss	SSP2IF
	bra	Wait_Transmit
	bcf	SSP2IF
	return
	

	
	end	main
