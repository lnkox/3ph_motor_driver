
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega48
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega48
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
	.EQU __DSTACK_SIZE=0x0100
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
<<<<<<< HEAD
	.DEF _d=R4
=======
	.DEF _p1l=R4
	.DEF _p1h=R3
	.DEF _p2l=R6
	.DEF _p2h=R5
	.DEF _p3l=R8
	.DEF _p3h=R7
	.DEF _sys_timer_cnt=R10
>>>>>>> origin/master

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _wdt_timeout_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
<<<<<<< HEAD
	RJMP 0x00
	RJMP _timer1_compa_isr
=======
>>>>>>> origin/master
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
<<<<<<< HEAD

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0


__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x04
=======
	RJMP 0x00

_period_table:
	.DB  0x0,0x0,0x1A,0x7,0x8D,0x3,0x5E,0x2
	.DB  0xC6,0x1,0x6B,0x1,0x2F,0x1,0x3,0x1
	.DB  0xE3,0x0,0xCA,0x0,0xB5,0x0,0xA5,0x0
	.DB  0x97,0x0,0x8B,0x0,0x81,0x0,0x79,0x0
	.DB  0x71,0x0,0x6A,0x0,0x65,0x0,0x5F,0x0
	.DB  0x5A,0x0,0x56,0x0,0x52,0x0,0x4F,0x0
	.DB  0x4B,0x0,0x48,0x0,0x45,0x0,0x43,0x0
	.DB  0x40,0x0,0x3E,0x0,0x3C,0x0,0x3A,0x0
	.DB  0x38,0x0,0x37,0x0,0x35,0x0,0x33,0x0
	.DB  0x32,0x0,0x31,0x0,0x2F,0x0,0x2E,0x0
	.DB  0x2D,0x0,0x2C,0x0,0x2B,0x0,0x2A,0x0
	.DB  0x29,0x0,0x28,0x0,0x27,0x0,0x26,0x0
	.DB  0x25,0x0,0x25,0x0,0x24,0x0,0x23,0x0
	.DB  0x22,0x0,0x22,0x0,0x21,0x0,0x21,0x0
	.DB  0x20,0x0,0x1F,0x0,0x1F,0x0,0x1E,0x0
	.DB  0x1E,0x0
