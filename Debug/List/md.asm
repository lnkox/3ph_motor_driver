
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
;Data Stack size        : 368 byte(s)
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
	.EQU __DSTACK_SIZE=0x0170
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
	.DEF _sinseg=R4
	.DEF _sys_timer_cnt=R3

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
	RJMP _timer2_ovf_isr
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
	RJMP 0x00

_sineTable:
	.DB  0x0,0xB,0x17,0x23,0x2E,0x39,0x43,0x4D
	.DB  0x56,0x5E,0x65,0x6C,0x71,0x76,0x79,0x7B
	.DB  0x7C,0x7C,0x7B,0x79,0x76,0x71,0x6C,0x65
	.DB  0x5E,0x56,0x4D,0x43,0x39,0x2E,0x23,0x17
	.DB  0xB,0x0,0xF4,0xE8,0xDC,0xD1,0xC6,0xBC
	.DB  0xB2,0xA9,0xA1,0x9A,0x93,0x8E,0x89,0x86
	.DB  0x84,0x83,0x83,0x84,0x86,0x89,0x8E,0x93
	.DB  0x9A,0xA1,0xA9,0xB2,0xBC,0xC6,0xD1,0xDC
	.DB  0xE8,0xF4,0xFF

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x6:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x55,0x0,0x0,0x0,0x0,0x9A,0x99,0x99
	.DB  0x3E

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x03
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
	.ORG 0x270

	.CSEG
;
;//������� ������������
;#define DEAD_TIME_HALF      2   //������� ��� (1 = 0.26 ���)
;#define ACCELERATION        40  //�����������  (��/���)
;#define NORM_VOLTAGE        512 // ��������� �������� ������ ������� � �������� ��� (����:1023)
;#define MAX_BRAKE_VOLTAGE   562 // ����������� ��������� �������� ������� ��� ����������� � �������� ��� (����:1023)
;#define CRYTYCAL_VOLTAGE    594 // �������� �������� ������� � �������� ��� (����:1023)
;#define BRAKE_PERIOD        2 // ����� ����������� ������� (1/2 ���)
;#define NORM_TEMP_DRIVER    200 // ��������� �������� ����������� �������� � �������� ��� (����:1023)
;#define MAX_TEMP_DRIVER     300 // ����������� ��������� �������� ����������� �������� � �������� ��� (����:1023)
;
;
;//ʳ���� �����������
;
;
;#define SINE_TABLE_LENGTH   66 // ʳ������ ������� � ������� ������
;
;#define DIRECTION_FORWARD       0 // ��������� ���� ������
;#define DIRECTION_REVERSE       1 // ��������� ���� �����
;
;#define MODE_STOP      0 // ����� "���������"
;#define MODE_RUN       1 // ����� "������"
;#define MODE_BRAKE     2 // ����� "�����������"
;
;#define ERROR_NO            0 // ������� ��������
;#define ERROR_POWER         1 // ³��������� ��������
;#define ERROR_OVERVOLTAGE   2 // ����������� �� �����������
;#define ERROR_OVERLOAD      3 // �������������� �� ������
;#define ERROR_DRIVERTEMP    4 // ������� ��������
;#define ERROR_MOTORTEMP     5 // ������� �������
;
;// ���������
;#define FORWARD_BUT     PIND.1  //  ������ ������� ������
;#define STOP_BUT        PIND.0  //  ������ �������
;#define REVERSE_BUT     PINC.0  //  ������ ������� �����
;
;#define POWER_SENS      PIND.2  // ������� ���� - ���������� ��������� ���.0, ��� ���.1 - ������� ���� �������, ����� �� ...
;#define CAP_VOLTAGE     3       //ADC3 - ������������� ������� ����� ( ������ +340�).� �������� ������������ ����� ����� ...
;#define DRIVER_TEMP     4       //ADC4 - ��������� ��������� ������� �����. �������� �������� ��������� ������ ��������� ...
;#define FREQUENCY_ADC   7       //ADC7 - ����������� �������
;#define NORMAL_LED      PORTC.1 // - ��������� ��������� ������ - �������� ������ ������ 4 ������� ����� (��������� PD2) ...
;#define ERROR_LED       PORTC.2 // - ��������� ��������� ������
;#define OVER_LOAD       PINB.4  // - �������� - ���.0 (�������� ����� 10� � 5�) - ��� ������ ���.0 �� ���� ����� - ����� ...
;#define OVER_MOTORTEMP  PIND.4  // - �������� ��������� - ���������� ��������� ���.0 ��� ��������� ���.1. ������� ���� � ...
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
;#include <md.h>
;#include <delay.h>
;// Declare your global function here
;// Declare your global variables here
;char sinseg=0;// ˳������� ��� ��������� ������� ������
;char sys_timer_cnt=0;// ˳������� ���������� �������
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0039 {

	.CSEG
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
; 0000 003A     sinseg++;
	INC  R4
; 0000 003B     sys_timer_cnt++;
	INC  R3
; 0000 003C }
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0041 {
_read_adc:
; .FSTART _read_adc
; 0000 0042 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	STS  124,R30
; 0000 0043 // Delay needed for the stabilization of the ADC input voltage
; 0000 0044 delay_us(10);
	__DELAY_USB 27
; 0000 0045 // Start the AD conversion
; 0000 0046 ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 0047 // Wait for the AD conversion to complete
; 0000 0048 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x3
; 0000 0049 ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 004A return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	ADIW R28,1
	RET
; 0000 004B }
; .FEND
;
;void main(void)
; 0000 004E {
_main:
; .FSTART _main
; 0000 004F // Declare your local variables here
; 0000 0050 char tmp;
; 0000 0051 char tmpsin;
; 0000 0052 signed char h_sin[72],l_sin[72]; // ������� ������� ������
; 0000 0053 float amplitude=0.3; // ���������� �������� ������ (0.0-1.0)
; 0000 0054 float amp=0; // ��������
; 0000 0055 char sinseg_period=4; // ����� ����� ������
; 0000 0056 char mode=0; //����� ������ �������� (0-����, 1-������, 2-�����������)
; 0000 0057 bit overvoltage_state=0; //����������� �� �����������
; 0000 0058 char sinU=0,sinV=42,sinW=85; // �������� �������� ������ �� ������� ������
; 0000 0059 bit direct=0; // ������ ���� (0-������, 1-�����)
; 0000 005A volatile char cur_freq=0;// ���� ������� �������
; 0000 005B volatile char freq=0;// ����������� ������� �������
; 0000 005C char accel_cnt=0;// ˳������� �����������
; 0000 005D char brake_cnt=0;// ˳������� �����������
; 0000 005E char error_led_cnt=0; // ˳������� ��������� �������
; 0000 005F char error_led_period=0; // ����� ��������� �������
; 0000 0060 char error=0; // �������
; 0000 0061 char slow_timer_cnt=0; // ������ ��� �� ��������� �������
; 0000 0062 #pragma optsize-
; 0000 0063 CLKPR=(1<<CLKPCE);
	SBIW R28,63
	SBIW R28,63
	SBIW R28,35
	LDI  R24,17
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x6*2)
	LDI  R31,HIGH(_0x6*2)
	RCALL __INITLOCB
;	tmp -> R17
;	tmpsin -> R16
;	h_sin -> Y+89
;	l_sin -> Y+17
;	amplitude -> Y+13
;	amp -> Y+9
;	sinseg_period -> R19
;	mode -> R18
;	overvoltage_state -> R15.0
;	sinU -> R21
;	sinV -> R20
;	sinW -> Y+8
;	direct -> R15.1
;	cur_freq -> Y+7
;	freq -> Y+6
;	accel_cnt -> Y+5
;	brake_cnt -> Y+4
;	error_led_cnt -> Y+3
;	error_led_period -> Y+2
;	error -> Y+1
;	slow_timer_cnt -> Y+0
	CLR  R15
	LDI  R19,4
	LDI  R18,0
	LDI  R21,0
	LDI  R20,42
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0064 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0065 #ifdef _OPTIMIZE_SIZE_
; 0000 0066 #pragma optsize+
; 0000 0067 #endif
; 0000 0068 // ����������� ز� ������ � 0
; 0000 0069 OCR0A=0x00;
	RCALL SUBOPT_0x0
; 0000 006A OCR0B=0xFF;
; 0000 006B OCR1AL=0x00;
; 0000 006C OCR1BL=0xFF;
; 0000 006D OCR2A=0x00;
; 0000 006E OCR2B=0xFF;
; 0000 006F DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(14)
	OUT  0x4,R30
; 0000 0070 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 0071 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(6)
	OUT  0x7,R30
