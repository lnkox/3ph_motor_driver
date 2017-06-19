
;CodeVisionAVR C Compiler V3.10 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega48
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 168 byte(s)
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
	.EQU __DSTACK_SIZE=0x00A8
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
	.DEF _mode=R3
	.DEF _mode_msb=R4
	.DEF _direct=R5
	.DEF _direct_msb=R6
	.DEF _sinseg_period=R7
	.DEF _sinseg_period_msb=R8
	.DEF _sinseg=R9
	.DEF _sinseg_msb=R10
	.DEF _sys_timer_cnt=R11
	.DEF _sys_timer_cnt_msb=R12
	.DEF _accel_cnt=R13
	.DEF _accel_cnt_msb=R14

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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x7C,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x9A,0x99,0x99,0x3E
_0x4:
	.DB  0x2A
_0x5:
	.DB  0x55

__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  _amplitude
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
	.ORG 0x1A8

	.CSEG
;
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
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
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
;void calculate_sintable(char nsp); //Розрахунок наступного значення синусоїди
;// Declare your global variables here
; int mode=0;
; int direct=0;
; float amplitude=0.3;

	.DSEG
; int sinseg_period=124,sinseg=0;
; int sys_timer_cnt=0;
; int accel_cnt=0;
; int cur_freq=0,freq=0;
; int error_led_cnt=0,error_led_period=0,error=0;
; int overload_state=0,overvoltage_state=0,crytycal_voltage=0;
; int brake_cnt=0;
; char sinU=0,sinV=42,sinW=85;
;signed char h_sin[14],l_sin[14];
; char tmpsin;
;#pragma warn-
;eeprom  int driver_temp_state;
;#pragma warn+
;long map(long x, long in_min, long in_max, long out_min, long out_max)
; 0000 004F {

	.CSEG
; 0000 0050   return ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min);
;	x -> Y+16
;	in_min -> Y+12
;	in_max -> Y+8
;	out_min -> Y+4
;	out_max -> Y+0
; 0000 0051 }
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0053 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0054  sinseg++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
; 0000 0055 
; 0000 0056 
; 0000 0057 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;void gen_next_sinpos(void)
; 0000 0059 {
_gen_next_sinpos:
; .FSTART _gen_next_sinpos
; 0000 005A 
; 0000 005B     sinU++;
	LDS  R30,_sinU
	SUBI R30,-LOW(1)
	STS  _sinU,R30
; 0000 005C     sinV++;
	RCALL SUBOPT_0x0
	SUBI R30,-LOW(1)
	STS  _sinV,R30
; 0000 005D     sinW++;
	RCALL SUBOPT_0x1
	SUBI R30,-LOW(1)
	STS  _sinW,R30
; 0000 005E     if (sinU==128) sinU=0;
	LDS  R26,_sinU
	CPI  R26,LOW(0x80)
	BRNE _0x6
	LDI  R30,LOW(0)
	STS  _sinU,R30
; 0000 005F     if (sinV==128) sinV=0;
_0x6:
	LDS  R26,_sinV
	CPI  R26,LOW(0x80)
	BRNE _0x7
	LDI  R30,LOW(0)
	STS  _sinV,R30
; 0000 0060     if (sinW==128) sinW=0;
_0x7:
	LDS  R26,_sinW
	CPI  R26,LOW(0x80)
	BRNE _0x8
	LDI  R30,LOW(0)
	STS  _sinW,R30
; 0000 0061     OCR0A = h_sin[sinU];
_0x8:
	LDS  R30,_sinU
	RCALL SUBOPT_0x2
	OUT  0x27,R30
; 0000 0062     OCR0B = l_sin[sinU];
	LDS  R30,_sinU
	RCALL SUBOPT_0x3
	OUT  0x28,R30
; 0000 0063     if (direct == DIRECTION_FORWARD)
	MOV  R0,R5
	OR   R0,R6
	BRNE _0x9
; 0000 0064     {
; 0000 0065         OCR1AL = h_sin[sinW];
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
; 0000 0066         OCR1BL = l_sin[sinW];
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x5
; 0000 0067         OCR2A = h_sin[sinV];
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x6
; 0000 0068         OCR2B = l_sin[sinV];
	RCALL SUBOPT_0x0
	RJMP _0x24
; 0000 0069     }
; 0000 006A     else
_0x9:
; 0000 006B     {
; 0000 006C         OCR1AL = h_sin[sinV];
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
; 0000 006D         OCR1BL = l_sin[sinV];
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x5
; 0000 006E         OCR2A = h_sin[sinW];
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x6
; 0000 006F         OCR2B = l_sin[sinW];
	RCALL SUBOPT_0x1
_0x24:
	LDI  R31,0
	SUBI R30,LOW(-_l_sin)
	SBCI R31,HIGH(-_l_sin)
	LD   R30,Z
	STS  180,R30
; 0000 0070     }
; 0000 0071 
; 0000 0072     NORMAL_LED=!NORMAL_LED;
	SBIS 0x8,1
	RJMP _0xB
	CBI  0x8,1
	RJMP _0xC
_0xB:
	SBI  0x8,1
_0xC:
; 0000 0073     NORMAL_LED=!NORMAL_LED;
	SBIS 0x8,1
	RJMP _0xD
	CBI  0x8,1
	RJMP _0xE
_0xD:
	SBI  0x8,1
_0xE:
; 0000 0074 }
	RET