_sineTable:
	.DB  0x0,0x2,0x6,0xA,0xD,0x10,0x14,0x16
	.DB  0x19,0x1B,0x1E,0x1F,0x21,0x23,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x23,0x21,0x1F,0x1E
	.DB  0x1B,0x19,0x16,0x14,0x10,0xD,0xA,0x6
	.DB  0x2,0x0,0x0,0x3,0x7,0xB,0xD,0x11
	.DB  0x15,0x17,0x1B,0x1E,0x20,0x21,0x24,0x25
	.DB  0x26,0x26,0x26,0x26,0x26,0x26,0x25,0x24
	.DB  0x21,0x20,0x1E,0x1B,0x17,0x15,0x11,0xD
	.DB  0xB,0x7,0x3,0x0,0x0,0x3,0x7,0xB
	.DB  0xF,0x12,0x15,0x19,0x1B,0x1E,0x20,0x23
	.DB  0x25,0x26,0x28,0x28,0x28,0x28,0x28,0x28
	.DB  0x26,0x25,0x23,0x20,0x1E,0x1B,0x19,0x15
	.DB  0x12,0xF,0xB,0x7,0x3,0x0,0x0,0x3
	.DB  0x7,0xB,0x10,0x14,0x16,0x1A,0x1E,0x20
	.DB  0x23,0x25,0x26,0x29,0x2A,0x2A,0x2A,0x2A
	.DB  0x2A,0x2A,0x29,0x26,0x25,0x23,0x20,0x1E
	.DB  0x1A,0x16,0x14,0x10,0xB,0x7,0x3,0x0
	.DB  0x0,0x3,0x7,0xC,0x10,0x14,0x17,0x1B
	.DB  0x1E,0x21,0x24,0x26,0x28,0x2A,0x2A,0x2B
	.DB  0x2B,0x2B,0x2B,0x2A,0x2A,0x28,0x26,0x24
	.DB  0x21,0x1E,0x1B,0x17,0x14,0x10,0xC,0x7
	.DB  0x3,0x0,0x0,0x3,0x8,0xC,0x11,0x15
	.DB  0x19,0x1C,0x20,0x23,0x25,0x28,0x2A,0x2B
	.DB  0x2D,0x2E,0x2E,0x2E,0x2E,0x2D,0x2B,0x2A
	.DB  0x28,0x25,0x23,0x20,0x1C,0x19,0x15,0x11
	.DB  0xC,0x8,0x3,0x0,0x0,0x3,0x8,0xC
	.DB  0x11,0x15,0x1A,0x1E,0x20,0x24,0x26,0x29
	.DB  0x2B,0x2D,0x2E,0x2F,0x2F,0x2F,0x2F,0x2E
	.DB  0x2D,0x2B,0x29,0x26,0x24,0x20,0x1E,0x1A
	.DB  0x15,0x11,0xC,0x8,0x3,0x0,0x0,0x3
	.DB  0x8,0xD,0x12,0x16,0x1B,0x1F,0x23,0x25
	.DB  0x29,0x2B,0x2E,0x2F,0x30,0x32,0x32,0x32
	.DB  0x32,0x30,0x2F,0x2E,0x2B,0x29,0x25,0x23
	.DB  0x1F,0x1B,0x16,0x12,0xD,0x8,0x3,0x0
	.DB  0x0,0x3,0x8,0xD,0x12,0x17,0x1B,0x1F
	.DB  0x23,0x26,0x2A,0x2D,0x2F,0x30,0x32,0x33
	.DB  0x33,0x33,0x33,0x32,0x30,0x2F,0x2D,0x2A
	.DB  0x26,0x23,0x1F,0x1B,0x17,0x12,0xD,0x8
	.DB  0x3,0x0,0x0,0x5,0xA,0xF,0x12,0x17
	.DB  0x1C,0x20,0x24,0x28,0x2B,0x2E,0x30,0x32
	.DB  0x33,0x34,0x34,0x34,0x34,0x33,0x32,0x30
	.DB  0x2E,0x2B,0x28,0x24,0x20,0x1C,0x17,0x12
	.DB  0xF,0xA,0x5,0x0,0x0,0x5,0xA,0xF
	.DB  0x14,0x19,0x1E,0x21,0x26,0x2A,0x2D,0x2F
	.DB  0x32,0x34,0x35,0x37,0x37,0x37,0x37,0x35
	.DB  0x34,0x32,0x2F,0x2D,0x2A,0x26,0x21,0x1E
	.DB  0x19,0x14,0xF,0xA,0x5,0x0,0x0,0x5
	.DB  0xA,0xF,0x15,0x1A,0x1E,0x23,0x26,0x2A
	.DB  0x2E,0x30,0x33,0x35,0x37,0x38,0x38,0x38
	.DB  0x38,0x37,0x35,0x33,0x30,0x2E,0x2A,0x26
	.DB  0x23,0x1E,0x1A,0x15,0xF,0xA,0x5,0x0
	.DB  0x0,0x5,0xB,0x10,0x15,0x1A,0x1F,0x24
	.DB  0x29,0x2D,0x30,0x33,0x35,0x38,0x39,0x3A
	.DB  0x3A,0x3A,0x3A,0x39,0x38,0x35,0x33,0x30
	.DB  0x2D,0x29,0x24,0x1F,0x1A,0x15,0x10,0xB
	.DB  0x5,0x0,0x0,0x5,0xB,0x10,0x16,0x1B
	.DB  0x20,0x25,0x29,0x2E,0x30,0x34,0x37,0x39
	.DB  0x3A,0x3C,0x3C,0x3C,0x3C,0x3A,0x39,0x37
	.DB  0x34,0x30,0x2E,0x29,0x25,0x20,0x1B,0x16
	.DB  0x10,0xB,0x5,0x0,0x0,0x5,0xB,0x11
	.DB  0x16,0x1C,0x21,0x26,0x2B,0x2F,0x33,0x37
	.DB  0x39,0x3C,0x3D,0x3E,0x3E,0x3E,0x3E,0x3D
	.DB  0x3C,0x39,0x37,0x33,0x2F,0x2B,0x26,0x21
	.DB  0x1C,0x16,0x11,0xB,0x5,0x0,0x0,0x5
	.DB  0xB,0x11,0x17,0x1C,0x23,0x28,0x2B,0x30
	.DB  0x34,0x38,0x3A,0x3D,0x3E,0x3F,0x3F,0x3F
	.DB  0x3F,0x3E,0x3D,0x3A,0x38,0x34,0x30,0x2B
	.DB  0x28,0x23,0x1C,0x17,0x11,0xB,0x5,0x0
	.DB  0x0,0x6,0xC,0x12,0x19,0x1E,0x24,0x29
	.DB  0x2E,0x32,0x35,0x39,0x3D,0x3F,0x41,0x42
	.DB  0x42,0x42,0x42,0x41,0x3F,0x3D,0x39,0x35
	.DB  0x32,0x2E,0x29,0x24,0x1E,0x19,0x12,0xC
	.DB  0x6,0x0,0x0,0x6,0xC,0x12,0x19,0x1F
	.DB  0x24,0x29,0x2E,0x33,0x37,0x3A,0x3E,0x3F
	.DB  0x42,0x43,0x43,0x43,0x43,0x42,0x3F,0x3E
	.DB  0x3A,0x37,0x33,0x2E,0x2A,0x24,0x1F,0x19
	.DB  0x12,0xC,0x6,0x0,0x0,0x6,0xC,0x12
	.DB  0x19,0x1F,0x25,0x2A,0x2F,0x34,0x38,0x3C
	.DB  0x3E,0x41,0x43,0x44,0x44,0x44,0x44,0x43
	.DB  0x41,0x3E,0x3C,0x38,0x34,0x2F,0x2A,0x25
	.DB  0x1F,0x19,0x12,0xC,0x6,0x0,0x0,0x6
	.DB  0xC,0x14,0x1A,0x20,0x26,0x2B,0x32,0x35
	.DB  0x3A,0x3E,0x41,0x43,0x46,0x47,0x47,0x47
	.DB  0x47,0x46,0x43,0x41,0x3E,0x3A,0x35,0x32
	.DB  0x2B,0x26,0x20,0x1A,0x14,0xC,0x6,0x0
	.DB  0x0,0x6,0xD,0x14,0x1A,0x21,0x26,0x2D
	.DB  0x32,0x37,0x3C,0x3F,0x42,0x44,0x47,0x48
	.DB  0x48,0x48,0x48,0x47,0x44,0x42,0x3F,0x3C
	.DB  0x37,0x32,0x2D,0x26,0x21,0x1A,0x14,0xD
	.DB  0x6,0x0,0x0,0x6,0xD,0x15,0x1B,0x21
	.DB  0x28,0x2E,0x34,0x39,0x3D,0x41,0x44,0x47
	.DB  0x49,0x4B,0x4B,0x4B,0x4B,0x49,0x47,0x44
	.DB  0x41,0x3D,0x39,0x34,0x2E,0x28,0x21,0x1B
	.DB  0x15,0xD,0x6,0x0,0x0,0x6,0xD,0x15
	.DB  0x1C,0x23,0x29,0x2F,0x34,0x39,0x3E,0x42
	.DB  0x46,0x48,0x4B,0x4C,0x4C,0x4C,0x4C,0x4B
	.DB  0x48,0x46,0x42,0x3E,0x39,0x34,0x2F,0x29
	.DB  0x23,0x1C,0x15,0xD,0x6,0x0,0x0,0x7
	.DB  0xF,0x16,0x1C,0x24,0x2A,0x30,0x37,0x3C
	.DB  0x41,0x44,0x48,0x4B,0x4D,0x4E,0x4E,0x4E
	.DB  0x4E,0x4D,0x4B,0x48,0x44,0x41,0x3C,0x37
	.DB  0x30,0x2A,0x24,0x1C,0x16,0xF,0x7,0x0
	.DB  0x0,0x7,0xF,0x16,0x1E,0x24,0x2B,0x32
	.DB  0x37,0x3D,0x41,0x46,0x49,0x4C,0x4E,0x50
	.DB  0x50,0x50,0x50,0x4E,0x4C,0x49,0x46,0x41
	.DB  0x3D,0x37,0x32,0x2B,0x24,0x1E,0x16,0xF
	.DB  0x7,0x0,0x0,0x7,0xF,0x16,0x1E,0x25
	.DB  0x2D,0x33,0x39,0x3E,0x43,0x48,0x4B,0x4E
	.DB  0x51,0x52,0x52,0x52,0x52,0x51,0x4E,0x4B
	.DB  0x48,0x43,0x3E,0x39,0x33,0x2D,0x25,0x1E
	.DB  0x16,0xF,0x7,0x0,0x0,0x7,0xF,0x17
	.DB  0x1F,0x26,0x2D,0x34,0x39,0x3F,0x44,0x48
	.DB  0x4C,0x50,0x52,0x53,0x53,0x53,0x53,0x52
	.DB  0x50,0x4C,0x48,0x44,0x3F,0x39,0x34,0x2D
	.DB  0x26,0x1F,0x17,0xF,0x7,0x0,0x0,0x7
	.DB  0x10,0x17,0x1F,0x26,0x2E,0x34,0x3A,0x41
	.DB  0x46,0x49,0x4D,0x51,0x53,0x55,0x55,0x55
	.DB  0x55,0x53,0x51,0x4D,0x49,0x46,0x41,0x3A
	.DB  0x34,0x2E,0x26,0x1F,0x17,0x10,0x7,0x0
	.DB  0x0,0x7,0x10,0x19,0x20,0x28,0x2F,0x35
	.DB  0x3C,0x42,0x47,0x4C,0x50,0x53,0x55,0x57
	.DB  0x57,0x57,0x57,0x55,0x53,0x50,0x4C,0x47
	.DB  0x42,0x3C,0x35,0x2F,0x28,0x20,0x19,0x10
	.DB  0x7,0x0,0x0,0x7,0x10,0x19,0x20,0x28
	.DB  0x2F,0x37,0x3D,0x43,0x48,0x4D,0x51,0x55
	.DB  0x56,0x58,0x58,0x58,0x58,0x56,0x55,0x51
	.DB  0x4D,0x48,0x43,0x3D,0x37,0x2F,0x28,0x20
	.DB  0x19,0x10,0x7,0x0,0x0,0x8,0x11,0x19
	.DB  0x21,0x29,0x32,0x38,0x3F,0x44,0x4B,0x50
	.DB  0x53,0x56,0x58,0x5B,0x5B,0x5B,0x5B,0x58
	.DB  0x56,0x53,0x50,0x4B,0x44,0x3F,0x38,0x32
	.DB  0x29,0x21,0x19,0x11,0x8,0x0,0x0,0x8
	.DB  0x11,0x1A,0x21,0x2A,0x32,0x39,0x3F,0x46
	.DB  0x4C,0x50,0x55,0x57,0x5A,0x5C,0x5C,0x5C
	.DB  0x5C,0x5A,0x57,0x55,0x50,0x4C,0x46,0x3F
	.DB  0x39,0x32,0x2A,0x21,0x1A,0x11,0x8,0x0
	.DB  0x0,0x8,0x11,0x1A,0x23,0x2A,0x33,0x39
	.DB  0x41,0x47,0x4C,0x51,0x56,0x58,0x5B,0x5D
	.DB  0x5D,0x5D,0x5D,0x5B,0x58,0x56,0x51,0x4C
	.DB  0x47,0x41,0x39,0x33,0x2A,0x23,0x1A,0x11
	.DB  0x8,0x0,0x0,0x8,0x11,0x1A,0x23,0x2B
	.DB  0x34,0x3C,0x42,0x48,0x4E,0x53,0x57,0x5B
	.DB  0x5D,0x60,0x60,0x60,0x60,0x5D,0x5B,0x57
	.DB  0x53,0x4E,0x48,0x42,0x3C,0x34,0x2B,0x23
	.DB  0x1A,0x11,0x8,0x0,0x0,0x8,0x11,0x1B
	.DB  0x24,0x2D,0x34,0x3C,0x43,0x49,0x50,0x55
	.DB  0x58,0x5C,0x5F,0x61,0x61,0x61,0x61,0x5F
	.DB  0x5C,0x58,0x55,0x50,0x49,0x43,0x3C,0x34
	.DB  0x2D,0x24,0x1B,0x11,0x8,0x0,0x0,0x8
	.DB  0x12,0x1B,0x25,0x2E,0x35,0x3E,0x44,0x4C
	.DB  0x51,0x57,0x5B,0x5F,0x61,0x64,0x64,0x64
	.DB  0x64,0x61,0x5F,0x5B,0x57,0x51,0x4C,0x44
	.DB  0x3E,0x35,0x2E,0x25,0x1B,0x12,0x8,0x0
	.DB  0x0,0x8,0x12,0x1C,0x25,0x2E,0x37,0x3E
	.DB  0x46,0x4C,0x52,0x58,0x5C,0x60,0x62,0x65
	.DB  0x65,0x65,0x65,0x62,0x60,0x5C,0x58,0x52
	.DB  0x4C,0x46,0x3E,0x37,0x2E,0x25,0x1C,0x12
	.DB  0x8,0x0,0x0,0x8,0x12,0x1C,0x26,0x2F
	.DB  0x38,0x3F,0x47,0x4E,0x55,0x5A,0x5F,0x62
	.DB  0x65,0x67,0x67,0x67,0x67,0x65,0x62,0x5F
	.DB  0x5A,0x55,0x4E,0x47,0x3F,0x38,0x2F,0x26
	.DB  0x1C,0x12,0x8,0x0,0x0,0xA,0x14,0x1C
	.DB  0x26,0x2F,0x38,0x41,0x48,0x50,0x56,0x5B
	.DB  0x60,0x64,0x66,0x69,0x69,0x69,0x69,0x66
	.DB  0x64,0x60,0x5B,0x56,0x50,0x48,0x41,0x38
	.DB  0x2F,0x26,0x1C,0x14,0xA,0x0,0x0,0xA
	.DB  0x14,0x1E,0x26,0x30,0x39,0x42,0x49,0x50
	.DB  0x57,0x5C,0x61,0x65,0x67,0x6A,0x6A,0x6A
	.DB  0x6A,0x67,0x65,0x61,0x5C,0x57,0x50,0x49
	.DB  0x42,0x39,0x30,0x26,0x1E,0x14,0xA,0x0
	.DB  0x0,0xA,0x14,0x1E,0x28,0x32,0x3A,0x43
	.DB  0x4B,0x52,0x58,0x5F,0x64,0x67,0x6A,0x6C
	.DB  0x6C,0x6C,0x6C,0x6A,0x67,0x64,0x5F,0x58
	.DB  0x52,0x4B,0x43,0x3A,0x32,0x28,0x1E,0x14
	.DB  0xA,0x0,0x0,0xA,0x14,0x1F,0x29,0x32
	.DB  0x3C,0x44,0x4C,0x53,0x5A,0x60,0x64,0x69
	.DB  0x6B,0x6E,0x6E,0x6E,0x6E,0x6B,0x69,0x64
	.DB  0x60,0x5A,0x53,0x4C,0x44,0x3C,0x32,0x29
	.DB  0x1F,0x14,0xA,0x0,0x0,0xA,0x15,0x1F
	.DB  0x29,0x33,0x3D,0x46,0x4D,0x55,0x5C,0x61
	.DB  0x66,0x6A,0x6E,0x70,0x70,0x70,0x70,0x6E
	.DB  0x6A,0x66,0x61,0x5C,0x55,0x4D,0x46,0x3D
	.DB  0x33,0x29,0x1F,0x15,0xA,0x0,0x0,0xA
	.DB  0x15,0x1F,0x2A,0x34,0x3D,0x46,0x4E,0x56
	.DB  0x5C,0x62,0x67,0x6B,0x6F,0x71,0x71,0x71
	.DB  0x71,0x6F,0x6B,0x67,0x62,0x5C,0x56,0x4E
	.DB  0x46,0x3D,0x34,0x2A,0x1F,0x15,0xA,0x0
	.DB  0x0,0xA,0x15,0x20,0x2A,0x34,0x3E,0x47
	.DB  0x50,0x57,0x5D,0x64,0x69,0x6C,0x70,0x73
	.DB  0x73,0x73,0x73,0x70,0x6C,0x69,0x64,0x5D
	.DB  0x57,0x50,0x47,0x3E,0x34,0x2A,0x20,0x15
	.DB  0xA,0x0,0x0,0xB,0x15,0x20,0x2B,0x35
	.DB  0x3F,0x48,0x51,0x58,0x60,0x66,0x6B,0x6F
	.DB  0x73,0x75,0x75,0x75,0x75,0x73,0x6F,0x6B
	.DB  0x66,0x60,0x58,0x51,0x48,0x3F,0x35,0x2B
	.DB  0x20,0x15,0xB,0x0,0x0,0xB,0x16,0x21
	.DB  0x2B,0x35,0x3F,0x49,0x52,0x5A,0x61,0x67
	.DB  0x6C,0x70,0x74,0x76,0x76,0x76,0x76,0x74
	.DB  0x70,0x6C,0x67,0x61,0x5A,0x52,0x49,0x3F
	.DB  0x35,0x2B,0x21,0x16,0xB,0x0,0x0,0xB
	.DB  0x16,0x21,0x2D,0x37,0x41,0x4B,0x53,0x5C
	.DB  0x62,0x69,0x6F,0x73,0x76,0x79,0x79,0x79
	.DB  0x79,0x76,0x73,0x6F,0x69,0x62,0x5C,0x53
	.DB  0x4B,0x41,0x37,0x2D,0x21,0x16,0xB,0x0
	.DB  0x0,0xB,0x16,0x21,0x2D,0x38,0x42,0x4C
	.DB  0x55,0x5C,0x64,0x6A,0x70,0x74,0x78,0x79
	.DB  0x7A,0x7A,0x79,0x78,0x74,0x70,0x6A,0x64
	.DB  0x5C,0x55,0x4C,0x42,0x38,0x2D,0x21,0x16
	.DB  0xB,0x0,0x0,0xB,0x16,0x23,0x2E,0x38
	.DB  0x43,0x4C,0x56,0x5D,0x65,0x6B,0x70,0x75
	.DB  0x79,0x7A,0x7B,0x7B,0x7A,0x79,0x75,0x70
	.DB  0x6B,0x65,0x5D,0x56,0x4C,0x43,0x38,0x2E
	.DB  0x23,0x16,0xB,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0xFF,0x0,0xFF
	.DB  0x0,0xFF,0x0,0x0

