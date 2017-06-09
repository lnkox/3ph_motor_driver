/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 08.06.2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega48
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 128
*******************************************************/
#define DEAD_TIME_HALF 2 
#define SINE_TABLE_LENGTH 192

#define DIRECTION_FORWARD       0
#define DIRECTION_REVERSE       1

#define start_but PIND.1
#define stop_but PIND.0
#define revers_but PINC.5

#include <mega48.h>

#include <delay.h>
#include <md.h>

void InsertDeadband(char compareValue, char * compareHighPtr, char * compareLowPtr);
void gen_next_sinpos(void);    
void off_pwm(void);
// Declare your global variables here
char mode=0;
char ph0a=0,ph0b=0,ph1a=0,ph1b=0,ph2a=0,ph2b=0;
int sinpos=0;
int direct=0;
float amplitude=0;
int sinseg_period=0,sinseg=0;
long map(long x, long in_min, long in_max, long out_min, long out_max)
{
  return ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min);
}
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
 sinseg++;
 if (sinseg>=sinseg_period) 
 {
    sinseg=0; 
    if (amplitude==0 || mode==0){off_pwm();} else {gen_next_sinpos();}
    
 
 }
    OCR0A=ph0a;OCR0B=ph0b;OCR1AL=ph1a;OCR1BL=ph1b;OCR2A=ph2a;OCR2B=ph2b;   
   
}

void gen_next_sinpos(void)
{
    char tempU,tempV,tempW; 
    char compareHigh, compareLow;
    int tsp; 
    sinpos++;
    if (sinpos==SINE_TABLE_LENGTH) sinpos=0;   
    tsp=sinpos*3;
    tempU=sineTable[tsp]*amplitude;
    if (direct == DIRECTION_FORWARD)
    {
        tempV = sineTable[tsp+1]*amplitude;
        tempW = sineTable[tsp+2]*amplitude;
    }
    else
    {
        tempW = sineTable[tsp+1]*amplitude;
        tempV = sineTable[tsp+2]*amplitude;
    }  
    
    InsertDeadband(tempU, &compareHigh, &compareLow);
    ph0a = compareHigh;
    ph0b = compareLow;

    InsertDeadband(tempV, &compareHigh, &compareLow);
    ph1a = compareHigh;
    ph1b = compareLow;

    InsertDeadband(tempW, &compareHigh, &compareLow);
    ph2a = compareHigh;
    ph2b = compareLow;
}

void InsertDeadband(char compareValue, char * compareHighPtr, char * compareLowPtr)   //вставка метвого часу
{
  if (compareValue <= DEAD_TIME_HALF)
  {
    *compareHighPtr = 0x00;
    *compareLowPtr = compareValue;
  }
  else if (compareValue >= (0xff - DEAD_TIME_HALF))
  {
    *compareHighPtr = 0xff - (2 * DEAD_TIME_HALF);
    *compareLowPtr = 0xff;
  }
  else
  {
    *compareHighPtr = compareValue - DEAD_TIME_HALF;
    *compareLowPtr = compareValue + DEAD_TIME_HALF;
  }
}

void set_freq(int freq)
{
   float amp;
   if (freq==0) {amplitude=0; return;}   
   sinseg_period=124/freq; 
   amp=map(freq,1,60,30,100); 
   amplitude=amp/100;    
   
}
void off_pwm(void)
{
    OCR0A=0x00;
    OCR0B=0xFF;
    OCR1AL=0x00;
    OCR1BL=0xFF;
    OCR2A=0x00;
    OCR2B=0xFF;
}
// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

void main(void)
{
// Declare your local variables here
int adcv=0;
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=Out Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=0 Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Phase correct PWM top=0xFF
// OC0A output: Non-Inverted PWM
// OC0B output: Inverted PWM
// Timer Period: 0,06375 ms
// Output Pulse(s):
// OC0A Period: 0,06375 ms Width: 0 us// OC0B Period: 0,06375 ms Width: 0,06375 ms
TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (1<<COM0B1) | (1<<COM0B0) | (0<<WGM01) | (1<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0xFF;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Ph. correct PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0,06375 ms
// Output Pulse(s):
// OC1A Period: 0,06375 ms Width: 0 us// OC1B Period: 0,06375 ms Width: 0,06375 ms
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0xFF;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Phase correct PWM top=0xFF
// OC2A output: Non-Inverted PWM
// OC2B output: Inverted PWM
// Timer Period: 0,06375 ms
// Output Pulse(s):
// OC2A Period: 0,06375 ms Width: 0 us// OC2B Period: 0,06375 ms Width: 0,06375 ms
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (0<<WGM21) | (1<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0xFF;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (0<<INT0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

// USART initialization
// USART disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC Clock frequency: 62,500 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
// ADC4: On, ADC5: On
DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
TCNT0=0;
TCNT1L=2;
TCNT2=5;
#asm("sei")
      set_freq(1);
while (1)
      {
      // Place your code here

       delay_ms(5);
       if (start_but==0) mode=1;
       if (stop_but==0) mode=0;
       if (revers_but==0) {direct=!direct;delay_ms(500);}    
       adcv=map( read_adc(7),0,1023,0,60);
       set_freq(adcv);     
       OCR1AH=adcv;
      }
}
