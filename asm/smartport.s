		ORG	$C700

COMMAND		EQU	$42
UNIT		EQU	$43
ADDRESS_LO	EQU	$44
ADDRESS_HI	EQU	$45
BLOCK_LO	EQU	$46
BLOCK_HI 	EQU	$47

ROMRTS		EQU 	$FF58
BOOT		EQU	$0801

		LDX	#$20		; $20 $00 $03 $00 - Smartport signature
		LDX	#$00
		LDX	#$03
		LDX	#$00
		INX
		STX	COMMAND		; Read
		DEX
		STX	BLOCK_LO	; Block 0
		STX	BLOCK_HI
		STX	ADDRESS_LO	; Into $800
		LDX	#$08
		STX	ADDRESS_HI
		JSR	ROMRTS
		TSX
		LDA	$0100,X
		PHA			; Save slot address
		PHA			; RTS address hi byte
		LDA	#REENTRY - 1
		PHA                     ; RTS address lo byte
		CLV
		BVC	BLOCK_ENT
REENTRY		PLA			; Restore slot address
		ASL			; Make I/O register index
		ASL
		ASL
		ASL
		TAX
		JMP	BOOT
		DS	2
BLOCK_ENT	RTS
		DS	2
SMARTPOINT_ENT	RTS
PADDING		DS	$C7FE - PADDING
		ORG	$C7FE
FLAGS		DFB	$D7
ENTRY_LO	DFB	BLOCK_ENT

		END