_0x6:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x2C,0x16,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x03
>>>>>>> origin/master
	.DW  __REG_VARS*2

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
	.ORG 0x200

	.CSEG
<<<<<<< HEAD
=======
;//початок Налаштування
;#define DEAD_TIME_HALF      2   //Мертвий час (1 = 0.26 мкс)
;#define ACCELERATION        40  //Прискорення  (Гц/сек)
;#define NORM_VOLTAGE        512 // Нормальне значення робочої напруги в одиницях АЦП (Макс:1023)
;#define MAX_BRAKE_VOLTAGE   562 // Максимальне допустипе значення напруги при гальмуванні в одиницях АЦП (Макс:1023)
;#define CRYTYCAL_VOLTAGE    594 // Критичне значення напруги в одиницях АЦП (Макс:1023)
;#define BRAKE_PERIOD        2 // Період гальмування двигуна (1/2 сек)
;#define NORM_TEMP_DRIVER    200 // Нормальне значення температури драйвера в одиницях АЦП (Макс:1023)
;#define MAX_TEMP_DRIVER     300 // Максимальне допустипе значення температури драйвера в одиницях АЦП (Макс:1023)
;
;
;//Кінець налаштувань
;
;
;#define SINE_TABLE_LENGTH   66 // Кількість значень в таблиці синусів
;#define HALF_ST_LENGTH      33 // Кількість значень в таблиці синусів для напівперіода
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
;
>>>>>>> origin/master
;#include <mega48.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
<<<<<<< HEAD
;
;// Declare your global variables here
; char d=0;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0007 {

	.CSEG
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R30
	IN   R30,SREG
; 0000 0008 // Place your code here
; 0000 0009  d++;
	INC  R4
; 0000 000A }
=======
;#include <md.h>
;#include <delay.h>
;
;// Declare your global variables here
;volatile int out_cnt=0; // Лічильник імпульсів зовнішнього генератора
;char p1l=0xFF,p1h=0x00,p2l=0xFF,p2h=0x00,p3l=0xFF,p3h=0x00; //Буфер для значень PWM
;char sys_timer_cnt=0;// Лічильник системного таймера
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0039 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003A     out_cnt++;
	LDI  R26,LOW(_out_cnt)
	LDI  R27,HIGH(_out_cnt)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 003B }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 003F {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
; 0000 0040     OCR0A=p1h;
	OUT  0x27,R3
; 0000 0041     OCR0B=p1l;
	OUT  0x28,R4
; 0000 0042     OCR1AL=p2h;
	STS  136,R5
; 0000 0043     OCR1BL=p2l;
	STS  138,R6
; 0000 0044     OCR2A=p3h;
	STS  179,R7
; 0000 0045     OCR2B=p3l;
	STS  180,R8
; 0000 0046     sys_timer_cnt++;
	INC  R10
; 0000 0047 }
>>>>>>> origin/master
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
<<<<<<< HEAD
;interrupt [WDT] void wdt_timeout_isr(void)
; 0000 000C {
_wdt_timeout_isr:
; .FSTART _wdt_timeout_isr
; 0000 000D // Place your code here
; 0000 000E   PORTC.2=!PORTC.2;
	SBIS 0x8,2
	RJMP _0x3
	CBI  0x8,2
	RJMP _0x4
_0x3:
	SBI  0x8,2
_0x4:
; 0000 000F }
	RETI