; 0000 0072 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0073 DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(104)
	OUT  0xA,R30
; 0000 0074 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0075 TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (1<<COM0B1) | (1<<COM0B0) | (0<<WGM01) | (1<<WGM00);
	LDI  R30,LOW(177)
	OUT  0x24,R30
; 0000 0076 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 0077 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(177)
	STS  128,R30
; 0000 0078 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 0079 ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 007A ICR1L=0x00;
	STS  134,R30
; 0000 007B ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 007C TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (0<<WGM21) | (1<<WGM20);
	LDI  R30,LOW(177)
	STS  176,R30
; 0000 007D TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(1)
	STS  177,R30
; 0000 007E TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	LDI  R30,LOW(0)
	STS  110,R30
; 0000 007F TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
; 0000 0080 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (1<<TOIE2);
	LDI  R30,LOW(1)
	STS  112,R30
; 0000 0081 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	STS  105,R30
; 0000 0082 EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 0083 PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 0084 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 0085 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0086 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 0087 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 0088 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 0089 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	STS  122,R30
; 0000 008A ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 008B SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 008C TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 008D 
; 0000 008E // ���������� �������� ������� ������
; 0000 008F amplitude=0.3;
	__GETD1N 0x3E99999A
	RCALL SUBOPT_0x1
; 0000 0090 for (tmp=0;tmp<SINE_TABLE_LENGTH;tmp++)
	LDI  R17,LOW(0)
_0x8:
	CPI  R17,66
	BRSH _0x9
; 0000 0091  {
; 0000 0092     tmpsin=127+(sineTable[tmp]*amplitude);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 0093     if (tmpsin <= DEAD_TIME_HALF)
	BRSH _0xA
; 0000 0094     {
; 0000 0095         h_sin[tmp] = 0x00;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0096         l_sin[tmp] = tmpsin;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0000 0097     }
; 0000 0098     else if (tmpsin >= (0xff - DEAD_TIME_HALF))
	RJMP _0xB
_0xA:
	CPI  R16,253
	BRLO _0xC
; 0000 0099     {
; 0000 009A         h_sin[tmp] = 0xff - (2 * DEAD_TIME_HALF);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
	LDI  R30,LOW(251)
	ST   X,R30
; 0000 009B         l_sin[tmp] = 0xff;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x6
	LDI  R30,LOW(255)
	RJMP _0x3B
; 0000 009C     }
; 0000 009D     else
_0xC:
; 0000 009E     {
; 0000 009F         h_sin[tmp] = tmpsin - DEAD_TIME_HALF;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
	MOV  R30,R16
	SUBI R30,LOW(2)
	ST   X,R30
; 0000 00A0         l_sin[tmp] = tmpsin + DEAD_TIME_HALF;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x6
	MOV  R30,R16
	SUBI R30,-LOW(2)
_0x3B:
	ST   X,R30
; 0000 00A1     }
_0xB:
; 0000 00A2  }
	SUBI R17,-1
	RJMP _0x8
_0x9:
; 0000 00A3 
; 0000 00A4 
; 0000 00A5 
; 0000 00A6 TCNT0=0;    //������������� �������
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00A7 TCNT1L=2;   //������������� �������
	LDI  R30,LOW(2)
	STS  132,R30
; 0000 00A8 TCNT2=5;    //������������� �������
	LDI  R30,LOW(5)
	STS  178,R30
; 0000 00A9 #asm("sei")
	sei
; 0000 00AA 
; 0000 00AB while (1)
_0xE:
; 0000 00AC {
; 0000 00AD     if (sinseg>=sinseg_period)
	CP   R4,R19
	BRSH PC+2
	RJMP _0x11
; 0000 00AE     {
; 0000 00AF         sinseg=0;
	CLR  R4
; 0000 00B0         if (mode>0 && overvoltage_state==0)
	CPI  R18,1
	BRLO _0x13
	SBRS R15,0
	RJMP _0x14
_0x13:
	RJMP _0x12
_0x14:
; 0000 00B1         {
; 0000 00B2             sinU++;
	SUBI R21,-1
; 0000 00B3             sinV++;
	SUBI R20,-1
; 0000 00B4             sinW++;
	LDD  R30,Y+8
	SUBI R30,-LOW(1)
	STD  Y+8,R30
; 0000 00B5             if (sinU==SINE_TABLE_LENGTH) sinU=0;
	CPI  R21,66
	BRNE _0x15
	LDI  R21,LOW(0)
; 0000 00B6             if (sinV==SINE_TABLE_LENGTH) sinV=0;
_0x15:
	CPI  R20,66
	BRNE _0x16
	LDI  R20,LOW(0)
; 0000 00B7             if (sinW==SINE_TABLE_LENGTH) sinW=0;
_0x16:
	LDD  R26,Y+8
	CPI  R26,LOW(0x42)
	BRNE _0x17
	LDI  R30,LOW(0)
	STD  Y+8,R30
; 0000 00B8             OCR0A = h_sin[sinU];
_0x17:
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x4
	LD   R30,X
	OUT  0x27,R30
; 0000 00B9             OCR0B = l_sin[sinU];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x6
	LD   R30,X
	OUT  0x28,R30
; 0000 00BA             if (direct == DIRECTION_FORWARD)
	SBRC R15,1
	RJMP _0x18
; 0000 00BB             {
; 0000 00BC                 OCR1AL = h_sin[sinW];
	LDD  R30,Y+8
	RCALL SUBOPT_0x8
	LD   R30,X
	STS  136,R30
; 0000 00BD                 OCR1BL = l_sin[sinW];
	LDD  R30,Y+8
	LDI  R31,0
	RCALL SUBOPT_0x6
	LD   R30,X
	STS  138,R30
; 0000 00BE                 OCR2A = h_sin[sinV];
	MOV  R30,R20
	RCALL SUBOPT_0x8
	LD   R30,X
	STS  179,R30
; 0000 00BF                 OCR2B = l_sin[sinV];
	MOV  R30,R20
	RJMP _0x3C
; 0000 00C0             }
; 0000 00C1             else
_0x18:
; 0000 00C2             {
; 0000 00C3                 OCR1AL = h_sin[sinV];
	MOV  R30,R20
	RCALL SUBOPT_0x8
	LD   R30,X
	STS  136,R30
; 0000 00C4                 OCR1BL = l_sin[sinV];
	MOV  R30,R20
	LDI  R31,0
	RCALL SUBOPT_0x6
	LD   R30,X
	STS  138,R30
; 0000 00C5                 OCR2A = h_sin[sinW];
	LDD  R30,Y+8
	RCALL SUBOPT_0x8
	LD   R30,X
	STS  179,R30
; 0000 00C6                 OCR2B = l_sin[sinW];
	LDD  R30,Y+8
_0x3C:
	LDI  R31,0
	RCALL SUBOPT_0x6
	LD   R30,X
	STS  180,R30
; 0000 00C7             }
; 0000 00C8             NORMAL_LED=!NORMAL_LED;
	SBIS 0x8,1
	RJMP _0x1A
	CBI  0x8,1
	RJMP _0x1B
_0x1A:
	SBI  0x8,1
_0x1B:
; 0000 00C9             NORMAL_LED=!NORMAL_LED;
	SBIS 0x8,1
	RJMP _0x1C
	CBI  0x8,1
	RJMP _0x1D
_0x1C:
	SBI  0x8,1
_0x1D:
; 0000 00CA             tmpsin=127+(sineTable[sinU]*amplitude);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x3
; 0000 00CB             if (tmpsin <= DEAD_TIME_HALF)
	BRSH _0x1E
; 0000 00CC             {
; 0000 00CD                 h_sin[sinU] = 0x00;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x4
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00CE                 l_sin[sinU] = tmpsin;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0000 00CF             }
; 0000 00D0             else if (tmpsin >= (0xff - DEAD_TIME_HALF))
	RJMP _0x1F
_0x1E:
	CPI  R16,253
	BRLO _0x20
; 0000 00D1             {
; 0000 00D2                 h_sin[sinU] = 0xff - (2 * DEAD_TIME_HALF);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x4
	LDI  R30,LOW(251)
	ST   X,R30
; 0000 00D3                 l_sin[sinU] = 0xff;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x6
	LDI  R30,LOW(255)
	RJMP _0x3D
; 0000 00D4             }
; 0000 00D5             else
_0x20:
; 0000 00D6             {
; 0000 00D7                 h_sin[sinU] = tmpsin - DEAD_TIME_HALF;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x4
	MOV  R30,R16
	SUBI R30,LOW(2)
	ST   X,R30
; 0000 00D8                 l_sin[sinU] = tmpsin + DEAD_TIME_HALF;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x6
	MOV  R30,R16
	SUBI R30,-LOW(2)
_0x3D:
	ST   X,R30
; 0000 00D9             }
_0x1F:
; 0000 00DA         }
; 0000 00DB         else
	RJMP _0x22
_0x12:
; 0000 00DC         {
; 0000 00DD             OCR0A=0x00;
	RCALL SUBOPT_0x0
; 0000 00DE             OCR0B=0xFF;
; 0000 00DF             OCR1AL=0x00;
; 0000 00E0             OCR1BL=0xFF;
; 0000 00E1             OCR2A=0x00;
; 0000 00E2             OCR2B=0xFF;
; 0000 00E3         }
_0x22:
; 0000 00E4     }
; 0000 00E5 
; 0000 00E6     if (sys_timer_cnt>138)
_0x11:
	LDI  R30,LOW(138)
	CP   R30,R3
	BRLO PC+2
	RJMP _0x23
; 0000 00E7     {
; 0000 00E8         sys_timer_cnt=0;
	CLR  R3
; 0000 00E9         if (mode>0)
	CPI  R18,1
	BRLO _0x24
; 0000 00EA         {
; 0000 00EB             if(cur_freq<freq || cur_freq>freq)
	LDD  R30,Y+6
	LDD  R26,Y+7
	CP   R26,R30
	BRLO _0x26
	CP   R30,R26
	BRSH _0x25
_0x26:
; 0000 00EC             {
; 0000 00ED                 accel_cnt=accel_cnt+ACCELERATION;
	LDD  R30,Y+5
	SUBI R30,-LOW(40)
	STD  Y+5,R30
; 0000 00EE                 if (accel_cnt>99)
	LDD  R26,Y+5
	CPI  R26,LOW(0x64)
	BRLO _0x28
; 0000 00EF                 {
; 0000 00F0                     accel_cnt=0;
	LDI  R30,LOW(0)
	STD  Y+5,R30
; 0000 00F1                     if (cur_freq<freq) {cur_freq++;} else {cur_freq--;}
	LDD  R30,Y+6
	LDD  R26,Y+7
	CP   R26,R30
	BRSH _0x29
	LDD  R30,Y+7
	SUBI R30,-LOW(1)
	RJMP _0x3E
_0x29:
	LDD  R30,Y+7
	SUBI R30,LOW(1)
_0x3E:
	STD  Y+7,R30
; 0000 00F2                     sinseg_period=240/cur_freq;
	LDI  R31,0
	LDI  R26,LOW(240)
	LDI  R27,HIGH(240)
	RCALL __DIVW21
	MOV  R19,R30
; 0000 00F3                     amp=cur_freq*1.4+30;
	LDD  R30,Y+7
	LDI  R31,0
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3FB33333
	RCALL __MULF12
	__GETD2N 0x41F00000
	RCALL __ADDF12
	RCALL SUBOPT_0x9
; 0000 00F4                     if (amp>100) amp=100;
	RCALL SUBOPT_0xA
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2B
	__GETD1N 0x42C80000
	RCALL SUBOPT_0x9
; 0000 00F5                     amplitude=amp/100;
_0x2B:
	RCALL SUBOPT_0xA
	RCALL __DIVF21
	RCALL SUBOPT_0x1
; 0000 00F6                 }
; 0000 00F7             }
_0x28:
; 0000 00F8         }
_0x25:
; 0000 00F9         else
	RJMP _0x2C
_0x24:
; 0000 00FA         {
; 0000 00FB             if (error>0)
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRLO _0x2D
; 0000 00FC             {
; 0000 00FD                  error_led_cnt++;
	LDD  R30,Y+3
	SUBI R30,-LOW(1)
	STD  Y+3,R30
; 0000 00FE                  if (error_led_cnt>error_led_period)
	LDD  R30,Y+2
	LDD  R26,Y+3
	CP   R30,R26
	BRSH _0x2E
; 0000 00FF                  {
; 0000 0100                     //ERROR_LED=!ERROR_LED;
; 0000 0101                     error_led_cnt=0;
	LDI  R30,LOW(0)
	STD  Y+3,R30
; 0000 0102                  }
; 0000 0103             }
_0x2E:
; 0000 0104             else
	RJMP _0x2F
_0x2D:
; 0000 0105             {
; 0000 0106                 if(REVERSE_BUT==0) {mode=MODE_RUN;direct=DIRECTION_REVERSE;}
	SBIC 0x6,0
	RJMP _0x30
	LDI  R18,LOW(1)
	SET
	BLD  R15,1
; 0000 0107                 if(FORWARD_BUT==0) {mode=MODE_RUN;direct=DIRECTION_FORWARD;}
_0x30:
	SBIC 0x9,1
	RJMP _0x31
	LDI  R18,LOW(1)
	CLT
	BLD  R15,1
; 0000 0108                 //  NORMAL_LED=1;
; 0000 0109             }
_0x31:
_0x2F:
; 0000 010A         }
_0x2C:
; 0000 010B         if(STOP_BUT==0)
	SBIC 0x9,0
	RJMP _0x32
; 0000 010C         {
; 0000 010D             if (mode==MODE_STOP)
	CPI  R18,0
	BREQ _0x34
; 0000 010E             {
; 0000 010F                 //overload_state=0;
; 0000 0110                 //crytycal_voltage=0;
; 0000 0111             }
; 0000 0112             else
; 0000 0113             {
; 0000 0114                 mode=MODE_BRAKE;
	LDI  R18,LOW(2)
; 0000 0115             }
_0x34:
; 0000 0116         }
; 0000 0117         slow_timer_cnt++;
_0x32:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0118         if (slow_timer_cnt==50)
	LD   R26,Y
	CPI  R26,LOW(0x32)
	BRNE _0x35
; 0000 0119         {
; 0000 011A             slow_timer_cnt=0;
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 011B             if (mode==MODE_BRAKE)
	CPI  R18,2
	BRNE _0x36
; 0000 011C             {
; 0000 011D                 freq=1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 011E                 if (cur_freq==1)  brake_cnt++;
	LDD  R26,Y+7
	CPI  R26,LOW(0x1)
	BRNE _0x37
	LDD  R30,Y+4
	SUBI R30,-LOW(1)
	STD  Y+4,R30
; 0000 011F 
; 0000 0120                 if (brake_cnt>BRAKE_PERIOD) {brake_cnt=0;mode=MODE_STOP;}
_0x37:
	LDD  R26,Y+4
	CPI  R26,LOW(0x3)
	BRLO _0x38
	LDI  R30,LOW(0)
	STD  Y+4,R30
	LDI  R18,LOW(0)
; 0000 0121             }
_0x38:
; 0000 0122             else
	RJMP _0x39
_0x36:
; 0000 0123             {
; 0000 0124                 freq=read_adc(FREQUENCY_ADC)/17+1;
	LDI  R26,LOW(7)
	RCALL _read_adc
	MOVW R26,R30
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RCALL __DIVW21U
	SUBI R30,-LOW(1)
	STD  Y+6,R30
; 0000 0125             }
_0x39:
; 0000 0126         }
; 0000 0127     }
_0x35:
; 0000 0128 
; 0000 0129 
; 0000 012A 
; 0000 012B }
_0x23:
	RJMP _0xE
; 0000 012C }
_0x3A:
	RJMP _0x3A
; .FEND
;

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x27,R30
	LDI  R30,LOW(255)
	OUT  0x28,R30
	LDI  R30,LOW(0)
	STS  136,R30
	LDI  R30,LOW(255)
	STS  138,R30
	LDI  R30,LOW(0)
	STS  179,R30
	LDI  R30,LOW(255)
	STS  180,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	__PUTD1S 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x3:
	SUBI R30,LOW(-_sineTable*2)
	SBCI R31,HIGH(-_sineTable*2)
	LPM  R26,Z
	LDI  R27,0
	SBRC R26,7
	SER  R27
	__GETD1S 13
	RCALL __CWD2
	RCALL __CDF2
	RCALL __MULF12
	__GETD2N 0x42FE0000
	RCALL __ADDF12
	RCALL __CFD1U
	MOV  R16,R30
	CPI  R16,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x4:
	MOVW R26,R28
	SUBI R26,LOW(-(89))
	SBCI R27,HIGH(-(89))
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	MOVW R26,R28
	ADIW R26,17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x5
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	MOV  R30,R21
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R31,0
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	__GETD2S 9
	__GETD1N 0x42C80000
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

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

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

;END OF CODE MARKER
__END_OF_CODE:
