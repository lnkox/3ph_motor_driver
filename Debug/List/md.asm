
;CodeVisionAVR C Compiler V3.10 Advanced
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _mode=R4
	.DEF _sinpos=R5
	.DEF _sinpos_msb=R6
	.DEF _direct=R7
	.DEF _direct_msb=R8
	.DEF _sinseg_period=R9
	.DEF _sinseg_period_msb=R10
	.DEF _sinseg=R11
	.DEF _sinseg_msb=R12
	.DEF _sys_timer_cnt=R13
	.DEF _sys_timer_cnt_msb=R14

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
	.DB  0x0,0x0,0xDD,0x8,0x0,0xE1,0x11,0x0
	.DB  0xE5,0x19,0x0,0xE8,0x21,0x0,0xEC,0x2A
	.DB  0x0,0xEF,0x32,0x0,0xF1,0x3A,0x0,0xF4
	.DB  0x42,0x0,0xF6,0x4A,0x0,0xF8,0x52,0x0
	.DB  0xFA,0x5A,0x0,0xFC,0x62,0x0,0xFD,0x69
	.DB  0x0,0xFE,0x71,0x0,0xFE,0x78,0x0,0xFF
	.DB  0x80,0x0,0xFF,0x87,0x0,0xFF,0x8E,0x0
	.DB  0xFE,0x95,0x0,0xFE,0x9B,0x0,0xFD,0xA2
	.DB  0x0,0xFC,0xA8,0x0,0xFA,0xAE,0x0,0xF8
	.DB  0xB4,0x0,0xF6,0xBA,0x0,0xF4,0xC0,0x0
	.DB  0xF1,0xC5,0x0,0xEF,0xCA,0x0,0xEC,0xCF
	.DB  0x0,0xE8,0xD4,0x0,0xE5,0xD9,0x0,0xE1
	.DB  0xDD,0x0,0xDD,0xE1,0x0,0xD9,0xE5,0x0
	.DB  0xD4,0xE8,0x0,0xCF,0xEC,0x0,0xCA,0xEF
	.DB  0x0,0xC5,0xF1,0x0,0xC0,0xF4,0x0,0xBA
	.DB  0xF6,0x0,0xB4,0xF8,0x0,0xAE,0xFA,0x0
	.DB  0xA8,0xFC,0x0,0xA2,0xFD,0x0,0x9B,0xFE
	.DB  0x0,0x95,0xFE,0x0,0x8E,0xFF,0x0,0x87
	.DB  0xFF,0x0,0x7F,0xFF,0x0,0x78,0xFE,0x0
	.DB  0x71,0xFE,0x0,0x69,0xFD,0x0,0x62,0xFC
	.DB  0x0,0x5A,0xFA,0x0,0x52,0xF8,0x0,0x4A
	.DB  0xF6,0x0,0x42,0xF4,0x0,0x3A,0xF1,0x0
	.DB  0x32,0xEF,0x0,0x2A,0xEC,0x0,0x21,0xE8
	.DB  0x0,0x19,0xE5,0x0,0x11,0xE1,0x0,0x8
	.DB  0xDD,0x0,0x0,0xE1,0x8,0x0,0xE5,0x11
	.DB  0x0,0xE8,0x19,0x0,0xEC,0x21,0x0,0xEF
	.DB  0x2A,0x0,0xF1,0x32,0x0,0xF4,0x3A,0x0
	.DB  0xF6,0x42,0x0,0xF8,0x4A,0x0,0xFA,0x52
	.DB  0x0,0xFC,0x5A,0x0,0xFD,0x62,0x0,0xFE
	.DB  0x69,0x0,0xFE,0x71,0x0,0xFF,0x78,0x0
	.DB  0xFF,0x7F,0x0,0xFF,0x87,0x0,0xFE,0x8E
	.DB  0x0,0xFE,0x95,0x0,0xFD,0x9B,0x0,0xFC
	.DB  0xA2,0x0,0xFA,0xA8,0x0,0xF8,0xAE,0x0
	.DB  0xF6,0xB4,0x0,0xF4,0xBA,0x0,0xF1,0xC0
	.DB  0x0,0xEF,0xC5,0x0,0xEC,0xCA,0x0,0xE8
	.DB  0xCF,0x0,0xE5,0xD4,0x0,0xE1,0xD9,0x0
	.DB  0xDD,0xDD,0x0,0xD9,0xE1,0x0,0xD4,0xE5
	.DB  0x0,0xCF,0xE8,0x0,0xCA,0xEC,0x0,0xC5
	.DB  0xEF,0x0,0xC0,0xF1,0x0,0xBA,0xF4,0x0
	.DB  0xB4,0xF6,0x0,0xAE,0xF8,0x0,0xA8,0xFA
	.DB  0x0,0xA2,0xFC,0x0,0x9B,0xFD,0x0,0x95
	.DB  0xFE,0x0,0x8E,0xFE,0x0,0x87,0xFF,0x0
	.DB  0x80,0xFF,0x0,0x78,0xFF,0x0,0x71,0xFE
	.DB  0x0,0x69,0xFE,0x0,0x62,0xFD,0x0,0x5A
	.DB  0xFC,0x0,0x52,0xFA,0x0,0x4A,0xF8,0x0
	.DB  0x42,0xF6,0x0,0x3A,0xF4,0x0,0x32,0xF1
	.DB  0x0,0x2A,0xEF,0x0,0x21,0xEC,0x0,0x19
	.DB  0xE8,0x0,0x11,0xE5,0x0,0x8,0xE1,0x0
	.DB  0x0,0xDD,0x0,0x0,0xE1,0x8,0x0,0xE5
	.DB  0x11,0x0,0xE8,0x19,0x0,0xEC,0x21,0x0
	.DB  0xEF,0x2A,0x0,0xF1,0x32,0x0,0xF4,0x3A
	.DB  0x0,0xF6,0x42,0x0,0xF8,0x4A,0x0,0xFA
	.DB  0x52,0x0,0xFC,0x5A,0x0,0xFD,0x62,0x0
	.DB  0xFE,0x69,0x0,0xFE,0x71,0x0,0xFF,0x78
	.DB  0x0,0xFF,0x80,0x0,0xFF,0x87,0x0,0xFE
	.DB  0x8E,0x0,0xFE,0x95,0x0,0xFD,0x9B,0x0
	.DB  0xFC,0xA2,0x0,0xFA,0xA8,0x0,0xF8,0xAE
	.DB  0x0,0xF6,0xB4,0x0,0xF4,0xBA,0x0,0xF1
	.DB  0xC0,0x0,0xEF,0xC5,0x0,0xEC,0xCA,0x0
	.DB  0xE8,0xCF,0x0,0xE5,0xD4,0x0,0xE1,0xD9
	.DB  0x0,0xDD,0xDD,0x0,0xD9,0xE1,0x0,0xD4
	.DB  0xE5,0x0,0xCF,0xE8,0x0,0xCA,0xEC,0x0
	.DB  0xC5,0xEF,0x0,0xC0,0xF1,0x0,0xBA,0xF4
	.DB  0x0,0xB4,0xF6,0x0,0xAE,0xF8,0x0,0xA8
	.DB  0xFA,0x0,0xA2,0xFC,0x0,0x9B,0xFD,0x0
	.DB  0x95,0xFE,0x0,0x8E,0xFE,0x0,0x87,0xFF
	.DB  0x0,0x80,0xFF,0x0,0x78,0xFF,0x0,0x71
	.DB  0xFE,0x0,0x69,0xFE,0x0,0x62,0xFD,0x0
	.DB  0x5A,0xFC,0x0,0x52,0xFA,0x0,0x4A,0xF8
	.DB  0x0,0x42,0xF6,0x0,0x3A,0xF4,0x0,0x32
	.DB  0xF1,0x0,0x2A,0xEF,0x0,0x21,0xEC,0x0
	.DB  0x19,0xE8,0x0,0x11,0xE5,0x0,0x8,0xE1

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x0B
	.DW  0x04
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
;#define DEAD_TIME_HALF      2  //Мертвий час (1 = 0.26 мкс)
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
;#define REVERSE_BUT     PINC.5  //  Кнопка запуску назад
;
;#define POWER_SENS      PIND.2  // Пропажа сети - нормальное состояние лог.0, при лог.1 - сделать стоп привода, после по ...
;#define CAP_VOLTAGE     3       //ADC3 - пренапряжение силовой части ( больше +340В).С силового конденсатора через делит ...
;#define DRIVER_TEMP     4       //ADC4 - измерение перегрева силовой части. Согласно таблицам расчитать работы терморези ...
;#define NORMAL_LED      PORTC.2 // - светодиод индикации работы - начинает гореть спустя 4 секунды после (включения PD2) ...
;#define ERROR_LED       PORTC.1 // - светодиод индикации аварии
;#define OVERLOAD        PINB.5  // - сверхток - лог.0 (подтянут через 10К к 5В) - при подаче лог.0 на этот вывод - резко ...
;#define OVER_MOTORTEMP  PIND.2  // - Перегрев двигателя - нормальное состояние лог.0 при появлении лог.1. сделать стоп п ...
;
;// Кінець роспіновки
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
;// Declare your global variables here
;char mode=0;
;int sinpos=0;
;int direct=0;
;float amplitude=0;
;int sinseg_period=0,sinseg=0;
;int sys_timer_cnt=0;
;
;long map(long x, long in_min, long in_max, long out_min, long out_max)
; 0000 004E {

	.CSEG
_map:
; .FSTART _map
; 0000 004F   return ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min);
	RCALL __PUTPARD2
;	x -> Y+16
;	in_min -> Y+12
;	in_max -> Y+8
;	out_min -> Y+4
;	out_max -> Y+0
	RCALL SUBOPT_0x0
	__GETD1S 16
	RCALL __SUBD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	RCALL __GETD1S0
	RCALL __SUBD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __MULD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x0
	__GETD1S 8
	RCALL __SUBD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVD21
	RCALL SUBOPT_0x1
	RCALL __ADDD12
	ADIW R28,20
	RET
; 0000 0050 }
; .FEND
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0053 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0054      sinseg++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
; 0000 0055      if (sinseg>=sinseg_period)
	__CPWRR 11,12,9,10
	BRLT _0x3
; 0000 0056      {
; 0000 0057         sinseg=0;
	CLR  R11
	CLR  R12
; 0000 0058         if (amplitude==0 || mode==0){off_pwm();}
	RCALL SUBOPT_0x2
	BREQ _0x5
	LDI  R30,LOW(0)
	CP   R30,R4
	BRNE _0x4
_0x5:
	RCALL _off_pwm
; 0000 0059         if (mode==1 && amplitude>0 ) {gen_next_sinpos();}
_0x4:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x8
	RCALL SUBOPT_0x2
	BRLT _0x9
_0x8:
	RJMP _0x7
_0x9:
	RCALL _gen_next_sinpos
; 0000 005A      }
_0x7:
; 0000 005B     sys_timer_cnt++;
_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
; 0000 005C     if (sys_timer_cnt>138) {sys_timer_cnt=0; sys_timer();}
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	CP   R30,R13
	CPC  R31,R14
	BRGE _0xA
	CLR  R13
	CLR  R14
	RCALL _sys_timer
; 0000 005D }
_0xA:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;void sys_timer(void)
; 0000 005F {
_sys_timer:
; .FSTART _sys_timer
; 0000 0060 
; 0000 0061 }
	RET
; .FEND
;void gen_next_sinpos(void)
; 0000 0063 {
_gen_next_sinpos:
; .FSTART _gen_next_sinpos
; 0000 0064     char tempU,tempV,tempW;
; 0000 0065     char compareHigh, compareLow;
; 0000 0066     int tsp;
; 0000 0067     sinpos++;
	SBIW R28,2
	RCALL __SAVELOCR6
;	tempU -> R17
;	tempV -> R16
;	tempW -> R19
;	compareHigh -> R18
;	compareLow -> R21
;	tsp -> Y+6
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
; 0000 0068     if (sinpos==SINE_TABLE_LENGTH) sinpos=0;
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	CP   R30,R5
	CPC  R31,R6
	BRNE _0xB
	CLR  R5
	CLR  R6
; 0000 0069     tsp=sinpos*3;
_0xB:
	__GETW1R 5,6
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MULW12
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 006A     tempU=sineTable[tsp]*amplitude;
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-_sineTable*2)
	SBCI R31,HIGH(-_sineTable*2)
	RCALL SUBOPT_0x4
	MOV  R17,R30
; 0000 006B     if (direct == DIRECTION_FORWARD)
	MOV  R0,R7
	OR   R0,R8
	BRNE _0xC
; 0000 006C     {
; 0000 006D         tempV = sineTable[tsp+1]*amplitude;
	RCALL SUBOPT_0x5
	MOV  R16,R30
; 0000 006E         tempW = sineTable[tsp+2]*amplitude;
	RCALL SUBOPT_0x6
	MOV  R19,R30
; 0000 006F     }
; 0000 0070     else
	RJMP _0xD
_0xC:
; 0000 0071     {
; 0000 0072         tempW = sineTable[tsp+1]*amplitude;
	RCALL SUBOPT_0x5
	MOV  R19,R30
; 0000 0073         tempV = sineTable[tsp+2]*amplitude;
	RCALL SUBOPT_0x6
	MOV  R16,R30
; 0000 0074     }
_0xD:
; 0000 0075 
; 0000 0076     InsertDeadband(tempU, &compareHigh, &compareLow);
	ST   -Y,R17
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R18
	IN   R26,SPL
	IN   R27,SPH
	PUSH R21
	RCALL _InsertDeadband
	POP  R21
	POP  R18
; 0000 0077     OCR0A = compareHigh;
	OUT  0x27,R18
; 0000 0078     OCR0B = compareLow;
	OUT  0x28,R21
; 0000 0079 
; 0000 007A     InsertDeadband(tempV, &compareHigh, &compareLow);
	ST   -Y,R16
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R18
	IN   R26,SPL
	IN   R27,SPH
	PUSH R21
	RCALL _InsertDeadband
	POP  R21
	POP  R18
; 0000 007B     OCR1AL = compareHigh;
	STS  136,R18
; 0000 007C     OCR1BL = compareLow;
	STS  138,R21
; 0000 007D 
; 0000 007E     InsertDeadband(tempW, &compareHigh, &compareLow);
	ST   -Y,R19
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R18
	IN   R26,SPL
	IN   R27,SPH
	PUSH R21
	RCALL _InsertDeadband
	POP  R21
	POP  R18
; 0000 007F     OCR2A = compareHigh;
	STS  179,R18
; 0000 0080     OCR2B = compareLow;
	STS  180,R21
; 0000 0081 }
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;
;void InsertDeadband(char compareValue, char * compareHighPtr, char * compareLowPtr)   //вставка метвого часу
; 0000 0084 {
_InsertDeadband:
; .FSTART _InsertDeadband
; 0000 0085   if (compareValue <= DEAD_TIME_HALF)
	ST   -Y,R27
	ST   -Y,R26
;	compareValue -> Y+4
;	*compareHighPtr -> Y+2
;	*compareLowPtr -> Y+0
	LDD  R26,Y+4
	CPI  R26,LOW(0x3)
	BRSH _0xE
; 0000 0086   {
; 0000 0087     *compareHighPtr = 0x00;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0088     *compareLowPtr = compareValue;
	LDD  R30,Y+4
	RJMP _0x1A
; 0000 0089   }
; 0000 008A   else if (compareValue >= (0xff - DEAD_TIME_HALF))
_0xE:
	LDD  R26,Y+4
	CPI  R26,LOW(0xFD)
	BRLO _0x10
; 0000 008B   {
; 0000 008C     *compareHighPtr = 0xff - (2 * DEAD_TIME_HALF);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(251)
	ST   X,R30
; 0000 008D     *compareLowPtr = 0xff;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(255)
	RJMP _0x1B
; 0000 008E   }
; 0000 008F   else
_0x10:
; 0000 0090   {
; 0000 0091     *compareHighPtr = compareValue - DEAD_TIME_HALF;
	LDD  R30,Y+4
	SUBI R30,LOW(2)
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
; 0000 0092     *compareLowPtr = compareValue + DEAD_TIME_HALF;
	LDD  R30,Y+4
	SUBI R30,-LOW(2)
_0x1A:
	LD   R26,Y
	LDD  R27,Y+1
_0x1B:
	ST   X,R30
; 0000 0093   }
; 0000 0094 }
	ADIW R28,5
	RET
; .FEND
;
;void set_freq(int freq)
; 0000 0097 {
_set_freq:
; .FSTART _set_freq
; 0000 0098    float amp;
; 0000 0099    if (freq==0) {amplitude=0;sinseg_period=124; return;}
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
;	freq -> Y+4
;	amp -> Y+0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x12
	LDI  R30,LOW(0)
	STS  _amplitude,R30
	STS  _amplitude+1,R30
	STS  _amplitude+2,R30
	STS  _amplitude+3,R30
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	__PUTW1R 9,10
	RJMP _0x2000001
; 0000 009A    sinseg_period=124/freq;
_0x12:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDI  R26,LOW(124)
	LDI  R27,HIGH(124)
	RCALL __DIVW21
	__PUTW1R 9,10
; 0000 009B    amp=map(freq,1,60,30,100);
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL __CWD1
	RCALL __PUTPARD1
	__GETD1N 0x1
	RCALL __PUTPARD1
	__GETD1N 0x3C
	RCALL __PUTPARD1
	__GETD1N 0x1E
	RCALL __PUTPARD1
	__GETD2N 0x64
	RCALL _map
	RCALL __CDF1
	RCALL __PUTD1S0
; 0000 009C    amplitude=amp/100;
	RCALL __GETD2S0
	__GETD1N 0x42C80000
	RCALL __DIVF21
	STS  _amplitude,R30
	STS  _amplitude+1,R31
	STS  _amplitude+2,R22
	STS  _amplitude+3,R23
; 0000 009D 
; 0000 009E }
_0x2000001:
	ADIW R28,6
	RET
; .FEND
;void off_pwm(void)
; 0000 00A0 {
_off_pwm:
; .FSTART _off_pwm
; 0000 00A1     OCR0A=0x00;
	RCALL SUBOPT_0x7
; 0000 00A2     OCR0B=0xFF;
; 0000 00A3     OCR1AL=0x00;
	LDI  R30,LOW(0)
	STS  136,R30
; 0000 00A4     OCR1BL=0xFF;
	RCALL SUBOPT_0x8
; 0000 00A5     OCR2A=0x00;
	RCALL SUBOPT_0x9
; 0000 00A6     OCR2B=0xFF;
; 0000 00A7 }
	RET
; .FEND
;void check_error(void)
; 0000 00A9 {
; 0000 00AA //POWER_SENS
; 0000 00AB // CAP_VOLTAGE
; 0000 00AC //  DRIVER_TEMP
; 0000 00AD //   NORMAL_LED
; 0000 00AE //    ERROR_LED
; 0000 00AF //    OVERLOAD
; 0000 00B0 //     OVER_MOTORTEMP
; 0000 00B1 }
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 00B7 {
; 0000 00B8 ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 00B9 // Delay needed for the stabilization of the ADC input voltage
; 0000 00BA delay_us(10);
; 0000 00BB // Start the AD conversion
; 0000 00BC ADCSRA|=(1<<ADSC);
; 0000 00BD // Wait for the AD conversion to complete
; 0000 00BE while ((ADCSRA & (1<<ADIF))==0);
; 0000 00BF ADCSRA|=(1<<ADIF);
; 0000 00C0 return ADCW;
; 0000 00C1 }
;
;void main(void)
; 0000 00C4 {
_main:
; .FSTART _main
; 0000 00C5 // Declare your local variables here
; 0000 00C6 int adcv=0;
; 0000 00C7 // Crystal Oscillator division factor: 1
; 0000 00C8 #pragma optsize-
; 0000 00C9 CLKPR=(1<<CLKPCE);
;	adcv -> R16,R17
	__GETWRN 16,17,0
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00CA CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00CB #ifdef _OPTIMIZE_SIZE_
; 0000 00CC #pragma optsize+
; 0000 00CD #endif
; 0000 00CE 
; 0000 00CF // Input/Output Ports initialization
; 0000 00D0 // Port B initialization
; 0000 00D1 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=In
; 0000 00D2 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x4,R30
; 0000 00D3 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=T
; 0000 00D4 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 00D5 
; 0000 00D6 // Port C initialization
; 0000 00D7 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=out Bit1=out Bit0=In
; 0000 00D8 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(6)
	OUT  0x7,R30
; 0000 00D9 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00DA PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 00DB 
; 0000 00DC // Port D initialization
; 0000 00DD // Function: Bit7=In Bit6=Out Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 00DE DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(104)
	OUT  0xA,R30
; 0000 00DF // State: Bit7=T Bit6=0 Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 00E0 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00E1 
; 0000 00E2 // Timer/Counter 0 initialization
; 0000 00E3 // Clock source: System Clock
; 0000 00E4 // Clock value: 8000,000 kHz
; 0000 00E5 // Mode: Phase correct PWM top=0xFF
; 0000 00E6 // OC0A output: Non-Inverted PWM
; 0000 00E7 // OC0B output: Inverted PWM
; 0000 00E8 // Timer Period: 0,06375 ms
; 0000 00E9 // Output Pulse(s):
; 0000 00EA // OC0A Period: 0,06375 ms Width: 0 us// OC0B Period: 0,06375 ms Width: 0,06375 ms
; 0000 00EB TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (1<<COM0B1) | (1<<COM0B0) | (0<<WGM01) | (1<<WGM00);
	LDI  R30,LOW(177)
	OUT  0x24,R30
; 0000 00EC TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 00ED TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00EE OCR0A=0x00;
	RCALL SUBOPT_0x7
; 0000 00EF OCR0B=0xFF;
; 0000 00F0 
; 0000 00F1 // Timer/Counter 1 initialization
; 0000 00F2 // Clock source: System Clock
; 0000 00F3 // Clock value: 8000,000 kHz
; 0000 00F4 // Mode: Ph. correct PWM top=0x00FF
; 0000 00F5 // OC1A output: Non-Inverted PWM
; 0000 00F6 // OC1B output: Inverted PWM
; 0000 00F7 // Noise Canceler: Off
; 0000 00F8 // Input Capture on Falling Edge
; 0000 00F9 // Timer Period: 0,06375 ms
; 0000 00FA // Output Pulse(s):
; 0000 00FB // OC1A Period: 0,06375 ms Width: 0 us// OC1B Period: 0,06375 ms Width: 0,06375 ms
; 0000 00FC // Timer1 Overflow Interrupt: On
; 0000 00FD // Input Capture Interrupt: Off
; 0000 00FE // Compare A Match Interrupt: Off
; 0000 00FF // Compare B Match Interrupt: Off
; 0000 0100 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(177)
	STS  128,R30
; 0000 0101 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 0102 TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 0103 TCNT1L=0x00;
	STS  132,R30
; 0000 0104 ICR1H=0x00;
	STS  135,R30
; 0000 0105 ICR1L=0x00;
	STS  134,R30
; 0000 0106 OCR1AH=0x00;
	STS  137,R30
; 0000 0107 OCR1AL=0x00;
	STS  136,R30
; 0000 0108 OCR1BH=0x00;
	STS  139,R30
; 0000 0109 OCR1BL=0xFF;
	RCALL SUBOPT_0x8
; 0000 010A 
; 0000 010B // Timer/Counter 2 initialization
; 0000 010C // Clock source: System Clock
; 0000 010D // Clock value: 8000,000 kHz
; 0000 010E // Mode: Phase correct PWM top=0xFF
; 0000 010F // OC2A output: Non-Inverted PWM
; 0000 0110 // OC2B output: Inverted PWM
; 0000 0111 // Timer Period: 0,06375 ms
; 0000 0112 // Output Pulse(s):
; 0000 0113 // OC2A Period: 0,06375 ms Width: 0 us// OC2B Period: 0,06375 ms Width: 0,06375 ms
; 0000 0114 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0115 TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (0<<WGM21) | (1<<WGM20);
	LDI  R30,LOW(177)
	STS  176,R30
; 0000 0116 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(1)
	STS  177,R30
; 0000 0117 TCNT2=0x00;
	LDI  R30,LOW(0)
	STS  178,R30
; 0000 0118 OCR2A=0x00;
	RCALL SUBOPT_0x9
; 0000 0119 OCR2B=0xFF;
; 0000 011A 
; 0000 011B // Timer/Counter 0 Interrupt(s) initialization
; 0000 011C TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 011D 
; 0000 011E // Timer/Counter 1 Interrupt(s) initialization
; 0000 011F TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 0120 
; 0000 0121 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0122 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 0123 
; 0000 0124 // External Interrupt(s) initialization
; 0000 0125 // INT0: Off
; 0000 0126 // INT1: Off
; 0000 0127 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0128 // Interrupt on any change on pins PCINT8-14: Off
; 0000 0129 // Interrupt on any change on pins PCINT16-23: Off
; 0000 012A EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 012B EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 012C PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 012D 
; 0000 012E // USART initialization
; 0000 012F // USART disabled
; 0000 0130 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 0131 
; 0000 0132 // Analog Comparator initialization
; 0000 0133 // Analog Comparator: Off
; 0000 0134 // The Analog Comparator's positive input is
; 0000 0135 // connected to the AIN0 pin
; 0000 0136 // The Analog Comparator's negative input is
; 0000 0137 // connected to the AIN1 pin
; 0000 0138 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0139 // Digital input buffer on AIN0: On
; 0000 013A // Digital input buffer on AIN1: On
; 0000 013B DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 013C 
; 0000 013D // ADC initialization
; 0000 013E // ADC Clock frequency: 62,500 kHz
; 0000 013F // ADC Voltage Reference: AREF pin
; 0000 0140 // ADC Auto Trigger Source: ADC Stopped
; 0000 0141 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 0142 // ADC4: On, ADC5: On
; 0000 0143 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 0144 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 0145 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	STS  122,R30
; 0000 0146 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0147 
; 0000 0148 // SPI initialization
; 0000 0149 // SPI disabled
; 0000 014A SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 014B 
; 0000 014C // TWI initialization
; 0000 014D // TWI disabled
; 0000 014E TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 014F 
; 0000 0150 // Global enable interrupts
; 0000 0151 TCNT0=0;
	OUT  0x26,R30
; 0000 0152 TCNT1L=2;
	LDI  R30,LOW(2)
	STS  132,R30
; 0000 0153 TCNT2=5;
	LDI  R30,LOW(5)
	STS  178,R30
; 0000 0154 #asm("sei")
	sei
; 0000 0155       set_freq(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _set_freq
; 0000 0156       mode=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0157 while (1)
_0x16:
; 0000 0158       {
; 0000 0159       // Place your code here
; 0000 015A 
; 0000 015B 
; 0000 015C       }
	RJMP _0x16
; 0000 015D }
_0x19:
	RJMP _0x19
; .FEND

	.DSEG
_amplitude:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LDS  R26,_amplitude
	LDS  R27,_amplitude+1
	LDS  R24,_amplitude+2
	LDS  R25,_amplitude+3
	RCALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x4:
	LPM  R26,Z
	LDI  R27,0
	LDS  R30,_amplitude
	LDS  R31,_amplitude+1
	LDS  R22,_amplitude+2
	LDS  R23,_amplitude+3
	RCALL __CWD2
	RCALL __CDF2
	RCALL __MULF12
	RCALL __CFD1U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	RCALL SUBOPT_0x3
	__ADDW1FN _sineTable,1
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x3
	__ADDW1FN _sineTable,2
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	OUT  0x27,R30
	LDI  R30,LOW(255)
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(255)
	STS  138,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	STS  179,R30
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

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
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

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