; .FEND
;void main(void)
; 0000 0011 {
_main:
; .FSTART _main
; 0000 0012 // Declare your local variables here
; 0000 0013 
; 0000 0014 // Crystal Oscillator division factor: 1
; 0000 0015 #pragma optsize-
; 0000 0016 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0017 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0018 #ifdef _OPTIMIZE_SIZE_
; 0000 0019 #pragma optsize+
; 0000 001A #endif
; 0000 001B 
; 0000 001C // Input/Output Ports initialization
; 0000 001D // Port B initialization
; 0000 001E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In
; 0000 001F DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(6)
	OUT  0x4,R30
; 0000 0020 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T
; 0000 0021 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 0022 
; 0000 0023 // Port C initialization
; 0000 0024 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0025 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(4)
	OUT  0x7,R30
; 0000 0026 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0027 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0028 
; 0000 0029 // Port D initialization
; 0000 002A // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 002B DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0xA,R30
; 0000 002C // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 002D PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0xB,R30
; 0000 002E 
; 0000 002F // Timer/Counter 0 initialization
; 0000 0030 // Clock source: System Clock
; 0000 0031 // Clock value: Timer 0 Stopped
; 0000 0032 // Mode: Normal top=0xFF
; 0000 0033 // OC0A output: Disconnected
; 0000 0034 // OC0B output: Disconnected
; 0000 0035 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 0036 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 0037 TCNT0=0x00;
	OUT  0x26,R30
; 0000 0038 OCR0A=0x00;
	OUT  0x27,R30
; 0000 0039 OCR0B=0x00;
	OUT  0x28,R30
; 0000 003A 
; 0000 003B // Timer/Counter 1 initialization
; 0000 003C // Clock source: System Clock
; 0000 003D // Clock value: 8000,000 kHz
; 0000 003E // Mode: Ph. correct PWM top=0x00FF
; 0000 003F // OC1A output: Non-Inverted PWM
; 0000 0040 // OC1B output: Inverted PWM
; 0000 0041 // Noise Canceler: Off
; 0000 0042 // Input Capture on Falling Edge
; 0000 0043 // Timer Period: 0,06375 ms
; 0000 0044 // Output Pulse(s):
; 0000 0045 // OC1A Period: 0,06375 ms Width: 3,75 us
; 0000 0046 // OC1B Period: 0,06375 ms Width: 0,06375 ms
; 0000 0047 // Timer1 Overflow Interrupt: Off
; 0000 0048 // Input Capture Interrupt: Off
; 0000 0049 // Compare A Match Interrupt: On
; 0000 004A // Compare B Match Interrupt: Off
; 0000 004B TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(177)
	STS  128,R30
; 0000 004C TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 004D TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 004E TCNT1L=0x00;
	STS  132,R30
; 0000 004F ICR1H=0x00;
	STS  135,R30
; 0000 0050 ICR1L=0x00;
	STS  134,R30
; 0000 0051 OCR1AH=0x00;
	STS  137,R30
; 0000 0052 OCR1AL=100;
	LDI  R30,LOW(100)
	STS  136,R30
; 0000 0053 OCR1BH=0x00;
	LDI  R30,LOW(0)
	STS  139,R30
; 0000 0054 OCR1BL=150;
	LDI  R30,LOW(150)
	STS  138,R30
; 0000 0055 
; 0000 0056 // Timer/Counter 2 initialization
; 0000 0057 // Clock source: System Clock
; 0000 0058 // Clock value: 8000,000 kHz
; 0000 0059 // Mode: Phase correct PWM top=0xFF
; 0000 005A // OC2A output: Non-Inverted PWM
; 0000 005B // OC2B output: Inverted PWM
; 0000 005C // Timer Period: 0,06375 ms
; 0000 005D // Output Pulse(s):
; 0000 005E // OC2A Period: 0,06375 ms Width: 0 us
; 0000 005F // OC2B Period: 0,06375 ms Width: 0,06375 ms
; 0000 0060 ASSR=(0<<EXCLK) | (0<<AS2);
	LDI  R30,LOW(0)
	STS  182,R30
; 0000 0061 TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (0<<WGM21) | (1<<WGM20);
	LDI  R30,LOW(177)
	STS  176,R30
; 0000 0062 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(1)
	STS  177,R30
; 0000 0063 TCNT2=0x00;
	LDI  R30,LOW(0)
	STS  178,R30
; 0000 0064 OCR2A=0x00;
	STS  179,R30
; 0000 0065 OCR2B=0x00;
	STS  180,R30
; 0000 0066 
; 0000 0067 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0068 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 0069 
; 0000 006A // Timer/Counter 1 Interrupt(s) initialization
; 0000 006B TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (1<<OCIE1A) | (0<<TOIE1);
	LDI  R30,LOW(2)
	STS  111,R30
; 0000 006C 
; 0000 006D // Timer/Counter 2 Interrupt(s) initialization
; 0000 006E TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	LDI  R30,LOW(0)
	STS  112,R30
; 0000 006F 
; 0000 0070 // External Interrupt(s) initialization
; 0000 0071 // INT0: Off
; 0000 0072 // INT1: Off
; 0000 0073 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0074 // Interrupt on any change on pins PCINT8-14: Off
; 0000 0075 // Interrupt on any change on pins PCINT16-23: Off
; 0000 0076 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 0077 EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 0078 PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 0079 
; 0000 007A // USART initialization
; 0000 007B // USART disabled
; 0000 007C UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 007D 
; 0000 007E // Analog Comparator initialization
; 0000 007F // Analog Comparator: Off
; 0000 0080 // The Analog Comparator's positive input is
; 0000 0081 // connected to the AIN0 pin
; 0000 0082 // The Analog Comparator's negative input is
; 0000 0083 // connected to the AIN1 pin
; 0000 0084 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0085 ADCSRB=(0<<ACME);
=======
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 004E {
; 0000 004F ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 0050 // Delay needed for the stabilization of the ADC input voltage
; 0000 0051 delay_us(10);
; 0000 0052 // Start the AD conversion
; 0000 0053 ADCSRA|=(1<<ADSC);
; 0000 0054 // Wait for the AD conversion to complete
; 0000 0055 while ((ADCSRA & (1<<ADIF))==0);
; 0000 0056 ADCSRA|=(1<<ADIF);
; 0000 0057 return ADCW;
; 0000 0058 }
;
;void main(void)
; 0000 005B {
_main:
; .FSTART _main
; 0000 005C volatile char tmp=0,tmpsin=0,tmptabpos=0,tmptabpos2=0;// Cлужбові
; 0000 005D volatile char mode=0; //Режим роботи пристрою (0-стоп, 1-Робота, 2-Гальмування)
; 0000 005E bit direct=0; // Напрям руху (0-вперед, 1-назад)
; 0000 005F volatile int cur_period=0; // Поточний період для синусоїди
; 0000 0060 volatile char sinU=0,sinV=22,sinW=44; // Початкові значення здвигу по таблиці синусів
; 0000 0061 volatile signed char h_sin[SINE_TABLE_LENGTH],l_sin[SINE_TABLE_LENGTH]; // Поточна таблиця синусів
; 0000 0062 volatile char cur_freq=0;// діюча частота двигуна
; 0000 0063 volatile char freq=0;// встановлена частота двигуна
; 0000 0064 volatile char calc_sine_cnt=0;// Кількість прорахованих значень синуса
; 0000 0065 volatile char amp_freq=0;// Частота для виборуамплітуди
; 0000 0066 char accel_cnt=0;// Лічильник прискорення
; 0000 0067 char brake_cnt=0;// Лічильник гальмування
; 0000 0068 char error_led_cnt=0; // Лічильник індикації помилки
; 0000 0069 char error_led_period=0; // Період індикації помилки
; 0000 006A char error=0; // Помилка
; 0000 006B char slow_timer_cnt=0; // таймер для не критичних процесів
; 0000 006C #pragma optsize-
; 0000 006D CLKPR=(1<<CLKPCE);
	SBIW R28,63
	SBIW R28,63
	SBIW R28,20
	LDI  R24,146
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x6*2)
	LDI  R31,HIGH(_0x6*2)
	RCALL __INITLOCB
;	tmp -> Y+145
;	tmpsin -> Y+144
;	tmptabpos -> Y+143
;	tmptabpos2 -> Y+142
;	mode -> Y+141
;	direct -> R15.0
;	cur_period -> Y+139
;	sinU -> Y+138
;	sinV -> Y+137
;	sinW -> Y+136
;	h_sin -> Y+70
;	l_sin -> Y+4
;	cur_freq -> Y+3
;	freq -> Y+2
;	calc_sine_cnt -> Y+1
;	amp_freq -> Y+0
;	accel_cnt -> R17
;	brake_cnt -> R16
;	error_led_cnt -> R19
;	error_led_period -> R18
;	error -> R21
;	slow_timer_cnt -> R20
	CLR  R15
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDI  R20,0
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 006E CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 006F #ifdef _OPTIMIZE_SIZE_
; 0000 0070 #pragma optsize+
; 0000 0071 #endif
; 0000 0072 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(14)
	OUT  0x4,R30
; 0000 0073 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 0074 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(6)
	OUT  0x7,R30
; 0000 0075 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0076 DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(104)
	OUT  0xA,R30
; 0000 0077 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0078 TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (1<<COM0B1) | (1<<COM0B0) | (0<<WGM01) | (1<<WGM00);
	LDI  R30,LOW(177)
	OUT  0x24,R30
; 0000 0079 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 007A TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 007B OCR0A=0x00;
	OUT  0x27,R30
; 0000 007C OCR0B=0x00;
	OUT  0x28,R30
; 0000 007D TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(177)
	STS  128,R30
; 0000 007E TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 007F TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 0080 TCNT1L=0x00;
	STS  132,R30
; 0000 0081 ICR1H=0x00;
	STS  135,R30
; 0000 0082 ICR1L=0x00;
	STS  134,R30
; 0000 0083 OCR1AH=0x00;
	STS  137,R30
; 0000 0084 OCR1AL=0x00;
	STS  136,R30
; 0000 0085 OCR1BH=0x00;
	STS  139,R30
; 0000 0086 OCR1BL=0x00;
	STS  138,R30
; 0000 0087 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0088 TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (0<<WGM21) | (1<<WGM20);
	LDI  R30,LOW(177)
	STS  176,R30
; 0000 0089 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(1)
	STS  177,R30
; 0000 008A TCNT2=0x00;
	LDI  R30,LOW(0)
	STS  178,R30
; 0000 008B OCR2A=0x00;
	STS  179,R30
; 0000 008C OCR2B=0x00;
	STS  180,R30
; 0000 008D TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 008E TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 008F TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 0090 EICRA=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(2)
	STS  105,R30
; 0000 0091 EIMSK=(0<<INT1) | (1<<INT0);
	LDI  R30,LOW(1)
	OUT  0x1D,R30
; 0000 0092 EIFR=(0<<INTF1) | (1<<INTF0);
	OUT  0x1C,R30
; 0000 0093 PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	LDI  R30,LOW(0)
	STS  104,R30
; 0000 0094 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 0095 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0096 DIDR1=(0<<AIN0D) | (0<<AIN1D);
>>>>>>> origin/master
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0086 // Digital input buffer on AIN0: On
; 0000 0087 // Digital input buffer on AIN1: On
; 0000 0088 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
<<<<<<< HEAD
; 0000 0089 
; 0000 008A // ADC initialization
; 0000 008B // ADC disabled
; 0000 008C ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 008D 
; 0000 008E // SPI initialization
; 0000 008F // SPI disabled
; 0000 0090 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 0091 
; 0000 0092 // TWI initialization
; 0000 0093 // TWI disabled
; 0000 0094 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 0095 
; 0000 0096 // Watchdog Timer initialization
; 0000 0097 // Watchdog Timer Prescaler: OSC/2k
; 0000 0098 // Watchdog timeout action: Interrupt
; 0000 0099 #pragma optsize-
; 0000 009A WDTCSR=(0<<WDIF) | (0<<WDIE) | (0<<WDP3) | (1<<WDCE) | (0<<WDE) | (0<<WDP2) | (0<<WDP1) | (0<<WDP0);
	LDI  R30,LOW(16)
	STS  96,R30
; 0000 009B WDTCSR=(1<<WDIF) | (1<<WDIE) | (0<<WDP3) | (0<<WDCE) | (0<<WDE) | (0<<WDP2) | (0<<WDP1) | (0<<WDP0);
	LDI  R30,LOW(192)
	STS  96,R30
; 0000 009C #ifdef _OPTIMIZE_SIZE_
; 0000 009D #pragma optsize+
; 0000 009E #endif
; 0000 009F 
; 0000 00A0 // Global enable interrupts
; 0000 00A1 #asm("sei")
	sei
; 0000 00A2 
; 0000 00A3 while (1)
_0x5:
; 0000 00A4       {
; 0000 00A5       // Place your code here
; 0000 00A6 
; 0000 00A7       }
	RJMP _0x5
; 0000 00A8 }
_0x8:
	RJMP _0x8
; .FEND

	.CSEG

	.CSEG
=======
; 0000 0097 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 0098 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 0099 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	STS  122,R30
; 0000 009A ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 009B SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 009C TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 009D 
; 0000 009E for (tmp=0;tmp<SINE_TABLE_LENGTH;tmp++)
	__PUTB1SX 145
_0x8:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x42)
	BRSH _0x9
; 0000 009F  {
; 0000 00A0     if (tmp<HALF_ST_LENGTH)
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x21)
	BRSH _0xA
; 0000 00A1     {
; 0000 00A2 
; 0000 00A3         tmpsin=127+sineTable[0][tmptabpos];
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00A4         tmptabpos++;
	RJMP _0x3E
; 0000 00A5     }
; 0000 00A6     else
_0xA:
; 0000 00A7     {
; 0000 00A8        tmpsin=127-sineTable[0][tmptabpos2];
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
; 0000 00A9        tmptabpos2++;
_0x3E:
	LD   R30,X
	RCALL SUBOPT_0x6
; 0000 00AA     }
; 0000 00AB 
; 0000 00AC     if (tmpsin <= DEAD_TIME_HALF)
	RCALL SUBOPT_0x7
	CPI  R26,LOW(0x3)
	BRSH _0xC
; 0000 00AD     {
; 0000 00AE         h_sin[tmp] = 0x00;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00AF         l_sin[tmp] = tmpsin;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x7
	STD  Z+0,R26
; 0000 00B0     }
; 0000 00B1     else if (tmpsin >= (0xff - DEAD_TIME_HALF))
	RJMP _0xD
_0xC:
	RCALL SUBOPT_0x7
	CPI  R26,LOW(0xFD)
	BRLO _0xE
; 0000 00B2     {
; 0000 00B3         h_sin[tmp] = 0xff - (2 * DEAD_TIME_HALF);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	LDI  R30,LOW(251)
	ST   X,R30
; 0000 00B4         l_sin[tmp] = 0xff;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xC
	LDI  R30,LOW(255)
	RJMP _0x3F
; 0000 00B5     }
; 0000 00B6     else
_0xE:
; 0000 00B7     {
; 0000 00B8         h_sin[tmp] = tmpsin - DEAD_TIME_HALF;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xD
	SUBI R30,LOW(2)
	ST   X,R30
; 0000 00B9         l_sin[tmp] = tmpsin + DEAD_TIME_HALF;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	SUBI R30,-LOW(2)
_0x3F:
	ST   X,R30
; 0000 00BA     }
_0xD:
; 0000 00BB  }
	MOVW R26,R28
	SUBI R26,LOW(-(145))
	SBCI R27,HIGH(-(145))
	RCALL SUBOPT_0xE
	RJMP _0x8
_0x9:
; 0000 00BC  tmptabpos2=0;
	RCALL SUBOPT_0xF
; 0000 00BD  tmptabpos=0;
	RCALL SUBOPT_0x10
; 0000 00BE cur_period=period_table[1];
	__POINTW1FN _period_table,2
	RCALL SUBOPT_0x11
; 0000 00BF mode=1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x12
; 0000 00C0 freq=60;
	LDI  R30,LOW(60)
	STD  Y+2,R30
; 0000 00C1 // Global enable interrupts
; 0000 00C2 #asm("sei")
	sei
; 0000 00C3 
; 0000 00C4 while (1)
_0x10:
; 0000 00C5 {
; 0000 00C6     tmpsin=3;
	LDI  R30,LOW(3)
	__PUTB1SX 144
; 0000 00C7     if (out_cnt>cur_period)
	__GETW1SX 139
	LDS  R26,_out_cnt
	LDS  R27,_out_cnt+1
	CP   R30,R26
	CPC  R31,R27
	BRLT PC+2
	RJMP _0x13
; 0000 00C8     {
; 0000 00C9         out_cnt=0;
	LDI  R30,LOW(0)
	STS  _out_cnt,R30
	STS  _out_cnt+1,R30
; 0000 00CA         if (mode>0 )
	RCALL SUBOPT_0x13
	BRSH PC+2
	RJMP _0x14
; 0000 00CB         {
; 0000 00CC             sinU++;
	MOVW R26,R28
	SUBI R26,LOW(-(138))
	SBCI R27,HIGH(-(138))
	RCALL SUBOPT_0xE
; 0000 00CD             sinV++;
	MOVW R26,R28
	SUBI R26,LOW(-(137))
	SBCI R27,HIGH(-(137))
	RCALL SUBOPT_0xE
; 0000 00CE             sinW++;
	MOVW R26,R28
	SUBI R26,LOW(-(136))
	SBCI R27,HIGH(-(136))
	RCALL SUBOPT_0xE
; 0000 00CF             if (sinU==SINE_TABLE_LENGTH) sinU=0;
	RCALL SUBOPT_0x14
	CPI  R26,LOW(0x42)
	BRNE _0x15
	LDI  R30,LOW(0)
	__PUTB1SX 138
; 0000 00D0             if (sinV==SINE_TABLE_LENGTH) sinV=0;
_0x15:
	__GETB2SX 137
	CPI  R26,LOW(0x42)
	BRNE _0x16
	LDI  R30,LOW(0)
	__PUTB1SX 137
; 0000 00D1             if (sinW==SINE_TABLE_LENGTH) sinW=0;
_0x16:
	__GETB2SX 136
	CPI  R26,LOW(0x42)
	BRNE _0x17
	LDI  R30,LOW(0)
	__PUTB1SX 136
; 0000 00D2             p1h = h_sin[sinU];
_0x17:
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x9
	LD   R3,X
; 0000 00D3             p1l = l_sin[sinU];
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xC
	LD   R4,X
; 0000 00D4             if (direct == DIRECTION_FORWARD)
	SBRC R15,0
	RJMP _0x18
; 0000 00D5             {
; 0000 00D6                 p2h = h_sin[sinW];
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x9
	LD   R5,X
; 0000 00D7                 p2l = l_sin[sinW];
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0xC
	LD   R6,X
; 0000 00D8                 p3h = h_sin[sinV];
	RCALL SUBOPT_0x17
	LDI  R31,0
	RCALL SUBOPT_0x9
	LD   R7,X
; 0000 00D9                 p3l = l_sin[sinV];
	RCALL SUBOPT_0x17
	RJMP _0x40
; 0000 00DA             }
; 0000 00DB             else
_0x18:
; 0000 00DC             {
; 0000 00DD                 p2h = h_sin[sinV];
	RCALL SUBOPT_0x17
	LDI  R31,0
	RCALL SUBOPT_0x9
	LD   R5,X
; 0000 00DE                 p2l = l_sin[sinV];
	RCALL SUBOPT_0x17
	LDI  R31,0
	RCALL SUBOPT_0xC
	LD   R6,X
; 0000 00DF                 p3h = h_sin[sinW];
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x9
	LD   R7,X
; 0000 00E0                 p3l = l_sin[sinW];
	__GETB1SX 136
_0x40:
	LDI  R31,0
	RCALL SUBOPT_0xC
	LD   R8,X
; 0000 00E1             }
; 0000 00E2             NORMAL_LED=!NORMAL_LED;
	SBIS 0x8,1
	RJMP _0x1A
	CBI  0x8,1
	RJMP _0x1B
_0x1A:
	SBI  0x8,1
_0x1B:
; 0000 00E3             NORMAL_LED=!NORMAL_LED;
	SBIS 0x8,1
	RJMP _0x1C
	CBI  0x8,1
	RJMP _0x1D
_0x1C:
	SBI  0x8,1
_0x1D:
; 0000 00E4         }
; 0000 00E5         else
	RJMP _0x1E
_0x14:
; 0000 00E6         {
; 0000 00E7             p1l=0xFF; p1h=0x00; p2l=0xFF; p2h=0x00; p3l=0xFF; p3h=0x00;
	LDI  R30,LOW(255)
	MOV  R4,R30
	CLR  R3
	MOV  R6,R30
	CLR  R5
	MOV  R8,R30
	CLR  R7
; 0000 00E8         }
_0x1E:
; 0000 00E9         if (calc_sine_cnt<=SINE_TABLE_LENGTH)
	LDD  R26,Y+1
	CPI  R26,LOW(0x43)
	BRLO PC+2
	RJMP _0x1F
; 0000 00EA         {
; 0000 00EB             amp_freq=cur_freq-1;
	LDD  R30,Y+3
	SUBI R30,LOW(1)
	ST   Y,R30
; 0000 00EC             if (amp_freq>49) amp_freq=49;
	LD   R26,Y
	CPI  R26,LOW(0x32)
	BRLO _0x20
	LDI  R30,LOW(49)
	ST   Y,R30
; 0000 00ED             calc_sine_cnt++;
_0x20:
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
; 0000 00EE             if (sinU<HALF_ST_LENGTH)
	RCALL SUBOPT_0x14
	CPI  R26,LOW(0x21)
	BRSH _0x21
; 0000 00EF             {
; 0000 00F0 
; 0000 00F1                 tmpsin=127+sineTable[amp_freq][tmptabpos];
	RCALL SUBOPT_0x18
	MOVW R26,R30
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x3
; 0000 00F2                 tmptabpos++;
	RCALL SUBOPT_0xE
; 0000 00F3                 tmptabpos2=0;
	RCALL SUBOPT_0xF
; 0000 00F4             }
; 0000 00F5             else
	RJMP _0x22
_0x21:
; 0000 00F6             {
; 0000 00F7                tmpsin=127-sineTable[amp_freq][tmptabpos2];
	RCALL SUBOPT_0x18
	MOVW R26,R30
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x5
; 0000 00F8                tmptabpos2++;
	RCALL SUBOPT_0xE
; 0000 00F9                tmptabpos=0;
	RCALL SUBOPT_0x10
; 0000 00FA             }
_0x22:
; 0000 00FB 
; 0000 00FC             if (tmpsin <= DEAD_TIME_HALF)
	RCALL SUBOPT_0x7
	CPI  R26,LOW(0x3)
	BRSH _0x23
; 0000 00FD             {
; 0000 00FE                 h_sin[sinU] = 0x00;
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x9
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00FF                 l_sin[sinU] = tmpsin;
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x7
	STD  Z+0,R26
; 0000 0100             }
; 0000 0101             else if (tmpsin >= (0xff - DEAD_TIME_HALF))
	RJMP _0x24
_0x23:
	RCALL SUBOPT_0x7
	CPI  R26,LOW(0xFD)
	BRLO _0x25
; 0000 0102             {
; 0000 0103                 h_sin[sinU] = 0xff - (2 * DEAD_TIME_HALF);
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x9
	LDI  R30,LOW(251)
	ST   X,R30
; 0000 0104                 l_sin[sinU] = 0xff;
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xC
	LDI  R30,LOW(255)
	RJMP _0x41
; 0000 0105             }
; 0000 0106             else
_0x25:
; 0000 0107             {
; 0000 0108                 h_sin[sinU] = tmpsin - DEAD_TIME_HALF;
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xD
	SUBI R30,LOW(2)
	ST   X,R30
; 0000 0109                 l_sin[sinU] = tmpsin + DEAD_TIME_HALF;
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	SUBI R30,-LOW(2)
_0x41:
	ST   X,R30
; 0000 010A             }
_0x24:
; 0000 010B         }
; 0000 010C 
; 0000 010D     }
_0x1F:
; 0000 010E     else
	RJMP _0x27
_0x13:
; 0000 010F     {
; 0000 0110         if (sys_timer_cnt>138)
	LDI  R30,LOW(138)
	CP   R30,R10
	BRLO PC+2
	RJMP _0x28
; 0000 0111         {
; 0000 0112             sys_timer_cnt=0;
	CLR  R10
; 0000 0113             if (mode>0)
	RCALL SUBOPT_0x13
	BRLO _0x29
; 0000 0114             {
; 0000 0115                 if(cur_freq<freq || cur_freq>freq)
	LDD  R30,Y+2
	LDD  R26,Y+3
	CP   R26,R30
	BRLO _0x2B
	CP   R30,R26
	BRSH _0x2A
_0x2B:
; 0000 0116                 {
; 0000 0117                     accel_cnt=accel_cnt+ACCELERATION;
	SUBI R17,-LOW(40)
; 0000 0118                     if (accel_cnt>99)
	CPI  R17,100
	BRLO _0x2D
; 0000 0119                     {
; 0000 011A                         accel_cnt=0;
	LDI  R17,LOW(0)
; 0000 011B                         if (cur_freq<freq) {cur_freq++;} else {cur_freq--;}
	LDD  R30,Y+2
	LDD  R26,Y+3
	CP   R26,R30
	BRSH _0x2E
	LDD  R30,Y+3
	SUBI R30,-LOW(1)
	RJMP _0x42
_0x2E:
	LDD  R30,Y+3
	SUBI R30,LOW(1)
_0x42:
	STD  Y+3,R30
; 0000 011C                         cur_period=period_table[cur_freq];
	LDI  R26,LOW(_period_table*2)
	LDI  R27,HIGH(_period_table*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x11
; 0000 011D                         if (cur_freq<51) calc_sine_cnt=0;
	LDD  R26,Y+3
	CPI  R26,LOW(0x33)
	BRSH _0x30
	LDI  R30,LOW(0)
	STD  Y+1,R30
; 0000 011E                     }
_0x30:
; 0000 011F                 }
_0x2D:
; 0000 0120             }
_0x2A:
; 0000 0121             else
	RJMP _0x31
_0x29:
; 0000 0122             {
; 0000 0123                 if (error>0)
	CPI  R21,1
	BRLO _0x32
; 0000 0124                 {
; 0000 0125                      error_led_cnt++;
	SUBI R19,-1
; 0000 0126                      if (error_led_cnt>error_led_period)
	CP   R18,R19
	BRSH _0x33
; 0000 0127                      {
; 0000 0128                         //ERROR_LED=!ERROR_LED;
; 0000 0129                         error_led_cnt=0;
	LDI  R19,LOW(0)
; 0000 012A                      }
; 0000 012B                 }
_0x33:
; 0000 012C                 else
_0x32:
; 0000 012D                 {
; 0000 012E                     //if(REVERSE_BUT==0) {mode=MODE_RUN;direct=DIRECTION_REVERSE;}
; 0000 012F                     //if(FORWARD_BUT==0) {mode=MODE_RUN;direct=DIRECTION_FORWARD;}
; 0000 0130                     //  NORMAL_LED=1;
; 0000 0131                 }
; 0000 0132             }
_0x31:
; 0000 0133             if(STOP_BUT==0)
; 0000 0134             {
; 0000 0135                 if (mode==MODE_STOP)
; 0000 0136                 {
; 0000 0137                     //overload_state=0;
; 0000 0138                     //crytycal_voltage=0;
; 0000 0139                 }
; 0000 013A                 else
; 0000 013B                 {
; 0000 013C                    // mode=MODE_BRAKE;
; 0000 013D                 }
; 0000 013E             }
; 0000 013F             slow_timer_cnt++;
	SUBI R20,-1
; 0000 0140             if (slow_timer_cnt==50)
	CPI  R20,50
	BRNE _0x38
; 0000 0141             {
; 0000 0142                 slow_timer_cnt=0;
	LDI  R20,LOW(0)
; 0000 0143                 if (mode==MODE_BRAKE)
	__GETB2SX 141
	CPI  R26,LOW(0x2)
	BRNE _0x39
; 0000 0144                 {
; 0000 0145                     freq=1;
	LDI  R30,LOW(1)
	STD  Y+2,R30
; 0000 0146                     if (cur_freq==1)  brake_cnt++;
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x3A
	SUBI R16,-1
; 0000 0147 
; 0000 0148                     if (brake_cnt>BRAKE_PERIOD) {brake_cnt=0;mode=MODE_STOP;}
_0x3A:
	CPI  R16,3
	BRLO _0x3B
	LDI  R16,LOW(0)
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x12
; 0000 0149                 }
_0x3B:
; 0000 014A                 else
_0x39:
; 0000 014B                 {
; 0000 014C                    // freq=read_adc(FREQUENCY_ADC)/17+1;
; 0000 014D                 }
; 0000 014E             }
; 0000 014F         }
_0x38:
; 0000 0150     }
_0x28:
_0x27:
; 0000 0151 }
	RJMP _0x10
; 0000 0152 }
_0x3D:
	RJMP _0x3D
; .FEND

	.DSEG
_out_cnt:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	__GETB2SX 145
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	__GETB1SX 143
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	SUBI R30,LOW(-_sineTable*2)
	SBCI R31,HIGH(-_sineTable*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LPM  R30,Z
	SUBI R30,-LOW(127)
	__PUTB1SX 144
	MOVW R26,R28
	SUBI R26,LOW(-(143))
	SBCI R27,HIGH(-(143))
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	__GETB1SX 142
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LPM  R26,Z
	LDI  R30,LOW(127)
	SUB  R30,R26
	__PUTB1SX 144
	MOVW R26,R28
	SUBI R26,LOW(-(142))
	SBCI R27,HIGH(-(142))
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	SUBI R30,-LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	__GETB2SX 144
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x8:
	__GETB1SX 145
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x9:
	MOVW R26,R28
	SUBI R26,LOW(-(70))
	SBCI R27,HIGH(-(70))
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	MOVW R26,R28
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0xA
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	__GETB1SX 144
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LD   R30,X
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	__PUTB1SX 142
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	__PUTB1SX 143
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	RCALL __GETW1PF
	__PUTW1SX 139
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__PUTB1SX 141
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	__GETB2SX 141
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	__GETB2SX 138
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x15:
	__GETB1SX 138
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	__GETB1SX 136
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	__GETB1SX 137
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	LD   R30,Y
	LDI  R26,LOW(34)
	MUL  R30,R26
	MOVW R30,R0
	RJMP SUBOPT_0x2


	.CSEG
__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

>>>>>>> origin/master
;END OF CODE MARKER
__END_OF_CODE:
