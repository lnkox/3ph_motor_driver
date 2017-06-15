
;CodeVisionAVR C Compiler V3.10 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega48PA
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 128 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega48PA
	#pragma AVRPART MEMORY PROG_FLASH 4096
	#pragma AVRPART MEMORY EEPROM 256
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x02FF
	.EQU __DSTACK_SIZE=0x0080
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_sineTable:
	.DB  0x0,0x6,0xC,0x12,0x18,0x1E,0x24,0x2A
	.DB  0x2F,0x35,0x3A,0x40,0x45,0x4A,0x4F,0x53
	.DB  0x58,0x5C,0x60,0x64,0x67,0x6B,0x6E,0x70
	.DB  0x73,0x75,0x77,0x79,0x7A,0x7B,0x7C,0x7C
	.DB  0x7C,0x7C,0x7C,0x7B,0x7A,0x79,0x77,0x75
	.DB  0x73,0x71,0x6E,0x6B,0x67,0x64,0x60,0x5C
	.DB  0x58,0x53,0x4F,0x4A,0x45,0x40,0x3A,0x35
	.DB  0x2F,0x2A,0x24,0x1E,0x18,0x12,0xC,0x6
	.DB  0x0,0xF9,0xF3,0xED,0xE7,0xE1,0xDB,0xD5
	.DB  0xD0,0xCA,0xC5,0xBF,0xBA,0xB5,0xB0,0xAC
	.DB  0xA7,0xA3,0x9F,0x9B,0x98,0x94,0x91,0x8F
	.DB  0x8C,0x8A,0x88,0x86,0x85,0x84,0x83,0x83
	.DB  0x83,0x83,0x83,0x84,0x85,0x86,0x88,0x8A
	.DB  0x8C,0x8E,0x91,0x94,0x98,0x9B,0x9F,0xA3
	.DB  0xA7,0xAC,0xB0,0xB5,0xBA,0xBF,0xC5,0xCA
	.DB  0xD0,0xD5,0xDB,0xE1,0xE7,0xED,0xF3,0xF9
	.DB  0xFF,0x0,0x6,0xC,0x12,0x18,0x1E,0x24
	.DB  0x2A,0x2F,0x35,0x3A,0x40,0x45,0x4A,0x4F
	.DB  0x53,0x58,0x5C,0x60,0x64,0x67,0x6B,0x6E
	.DB  0x70,0x73,0x75,0x77,0x79,0x7A,0x7B,0x7C
	.DB  0x7C,0x7C,0x7C,0x7C,0x7B,0x7A,0x79,0x77
	.DB  0x75,0x73,0x71,0x6E,0x6B,0x67,0x64,0x60
	.DB  0x5C,0x58,0x53,0x4F,0x4A,0x45,0x40,0x3A
	.DB  0x35,0x2F,0x2A,0x24,0x1E,0x18,0x12,0xC
	.DB  0x6,0x0,0xF9,0xF3,0xED,0xE7,0xE1,0xDB
	.DB  0xD5,0xD0,0xCA,0xC5,0xBF,0xBA,0xB5,0xB0
	.DB  0xAC,0xA7,0xA3,0x9F,0x9B,0x98,0x94,0x91
	.DB  0x8F,0x8C,0x8A,0x88,0x86,0x85,0x84,0x83
	.DB  0x83,0x83,0x83,0x83,0x84,0x85,0x86,0x88
	.DB  0x8A,0x8C,0x8E,0x91,0x94,0x98,0x9B,0x9F
	.DB  0xA3,0xA7,0xAC,0xB0,0xB5,0xBA,0xBF,0xC5
	.DB  0xCA,0xD0,0xD5,0xDB,0xE1,0xE7,0xED,0xF3
	.DB  0xF9,0xFF

_0x3:
	.DB  0x7C
_0x4:
	.DB  0x2A
_0x5:
	.DB  0x55

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _sinseg_period
	.DW  _0x3*2

	.DW  0x01
	.DW  _sinV
	.DW  _0x4*2

	.DW  0x01
	.DW  _sinW
	.DW  _0x5*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x180

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 08.06.2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega48
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
;*******************************************************/
;//початок Налаштування
;#define DEAD_TIME_HALF      2   //Мертвий час (1 = 0.26 мкс)
;#define ACCELERATION        40  //Прискорення  (Гц/сек)
;#define NORM_VOLTAGE        512 // Нормальне значення робочої напруги в одиницях АЦП (Макс:1023)
;#define MAX_BRAKE_VOLTAGE   562 // Максимальне допустипе значення напруги при гальмуванні в одиницях АЦП (Макс:1023)
;#define CRYTYCAL_VOLTAGE    594 // Критичне значення напруги в одиницях АЦП (Макс:1023)
;#define BRAKE_PERIOD        100 // Період гальмування двигуна (1/100 сек)
;#define NORM_TEMP_DRIVER    200 // Нормальне значення температури драйвера в одиницях АЦП (Макс:1023)
;#define MAX_TEMP_DRIVER     300 // Максимальне допустипе значення температури драйвера в одиницях АЦП (Макс:1023)
;
;
;//Кінець налаштувань
;
;
;#define SINE_TABLE_LENGTH   192 // Кількість значень в таблиці синусів
;
;#define DIRECTION_FORWARD       0 // Константа руху вперед
;#define DIRECTION_REVERSE       1 // Константа руху назад
;
;#define MODE_STOP      0 // режим "Зупинений"
;#define MODE_RUN       1 // режим "Робота"
;#define MODE_BRAKE     2 // режим "Гальмування"
;
;#define ERROR_NO            0 // Помилки відчсутні
;#define ERROR_POWER         1 // Відсутність живлення
;#define ERROR_OVERVOLTAGE   2 // Перенапруга на конденсаторі
;#define ERROR_OVERLOAD      3 // Перевантаження по струму
;#define ERROR_DRIVERTEMP    4 // Перегрів драйвера
;#define ERROR_MOTORTEMP     5 // Перегрів Двигуна
;
;// Роспіновка
;#define FORWARD_BUT     PIND.1  //  Кнопка запуску вперед
;#define STOP_BUT        PIND.0  //  Кнопка зупинки
;#define REVERSE_BUT     PINC.0  //  Кнопка запуску назад
;
;#define POWER_SENS      PIND.2  // Пропажа сети - нормальное состояние лог.0, при лог.1 - сделать стоп привода, после по ...
;#define CAP_VOLTAGE     3       //ADC3 - пренапряжение силовой части ( больше +340В).С силового конденсатора через делит ...
;#define DRIVER_TEMP     4       //ADC4 - измерение перегрева силовой части. Согласно таблицам расчитать работы терморези ...
;#define FREQUENCY_ADC   7       //ADC7 - регулировка частоты
;#define NORMAL_LED      PORTC.1 // - светодиод индикации работы - начинает гореть спустя 4 секунды после (включения PD2) ...
;#define ERROR_LED       PORTC.2 // - светодиод индикации аварии
;#define OVER_LOAD       PINB.4  // - сверхток - лог.0 (подтянут через 10К к 5В) - при подаче лог.0 на этот вывод - резко ...
;#define OVER_MOTORTEMP  PIND.4  // - Перегрев двигателя - нормальное состояние лог.0 при появлении лог.1. сделать стоп п ...
;
;// Кінець роспіновки
;
;#include <mega48pa.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;
;#include <delay.h>
;#include <md.h>
;
;void InsertDeadband(char compareValue, char * compareHighPtr, char * compareLowPtr); //Функція вставки метрвого часу
;void gen_next_sinpos(void); // Функція генерації наступного значення ШІМ
;void off_pwm(void); // Відключення всіх виходів на транзистори
;void sys_timer(void); // Системний таймер -100 Гц
;void set_freq(int fr); // Встановлення частоти синусоїди
;unsigned int read_adc(unsigned char adc_input); // Функйція отримання значення АЦП
;void check_button(); // Перевірка натисення кнопок
;// Declare your global variables here
;volatile int mode=0;
;volatile int direct=0;
;volatile float amplitude=0;
;volatile int sinseg_period=124,sinseg=0;

	.DSEG
;volatile int sys_timer_cnt=0;
;volatile int accel_cnt=0;
;volatile int cur_freq=0,freq=0;
;volatile int error_led_cnt=0,error_led_period=0,error=0;
;volatile int overload_state=0,overvoltage_state=0,crytycal_voltage=0;
;volatile int brake_cnt=0;
;volatile char sinU=0,sinV=42,sinW=85;
;
;#pragma warn-
;eeprom  int driver_temp_state;
;#pragma warn+
;long map(long x, long in_min, long in_max, long out_min, long out_max)
; 0000 0061 {

	.CSEG
; 0000 0062   return ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min);
;	x -> Y+16
;	in_min -> Y+12
;	in_max -> Y+8
;	out_min -> Y+4
;	out_max -> Y+0
; 0000 0063 }
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0066 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
; 0000 0067 
; 0000 0068 //     if (OVER_LOAD==0 ) {off_pwm(); mode=MODE_STOP;}// Постійна перевірка на перевантаження по струму
; 0000 0069    NORMAL_LED=!NORMAL_LED;
	SBIS 0x8,1
	RJMP _0x6
	CBI  0x8,1
	RJMP _0x7
_0x6:
	SBI  0x8,1
_0x7:
; 0000 006A     NORMAL_LED=!NORMAL_LED;
	SBIS 0x8,1
	RJMP _0x8
	CBI  0x8,1
	RJMP _0x9
_0x8:
	SBI  0x8,1
_0x9:
; 0000 006B //  sinseg++;
; 0000 006C //    if (sinseg>=sinseg_period)
; 0000 006D // {
; 0000 006E //    sinseg=0;
; 0000 006F //
; 0000 0070 //   if (mode>0 && overvoltage_state==0)
; 0000 0071 //   {
; 0000 0072 //       gen_next_sinpos();
; 0000 0073 //   }
; 0000 0074 //    else
; 0000 0075 //    {
; 0000 0076 //        off_pwm();
; 0000 0077 //    }
; 0000 0078 //   }
; 0000 0079 //    sys_timer_cnt++;
; 0000 007A //    if (sys_timer_cnt>138) {sys_timer_cnt=0; sys_timer();}
; 0000 007B 
; 0000 007C }
	RETI
; .FEND
;void sys_timer(void)
; 0000 007E {
; 0000 007F    if (mode>0)
; 0000 0080    {
; 0000 0081         if(cur_freq<freq || cur_freq>freq)
; 0000 0082         {
; 0000 0083             accel_cnt=accel_cnt+ACCELERATION;
; 0000 0084             if (accel_cnt>99)
; 0000 0085             {
; 0000 0086                 accel_cnt=0;
; 0000 0087                 if (cur_freq<freq) {cur_freq++;} else {cur_freq--;}
; 0000 0088                 set_freq(cur_freq);
; 0000 0089             }
; 0000 008A         }
; 0000 008B          if (mode==MODE_BRAKE)
; 0000 008C         {
; 0000 008D             freq=1;
; 0000 008E             if (cur_freq==1)  brake_cnt++;
; 0000 008F 
; 0000 0090             if (brake_cnt>BRAKE_PERIOD) {brake_cnt=0;mode=MODE_STOP;off_pwm();}
; 0000 0091         }
; 0000 0092         else
; 0000 0093         {
; 0000 0094             freq=map( read_adc(FREQUENCY_ADC),0,1023,1,60);
; 0000 0095         }
; 0000 0096 
; 0000 0097 
; 0000 0098    }
; 0000 0099    else
; 0000 009A    {
; 0000 009B         if (error>0)
; 0000 009C         {
; 0000 009D              error_led_cnt++;
; 0000 009E              if (error_led_cnt>error_led_period)
; 0000 009F              {
; 0000 00A0                 ERROR_LED=!ERROR_LED;
; 0000 00A1                 error_led_cnt=0;
; 0000 00A2              }
; 0000 00A3         }
; 0000 00A4         if (mode==MODE_STOP  && error==ERROR_NO)
; 0000 00A5         {
; 0000 00A6            NORMAL_LED=1;
; 0000 00A7         }
; 0000 00A8 
; 0000 00A9 
; 0000 00AA    }
; 0000 00AB 
; 0000 00AC    check_button();
; 0000 00AD }
;void check_button()
; 0000 00AF {
; 0000 00B0 
; 0000 00B1     if (mode==MODE_STOP)
; 0000 00B2     {
; 0000 00B3         if(REVERSE_BUT==0) {mode=MODE_RUN;direct=DIRECTION_REVERSE;}
; 0000 00B4         if(FORWARD_BUT==0) {mode=MODE_RUN;direct=DIRECTION_FORWARD;}
; 0000 00B5     }
; 0000 00B6     if(STOP_BUT==0)
; 0000 00B7     {
; 0000 00B8         if (mode==MODE_STOP)
; 0000 00B9         {
; 0000 00BA             overload_state=0;
; 0000 00BB             crytycal_voltage=0;
; 0000 00BC         }
; 0000 00BD         else
; 0000 00BE         {
; 0000 00BF             mode=MODE_BRAKE;
; 0000 00C0         }
; 0000 00C1     }
; 0000 00C2 }
;void gen_next_sinpos(void)
; 0000 00C4 {
; 0000 00C5     char tempU,tempV,tempW;
; 0000 00C6     char compareHigh, compareLow;
; 0000 00C7     sinU++;sinV++;sinW++;
;	tempU -> R17
;	tempV -> R16
;	tempW -> R19
;	compareHigh -> R18
;	compareLow -> R21
; 0000 00C8     tempU=127+(sineTable[sinU]*amplitude);
; 0000 00C9     if (direct == DIRECTION_FORWARD)
; 0000 00CA     {
; 0000 00CB         tempV =127+(sineTable[sinV]*amplitude);
; 0000 00CC         tempW =127+(sineTable[sinW]*amplitude);
; 0000 00CD     }
; 0000 00CE     else
; 0000 00CF     {
; 0000 00D0         tempW =127+(sineTable[sinV]*amplitude);
; 0000 00D1         tempV =127+(sineTable[sinW]*amplitude);
; 0000 00D2     }
; 0000 00D3 
; 0000 00D4     InsertDeadband(tempU, &compareHigh, &compareLow);
; 0000 00D5     OCR0A = compareHigh;
; 0000 00D6     OCR0B = compareLow;
; 0000 00D7 
; 0000 00D8     InsertDeadband(tempV, &compareHigh, &compareLow);
; 0000 00D9     OCR1AL = compareHigh;
; 0000 00DA     OCR1BL = compareLow;
; 0000 00DB 
; 0000 00DC     InsertDeadband(tempW, &compareHigh, &compareLow);
; 0000 00DD     OCR2A = compareHigh;
; 0000 00DE     OCR2B = compareLow;
; 0000 00DF }
;
;void InsertDeadband(char compareValue, char * compareHighPtr, char * compareLowPtr)   //вставка метвого часу
; 0000 00E2 {
; 0000 00E3   if (compareValue <= DEAD_TIME_HALF)
;	compareValue -> Y+4
;	*compareHighPtr -> Y+2
;	*compareLowPtr -> Y+0
; 0000 00E4   {
; 0000 00E5     *compareHighPtr = 0x00;
; 0000 00E6     *compareLowPtr = compareValue;
; 0000 00E7   }
; 0000 00E8   else if (compareValue >= (0xff - DEAD_TIME_HALF))
; 0000 00E9   {
; 0000 00EA     *compareHighPtr = 0xff - (2 * DEAD_TIME_HALF);
; 0000 00EB     *compareLowPtr = 0xff;
; 0000 00EC   }
; 0000 00ED   else
; 0000 00EE   {
; 0000 00EF     *compareHighPtr = compareValue - DEAD_TIME_HALF;
; 0000 00F0     *compareLowPtr = compareValue + DEAD_TIME_HALF;
; 0000 00F1   }
; 0000 00F2 }
;
;void set_freq(int fr)
; 0000 00F5 {
; 0000 00F6    float amp;
; 0000 00F7    sinseg_period=62/fr;
;	fr -> Y+4
;	amp -> Y+0
; 0000 00F8    amp=map(fr,1,50,30,100);
; 0000 00F9    if (amp>100) amp=100;
; 0000 00FA    amplitude=amp/100;
; 0000 00FB }
;void off_pwm(void)
; 0000 00FD {
; 0000 00FE     OCR0A=0x00;
; 0000 00FF     OCR0B=0xFF;
; 0000 0100     OCR1AL=0x00;
; 0000 0101     OCR1BL=0xFF;
; 0000 0102     OCR2A=0x00;
; 0000 0103     OCR2B=0xFF;
; 0000 0104 }
;void check_error(void)
; 0000 0106 {
; 0000 0107     volatile int tmp_error=0;
; 0000 0108     volatile int capvoltage,driver_t=0;
; 0000 0109    // capvoltage=read_adc(CAP_VOLTAGE);
; 0000 010A     //POWER_SENS
; 0000 010B 
; 0000 010C    // if (capvoltage<NORM_VOLTAGE){overvoltage_state=0;}
; 0000 010D    // if (capvoltage>MAX_BRAKE_VOLTAGE) {off_pwm();overvoltage_state=1;}
; 0000 010E    // if (capvoltage>CRYTYCAL_VOLTAGE || crytycal_voltage==1) {off_pwm(); mode=MODE_STOP;crytycal_voltage=1; error_led_p ...
; 0000 010F    // driver_t=read_adc(DRIVER_TEMP);
; 0000 0110    // if (driver_t>MAX_TEMP_DRIVER || driver_temp_state==1)   {off_pwm(); mode=MODE_STOP;driver_temp_state=1; error_led_ ...
; 0000 0111    // if (driver_t<NORM_TEMP_DRIVER)  {driver_temp_state=0;}
; 0000 0112     if (OVER_LOAD==0 || overload_state==1) {off_pwm(); mode=MODE_STOP;overload_state=1; ERROR_LED=1;tmp_error=ERROR_OVER ...
;	tmp_error -> Y+4
;	capvoltage -> Y+2
;	driver_t -> Y+0
; 0000 0113    // if (OVER_MOTORTEMP==1) {mode=MODE_STOP; tmp_error=ERROR_MOTORTEMP;error_led_period=100;}
; 0000 0114     error=tmp_error;
; 0000 0115     if (error==0) {ERROR_LED=0;}
; 0000 0116 }
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 011C {
; 0000 011D     ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 011E     // Delay needed for the stabilization of the ADC input voltage
; 0000 011F     delay_us(10);
; 0000 0120     // Start the AD conversion
; 0000 0121     ADCSRA|=(1<<ADSC);
; 0000 0122     // Wait for the AD conversion to complete
; 0000 0123     while ((ADCSRA & (1<<ADIF))==0);
; 0000 0124     ADCSRA|=(1<<ADIF);
; 0000 0125     return ADCW;
; 0000 0126 }
;
;void main(void)
; 0000 0129 {
_main:
; .FSTART _main
; 0000 012A // Declare your local variables here
; 0000 012B // Crystal Oscillator division factor: 1
; 0000 012C #pragma optsize-
; 0000 012D CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 012E CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 012F #ifdef _OPTIMIZE_SIZE_
; 0000 0130 #pragma optsize+
; 0000 0131 #endif
; 0000 0132 
; 0000 0133 // Input/Output Ports initialization
; 0000 0134 // Port B initialization
; 0000 0135 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=In
; 0000 0136 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x4,R30
; 0000 0137 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=T
; 0000 0138 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 0139 
; 0000 013A 
; 0000 013B // Port C initialization
; 0000 013C // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In
; 0000 013D DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(6)
	OUT  0x7,R30
; 0000 013E // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T
; 0000 013F PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0140 
; 0000 0141 //
; 0000 0142 // Port D initialization
; 0000 0143 // Function: Bit7=In Bit6=Out Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0144 DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(104)
	OUT  0xA,R30
; 0000 0145 // State: Bit7=T Bit6=0 Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 0146 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0147 
; 0000 0148 // Timer/Counter 0 initialization
; 0000 0149 // Clock source: System Clock
; 0000 014A // Clock value: 8000,000 kHz
; 0000 014B // Mode: Phase correct PWM top=0xFF
; 0000 014C // OC0A output: Non-Inverted PWM
; 0000 014D // OC0B output: Inverted PWM
; 0000 014E // Timer Period: 0,06375 ms
; 0000 014F // Output Pulse(s):
; 0000 0150 // OC0A Period: 0,06375 ms Width: 0 us// OC0B Period: 0,06375 ms Width: 0,06375 ms
; 0000 0151 TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (1<<COM0B1) | (1<<COM0B0) | (0<<WGM01) | (1<<WGM00);
	LDI  R30,LOW(177)
	OUT  0x24,R30
; 0000 0152 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 0153 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0154 OCR0A=0x00;
	OUT  0x27,R30
; 0000 0155 OCR0B=0xFF;
	LDI  R30,LOW(255)
	OUT  0x28,R30
; 0000 0156 
; 0000 0157 // Timer/Counter 1 initialization
; 0000 0158 // Clock source: System Clock
; 0000 0159 // Clock value: 8000,000 kHz
; 0000 015A // Mode: Ph. correct PWM top=0x00FF
; 0000 015B // OC1A output: Non-Inverted PWM
; 0000 015C // OC1B output: Inverted PWM
; 0000 015D // Noise Canceler: Off
; 0000 015E // Input Capture on Falling Edge
; 0000 015F // Timer Period: 0,06375 ms
; 0000 0160 // Output Pulse(s):
; 0000 0161 // OC1A Period: 0,06375 ms Width: 0 us// OC1B Period: 0,06375 ms Width: 0,06375 ms
; 0000 0162 // Timer1 Overflow Interrupt: On
; 0000 0163 // Input Capture Interrupt: Off
; 0000 0164 // Compare A Match Interrupt: Off
; 0000 0165 // Compare B Match Interrupt: Off
; 0000 0166 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(177)
	STS  128,R30
; 0000 0167 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 0168 TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 0169 TCNT1L=0x00;
	STS  132,R30
; 0000 016A ICR1H=0x00;
	STS  135,R30
; 0000 016B ICR1L=0x00;
	STS  134,R30
; 0000 016C OCR1AH=0x00;
	STS  137,R30
; 0000 016D OCR1AL=0x00;
	STS  136,R30
; 0000 016E OCR1BH=0x00;
	STS  139,R30
; 0000 016F OCR1BL=0xFF;
	LDI  R30,LOW(255)
	STS  138,R30
; 0000 0170 
; 0000 0171 // Timer/Counter 2 initialization
; 0000 0172 // Clock source: System Clock
; 0000 0173 // Clock value: 8000,000 kHz
; 0000 0174 // Mode: Phase correct PWM top=0xFF
; 0000 0175 // OC2A output: Non-Inverted PWM
; 0000 0176 // OC2B output: Inverted PWM
; 0000 0177 // Timer Period: 0,06375 ms
; 0000 0178 // Output Pulse(s):
; 0000 0179 // OC2A Period: 0,06375 ms Width: 0 us// OC2B Period: 0,06375 ms Width: 0,06375 ms
; 0000 017A ASSR=(0<<EXCLK) | (0<<AS2);
	LDI  R30,LOW(0)
	STS  182,R30
; 0000 017B TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (0<<WGM21) | (1<<WGM20);
	LDI  R30,LOW(177)
	STS  176,R30
; 0000 017C TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(1)
	STS  177,R30
; 0000 017D TCNT2=0x00;
	LDI  R30,LOW(0)
	STS  178,R30
; 0000 017E OCR2A=0x00;
	STS  179,R30
; 0000 017F OCR2B=0xFF;
	LDI  R30,LOW(255)
	STS  180,R30
; 0000 0180 
; 0000 0181 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0182 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 0183 
; 0000 0184 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0185 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 0186 
; 0000 0187 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0188 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 0189 
; 0000 018A // External Interrupt(s) initialization
; 0000 018B // INT0: Off
; 0000 018C // INT1: Off
; 0000 018D // Interrupt on any change on pins PCINT0-7: Off
; 0000 018E // Interrupt on any change on pins PCINT8-14: Off
; 0000 018F // Interrupt on any change on pins PCINT16-23: Off
; 0000 0190 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 0191 EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 0192 PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 0193 
; 0000 0194 // USART initialization
; 0000 0195 // USART disabled
; 0000 0196 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 0197 
; 0000 0198 // Analog Comparator initialization
; 0000 0199 // Analog Comparator: Off
; 0000 019A // The Analog Comparator's positive input is
; 0000 019B // connected to the AIN0 pin
; 0000 019C // The Analog Comparator's negative input is
; 0000 019D // connected to the AIN1 pin
; 0000 019E ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 019F // Digital input buffer on AIN0: On
; 0000 01A0 // Digital input buffer on AIN1: On
; 0000 01A1 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 01A2 
; 0000 01A3 
; 0000 01A4 // ADC initialization
; 0000 01A5 // ADC Clock frequency: 1000,000 kHz
; 0000 01A6 // ADC Voltage Reference: AVCC pin
; 0000 01A7 // ADC Auto Trigger Source: ADC Stopped
; 0000 01A8 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 01A9 // ADC4: On, ADC5: On
; 0000 01AA DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 01AB ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 01AC ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	STS  122,R30
; 0000 01AD ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 01AE 
; 0000 01AF // SPI initialization
; 0000 01B0 // SPI disabled
; 0000 01B1 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 01B2 
; 0000 01B3 // TWI initialization
; 0000 01B4 // TWI disabled
; 0000 01B5 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 01B6 
; 0000 01B7 // Global enable interrupts
; 0000 01B8 TCNT0=0;    //Синхронізація таймерів
	OUT  0x26,R30
; 0000 01B9 TCNT1L=2;   //Синхронізація таймерів
	LDI  R30,LOW(2)
	STS  132,R30
; 0000 01BA TCNT2=5;    //Синхронізація таймерів
	LDI  R30,LOW(5)
	STS  178,R30
; 0000 01BB #asm("sei")
	sei
; 0000 01BC mode=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _mode,R30
	STS  _mode+1,R31
; 0000 01BD sinseg_period=1;
	STS  _sinseg_period,R30
	STS  _sinseg_period+1,R31
; 0000 01BE while (1)
_0x37:
; 0000 01BF       {
; 0000 01C0        // check_error(); // Перевірка на помилки (Виконується весь вільний процесорний час)
; 0000 01C1 
; 0000 01C2 
; 0000 01C3       }
	RJMP _0x37
; 0000 01C4 }
_0x3A:
	RJMP _0x3A
; .FEND

	.DSEG
_mode:
	.BYTE 0x2
_direct:
	.BYTE 0x2
_amplitude:
	.BYTE 0x4
_sinseg_period:
	.BYTE 0x2
_accel_cnt:
	.BYTE 0x2
_cur_freq:
	.BYTE 0x2
_freq:
	.BYTE 0x2
_error_led_cnt:
	.BYTE 0x2
_error_led_period:
	.BYTE 0x2
_error:
	.BYTE 0x2
_overload_state:
	.BYTE 0x2
_crytycal_voltage:
	.BYTE 0x2
_brake_cnt:
	.BYTE 0x2
_sinU:
	.BYTE 0x1
_sinV:
	.BYTE 0x1
_sinW:
	.BYTE 0x1

	.CSEG

	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