; .FEND
;
;void calculate_sintable(char nsp)
; 0000 0077 {
_calculate_sintable:
; .FSTART _calculate_sintable
; 0000 0078         tmpsin=127+(sineTable[nsp]*amplitude);
	ST   -Y,R26
;	nsp -> Y+0
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_sineTable*2)
	SBCI R31,HIGH(-_sineTable*2)
	LPM  R26,Z
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDS  R30,_amplitude
	LDS  R31,_amplitude+1
	LDS  R22,_amplitude+2
	LDS  R23,_amplitude+3
	RCALL __CWD2
	RCALL __CDF2
	RCALL __MULF12
	__GETD2N 0x42FE0000
	RCALL __ADDF12
	LDI  R26,LOW(_tmpsin)
	LDI  R27,HIGH(_tmpsin)
	RCALL __CFD1U
	ST   X,R30
; 0000 0079     if (tmpsin <= DEAD_TIME_HALF)
	LDS  R26,_tmpsin
	CPI  R26,LOW(0x3)
	BRSH _0xF
; 0000 007A     {
; 0000 007B         h_sin[nsp] = 0x00;
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_h_sin)
	SBCI R31,HIGH(-_h_sin)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 007C         l_sin[nsp] = tmpsin;
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_l_sin)
	SBCI R31,HIGH(-_l_sin)
	LDS  R26,_tmpsin
	STD  Z+0,R26
; 0000 007D     }
; 0000 007E     else if (tmpsin >= (0xff - DEAD_TIME_HALF))
	RJMP _0x10
_0xF:
	LDS  R26,_tmpsin
	CPI  R26,LOW(0xFD)
	BRLO _0x11
; 0000 007F     {
; 0000 0080         h_sin[nsp] = 0xff - (2 * DEAD_TIME_HALF);
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_h_sin)
	SBCI R31,HIGH(-_h_sin)
	LDI  R26,LOW(251)
	STD  Z+0,R26
; 0000 0081         l_sin[nsp] = 0xff;
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_l_sin)
	SBCI R31,HIGH(-_l_sin)
	LDI  R26,LOW(255)
	STD  Z+0,R26
; 0000 0082     }
; 0000 0083     else
	RJMP _0x12
_0x11:
; 0000 0084     {
; 0000 0085         h_sin[nsp] = tmpsin - DEAD_TIME_HALF;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_h_sin)
	SBCI R27,HIGH(-_h_sin)
	LDS  R30,_tmpsin
	SUBI R30,LOW(2)
	ST   X,R30
; 0000 0086         l_sin[nsp] = tmpsin + DEAD_TIME_HALF;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_l_sin)
	SBCI R27,HIGH(-_l_sin)
	LDS  R30,_tmpsin
	SUBI R30,-LOW(2)
	ST   X,R30
; 0000 0087     }
_0x12:
_0x10:
; 0000 0088 }
	ADIW R28,1
	RET
; .FEND
;
;
;void set_freq(int fr)
; 0000 008C {
; 0000 008D    float amp;
; 0000 008E    sinseg_period=62/fr;
;	fr -> Y+4
;	amp -> Y+0
; 0000 008F    amp=map(fr,1,50,30,100);
; 0000 0090    if (amp>100) amp=100;
; 0000 0091    amplitude=amp/100;
; 0000 0092 }
;void off_pwm(void)
; 0000 0094 {
_off_pwm:
; .FSTART _off_pwm
; 0000 0095     OCR0A=0x00;
	RCALL SUBOPT_0x8
; 0000 0096     OCR0B=0xFF;
; 0000 0097     OCR1AL=0x00;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x4
; 0000 0098     OCR1BL=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x5
; 0000 0099     OCR2A=0x00;
	RCALL SUBOPT_0x9
; 0000 009A     OCR2B=0xFF;
; 0000 009B }
	RET
; .FEND
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 009F {
; 0000 00A0     ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 00A1     // Delay needed for the stabilization of the ADC input voltage
; 0000 00A2     delay_us(10);
; 0000 00A3     // Start the AD conversion
; 0000 00A4     ADCSRA|=(1<<ADSC);
; 0000 00A5     // Wait for the AD conversion to complete
; 0000 00A6     while ((ADCSRA & (1<<ADIF))==0);
; 0000 00A7     ADCSRA|=(1<<ADIF);
; 0000 00A8     return ADCW;
; 0000 00A9 }
;
;void main(void)
; 0000 00AC {
_main:
; .FSTART _main
; 0000 00AD // Declare your local variables here
; 0000 00AE char t;
; 0000 00AF // Crystal Oscillator division factor: 1
; 0000 00B0 #pragma optsize-
; 0000 00B1 CLKPR=(1<<CLKPCE);
;	t -> R17
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00B2 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00B3 #ifdef _OPTIMIZE_SIZE_
; 0000 00B4 #pragma optsize+
; 0000 00B5 #endif
; 0000 00B6 
; 0000 00B7 // Input/Output Ports initialization
; 0000 00B8 // Port B initialization
; 0000 00B9 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=In
; 0000 00BA DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x4,R30
; 0000 00BB // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=T
; 0000 00BC PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 00BD 
; 0000 00BE 
; 0000 00BF // Port C initialization
; 0000 00C0 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In
; 0000 00C1 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(6)
	OUT  0x7,R30
; 0000 00C2 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T
; 0000 00C3 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 00C4 
; 0000 00C5 //
; 0000 00C6 // Port D initialization
; 0000 00C7 // Function: Bit7=In Bit6=Out Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 00C8 DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(104)
	OUT  0xA,R30
; 0000 00C9 // State: Bit7=T Bit6=0 Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 00CA PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00CB 
; 0000 00CC // Timer/Counter 0 initialization
; 0000 00CD // Clock source: System Clock
; 0000 00CE // Clock value: 8000,000 kHz
; 0000 00CF // Mode: Phase correct PWM top=0xFF
; 0000 00D0 // OC0A output: Non-Inverted PWM
; 0000 00D1 // OC0B output: Inverted PWM
; 0000 00D2 // Timer Period: 0,06375 ms
; 0000 00D3 // Output Pulse(s):
; 0000 00D4 // OC0A Period: 0,06375 ms Width: 0 us
; 0000 00D5 // OC0B Period: 0,06375 ms Width: 0,06375 ms
; 0000 00D6 TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (1<<COM0B1) | (1<<COM0B0) | (0<<WGM01) | (1<<WGM00);
	LDI  R30,LOW(177)
	OUT  0x24,R30
; 0000 00D7 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 00D8 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00D9 OCR0A=0x00;
	RCALL SUBOPT_0x8
; 0000 00DA OCR0B=0xFF;
; 0000 00DB 
; 0000 00DC // Timer/Counter 1 initialization
; 0000 00DD // Clock source: System Clock
; 0000 00DE // Clock value: 8000,000 kHz
; 0000 00DF // Mode: Ph. correct PWM top=0x00FF
; 0000 00E0 // OC1A output: Non-Inverted PWM
; 0000 00E1 // OC1B output: Inverted PWM
; 0000 00E2 // Noise Canceler: Off
; 0000 00E3 // Input Capture on Falling Edge
; 0000 00E4 // Timer Period: 0,06375 ms
; 0000 00E5 // Output Pulse(s):
; 0000 00E6 // OC1A Period: 0,06375 ms Width: 0 us
; 0000 00E7 // OC1B Period: 0,06375 ms Width: 0,06375 ms
; 0000 00E8 // Timer1 Overflow Interrupt: On
; 0000 00E9 // Input Capture Interrupt: Off
; 0000 00EA // Compare A Match Interrupt: Off
; 0000 00EB // Compare B Match Interrupt: Off
; 0000 00EC TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(177)
	STS  128,R30
; 0000 00ED TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 00EE TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 00EF TCNT1L=0x00;
	STS  132,R30
; 0000 00F0 ICR1H=0x00;
	STS  135,R30
; 0000 00F1 ICR1L=0x00;
	STS  134,R30
; 0000 00F2 OCR1AH=0x00;
	STS  137,R30
; 0000 00F3 OCR1AL=0x00;
	RCALL SUBOPT_0x4
; 0000 00F4 OCR1BH=0x00;
	LDI  R30,LOW(0)
	STS  139,R30
; 0000 00F5 OCR1BL=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x5
; 0000 00F6 
; 0000 00F7 // Timer/Counter 2 initialization
; 0000 00F8 // Clock source: System Clock
; 0000 00F9 // Clock value: 8000,000 kHz
; 0000 00FA // Mode: Phase correct PWM top=0xFF
; 0000 00FB // OC2A output: Non-Inverted PWM
; 0000 00FC // OC2B output: Inverted PWM
; 0000 00FD // Timer Period: 0,06375 ms
; 0000 00FE // Output Pulse(s):
; 0000 00FF // OC2A Period: 0,06375 ms Width: 0 us
; 0000 0100 // OC2B Period: 0,06375 ms Width: 0,06375 ms
; 0000 0101 ASSR=(0<<EXCLK) | (0<<AS2);
	LDI  R30,LOW(0)
	STS  182,R30
; 0000 0102 TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (0<<WGM21) | (1<<WGM20);
	LDI  R30,LOW(177)
	STS  176,R30
; 0000 0103 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(1)
	STS  177,R30
; 0000 0104 TCNT2=0x00;
	LDI  R30,LOW(0)
	STS  178,R30
; 0000 0105 OCR2A=0x00;
	RCALL SUBOPT_0x9
; 0000 0106 OCR2B=0xFF;
; 0000 0107 
; 0000 0108 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0109 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 010A 
; 0000 010B // Timer/Counter 1 Interrupt(s) initialization
; 0000 010C TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 010D 
; 0000 010E // Timer/Counter 2 Interrupt(s) initialization
; 0000 010F TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 0110 
; 0000 0111 // External Interrupt(s) initialization
; 0000 0112 // INT0: Off
; 0000 0113 // INT1: Off
; 0000 0114 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0115 // Interrupt on any change on pins PCINT8-14: Off
; 0000 0116 // Interrupt on any change on pins PCINT16-23: Off
; 0000 0117 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 0118 EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 0119 PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 011A 
; 0000 011B // USART initialization
; 0000 011C // USART disabled
; 0000 011D UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 011E 
; 0000 011F // Analog Comparator initialization
; 0000 0120 // Analog Comparator: Off
; 0000 0121 // The Analog Comparator's positive input is
; 0000 0122 // connected to the AIN0 pin
; 0000 0123 // The Analog Comparator's negative input is
; 0000 0124 // connected to the AIN1 pin
; 0000 0125 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0126 // Digital input buffer on AIN0: On
; 0000 0127 // Digital input buffer on AIN1: On
; 0000 0128 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 0129 
; 0000 012A 
; 0000 012B // ADC initialization
; 0000 012C // ADC Clock frequency: 1000,000 kHz
; 0000 012D // ADC Voltage Reference: AVCC pin
; 0000 012E // ADC Auto Trigger Source: ADC Stopped
; 0000 012F // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 0130 // ADC4: On, ADC5: On
; 0000 0131 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 0132 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 0133 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	STS  122,R30
; 0000 0134 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0135 
; 0000 0136 // SPI initialization
; 0000 0137 // SPI disabled
; 0000 0138 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 0139 
; 0000 013A // TWI initialization
; 0000 013B // TWI disabled
; 0000 013C TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 013D 
; 0000 013E // Global enable interrupts
; 0000 013F TCNT0=0;    //Синхронізація таймерів
	OUT  0x26,R30
; 0000 0140 TCNT1L=2;   //Синхронізація таймерів
	LDI  R30,LOW(2)
	STS  132,R30
; 0000 0141 TCNT2=5;    //Синхронізація таймерів
	LDI  R30,LOW(5)
	STS  178,R30
; 0000 0142 amplitude=0.3;
	__GETD1N 0x3E99999A
	STS  _amplitude,R30
	STS  _amplitude+1,R31
	STS  _amplitude+2,R22
	STS  _amplitude+3,R23
; 0000 0143 for (t=0;t<10;t++)
	LDI  R17,LOW(0)
_0x18:
	CPI  R17,10
	BRSH _0x19
; 0000 0144  {
; 0000 0145     calculate_sintable(t);
	MOV  R26,R17
	RCALL _calculate_sintable
; 0000 0146  }
	SUBI R17,-1
	RJMP _0x18
_0x19:
; 0000 0147 
; 0000 0148 sinseg_period=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	__PUTW1R 7,8
; 0000 0149 mode=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 3,4
; 0000 014A #asm("sei")
	sei
; 0000 014B 
; 0000 014C while (1)
_0x1A:
; 0000 014D       {
; 0000 014E        if (sinseg==0) calculate_sintable(sinU);
	MOV  R0,R9
	OR   R0,R10
	BRNE _0x1D
	LDS  R26,_sinU
	RCALL _calculate_sintable
; 0000 014F 
; 0000 0150     if (sinseg>=sinseg_period)
_0x1D:
	__CPWRR 9,10,7,8
	BRLT _0x1E
; 0000 0151     {
; 0000 0152             sinseg=0;
	CLR  R9
	CLR  R10
; 0000 0153         if (mode>0 && overvoltage_state==0)
	CLR  R0
	CP   R0,R3
	CPC  R0,R4
	BRGE _0x20
	LDS  R26,_overvoltage_state
	LDS  R27,_overvoltage_state+1
	SBIW R26,0
	BREQ _0x21
_0x20:
	RJMP _0x1F
_0x21:
; 0000 0154         {
; 0000 0155             gen_next_sinpos();
	RCALL _gen_next_sinpos
; 0000 0156         }
; 0000 0157         else
	RJMP _0x22
_0x1F:
; 0000 0158         {
; 0000 0159             off_pwm();
	RCALL _off_pwm
; 0000 015A         }
_0x22:
; 0000 015B     }
; 0000 015C 
; 0000 015D       }
_0x1E:
	RJMP _0x1A
; 0000 015E }
_0x23:
	RJMP _0x23
; .FEND

	.DSEG
_amplitude:
	.BYTE 0x4
_overvoltage_state:
	.BYTE 0x2
_sinU:
	.BYTE 0x1
_sinV:
	.BYTE 0x1
_sinW:
	.BYTE 0x1
_h_sin:
	.BYTE 0xE
_l_sin:
	.BYTE 0xE
_tmpsin:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDS  R30,_sinV
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDS  R30,_sinW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
	LDI  R31,0
	SUBI R30,LOW(-_h_sin)
	SBCI R31,HIGH(-_h_sin)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R31,0
	SUBI R30,LOW(-_l_sin)
	SBCI R31,HIGH(-_l_sin)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	STS  136,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	STS  138,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	STS  179,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	OUT  0x27,R30
	LDI  R30,LOW(255)
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x6
	LDI  R30,LOW(255)
	STS  180,R30
	RET


	.CSEG
__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
