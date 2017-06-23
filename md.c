//������� ������������
#define DEAD_TIME_HALF      2   //������� ��� (1 = 0.26 ���)
#define ACCELERATION        40  //�����������  (��/���)
#define NORM_VOLTAGE        512 // ��������� �������� ������ ������� � �������� ��� (����:1023)
#define MAX_BRAKE_VOLTAGE   562 // ����������� ��������� �������� ������� ��� ���������� � �������� ��� (����:1023)
#define CRYTYCAL_VOLTAGE    594 // �������� �������� ������� � �������� ��� (����:1023)
#define BRAKE_PERIOD        2 // ����� ����������� ������� (1/2 ���)
#define NORM_TEMP_DRIVER    200 // ��������� �������� ����������� �������� � �������� ��� (����:1023)
#define MAX_TEMP_DRIVER     300 // ����������� ��������� �������� ����������� �������� � �������� ��� (����:1023)


//ʳ���� �����������


#define SINE_TABLE_LENGTH   66 // ʳ������ ������� � ������� ������
#define HALF_ST_LENGTH      33 // ʳ������ ������� � ������� ������ ��� ����������

#define DIRECTION_FORWARD       0 // ��������� ���� ������
#define DIRECTION_REVERSE       1 // ��������� ���� �����

#define MODE_STOP      0 // ����� "���������"
#define MODE_RUN       1 // ����� "������"
#define MODE_BRAKE     2 // ����� "�����������"

#define ERROR_NO            0 // ������� �������
#define ERROR_POWER         1 // ³�������� ��������
#define ERROR_OVERVOLTAGE   2 // ����������� �� �����������
#define ERROR_OVERLOAD      3 // �������������� �� ������
#define ERROR_DRIVERTEMP    4 // ������� ��������
#define ERROR_MOTORTEMP     5 // ������� �������

// ���������
#define FORWARD_BUT     PIND.1  //  ������ ������� ������
#define STOP_BUT        PIND.0  //  ������ �������
#define REVERSE_BUT     PINC.0  //  ������ ������� �����

#define POWER_SENS      PIND.2  // ������� ���� - ���������� ��������� ���.0, ��� ���.1 - ������� ���� �������, ����� ��������� ���.0 - ������� 4 �������>������� ��������� PC2> ��������� ���������. 
#define CAP_VOLTAGE     3       //ADC3 - ������������� ������� ����� ( ������ +340�).� �������� ������������ ����� �������� ������� ������. ����������� ���������� �� ����� 2,5� (310�) ��� ��� ���� 2,75 (340�) �������� ���������������. � ������ �������������� �� 2,75 �� 2,9� - ���������������� ����������, �� ��� ��� ���� �� ������ �� 2,5�. � ������ �������������� ���� 2,9� - ����� ���������� ���������, �� ��������� PC1 ������ ������ � �������� 3 ��. ����� �� ������ ����� ������� PD0. 
#define DRIVER_TEMP     4       //ADC4 - ��������� ��������� ������� �����. �������� �������� ��������� ������ ��������������. ��� ��������� ���� 80 ��������. ������� ��������� �������, �� ��������� PC1 ������ ������ � �������� 2��. ������ ������� ����������� � ����������� �� 50 ��������. (����� ���������� �������� ������, ��� �� ������ ���� ����� ������ ����� ���������, ���������� �������) 
#define FREQUENCY_ADC   7       //ADC7 - ����������� �������
#define NORMAL_LED      PORTC.1 // - ��������� ��������� ������ - �������� ������ ������ 4 ������� ����� (��������� PD2) ��� ��������� ��������� ������ � �������� 2 ��. 
#define ERROR_LED       PORTC.2 // - ��������� ��������� ������
#define OVER_LOAD       PINB.4  // - �������� - ���.0 (�������� ����� 10� � 5�) - ��� ������ ���.0 �� ���� ����� - ����� ���������� ���������, �� ��������� PC1 ������ ���������� ������. ����� �� ������ ����� ������� PD0. 
#define OVER_MOTORTEMP  PIND.4  // - �������� ��������� - ���������� ��������� ���.0 ��� ��������� ���.1. ������� ���� �������, ������ �� PC1 ������ � �������� 1��. ��������� ������ ������ ��� ��������� ���.0.


#include <mega48.h>
#include <md.h>
#include <delay.h>

// Declare your global variables here
volatile int out_cnt=0; // ˳������� �������� ���������� ����������
char p1l=0xFF,p1h=0x00,p2l=0xFF,p2h=0x00,p3l=0xFF,p3h=0x00; //����� ��� ������� PWM
char sys_timer_cnt=0;// ˳������� ���������� �������
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    out_cnt++;
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    OCR0A=p1h;
    OCR0B=p1l;
    OCR1AL=p2h;
    OCR1BL=p2l;
    OCR2A=p3h;
    OCR2B=p3l; 
    sys_timer_cnt++;
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
volatile char tmp=0,tmpsin=0,tmptabpos=0,tmptabpos2=0;// C������
volatile char mode=0; //����� ������ �������� (0-����, 1-������, 2-�����������)
bit direct=0; // ������ ���� (0-������, 1-�����)
volatile int cur_period=0; // �������� ����� ��� ��������
volatile char sinU=0,sinV=22,sinW=44; // �������� �������� ������ �� ������� ������
volatile signed char h_sin[SINE_TABLE_LENGTH],l_sin[SINE_TABLE_LENGTH]; // ������� ������� ������
volatile char cur_freq=0;// ���� ������� �������
volatile char freq=0;// ����������� ������� ������� 
volatile char calc_sine_cnt=0;// ʳ������ ������������ ������� ������ 
volatile char amp_freq=0;// ������� ��� �������������� 
char accel_cnt=0;// ˳������� ����������� 
char brake_cnt=0;// ˳������� ����������� 
char error_led_cnt=0; // ˳������� ��������� �������
char error_led_period=0; // ����� ��������� �������
char error=0; // �������
char slow_timer_cnt=0; // ������ ��� �� ��������� �������
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (0<<DDC0);
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (1<<COM0B1) | (1<<COM0B0) | (0<<WGM01) | (1<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (0<<WGM21) | (1<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
EICRA=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (1<<INT0);
EIFR=(0<<INTF1) | (1<<INTF0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
DIDR1=(0<<AIN0D) | (0<<AIN1D);
DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

for (tmp=0;tmp<SINE_TABLE_LENGTH;tmp++)
 {
    if (tmp<HALF_ST_LENGTH)
    {
        
        tmpsin=127+sineTable[0][tmptabpos];
        tmptabpos++;
    } 
    else
    {
       tmpsin=127-sineTable[0][tmptabpos2];  
       tmptabpos2++;
    }
    
    if (tmpsin <= DEAD_TIME_HALF)
    {
        h_sin[tmp] = 0x00;
        l_sin[tmp] = tmpsin;
    }
    else if (tmpsin >= (0xff - DEAD_TIME_HALF))
    {
        h_sin[tmp] = 0xff - (2 * DEAD_TIME_HALF);
        l_sin[tmp] = 0xff;
    }
    else
    {
        h_sin[tmp] = tmpsin - DEAD_TIME_HALF;
        l_sin[tmp] = tmpsin + DEAD_TIME_HALF;
    }
 }
 tmptabpos2=0;
 tmptabpos=0;
cur_period=period_table[1];
mode=1;
freq=60;
// Global enable interrupts
#asm("sei")

while (1)
{
    tmpsin=3;
    if (out_cnt>cur_period)
    { 
        out_cnt=0;
        if (mode>0 ) 
        {
            sinU++;
            sinV++;
            sinW++; 
            if (sinU==SINE_TABLE_LENGTH) sinU=0;  
            if (sinV==SINE_TABLE_LENGTH) sinV=0; 
            if (sinW==SINE_TABLE_LENGTH) sinW=0;  
            p1h = h_sin[sinU];
            p1l = l_sin[sinU];
            if (direct == DIRECTION_FORWARD)
            {
                p2h = h_sin[sinW];
                p2l = l_sin[sinW];
                p3h = h_sin[sinV];
                p3l = l_sin[sinV];
            }
            else
            {
                p2h = h_sin[sinV];
                p2l = l_sin[sinV];
                p3h = h_sin[sinW];
                p3l = l_sin[sinW];
            }  
            NORMAL_LED=!NORMAL_LED;    
            NORMAL_LED=!NORMAL_LED;
        }
        else
        {
            p1l=0xFF; p1h=0x00; p2l=0xFF; p2h=0x00; p3l=0xFF; p3h=0x00; 
        } 
        if (calc_sine_cnt<=SINE_TABLE_LENGTH)
        {  
            amp_freq=cur_freq-1;
            if (amp_freq>49) amp_freq=49;
            calc_sine_cnt++;
            if (sinU<HALF_ST_LENGTH)
            {
                
                tmpsin=127+sineTable[amp_freq][tmptabpos];
                tmptabpos++; 
                tmptabpos2=0;
            } 
            else
            {
               tmpsin=127-sineTable[amp_freq][tmptabpos2];  
               tmptabpos2++;
               tmptabpos=0;
            }
            
            if (tmpsin <= DEAD_TIME_HALF)
            {
                h_sin[sinU] = 0x00;
                l_sin[sinU] = tmpsin;
            }
            else if (tmpsin >= (0xff - DEAD_TIME_HALF))
            {
                h_sin[sinU] = 0xff - (2 * DEAD_TIME_HALF);
                l_sin[sinU] = 0xff;
            }
            else
            {
                h_sin[sinU] = tmpsin - DEAD_TIME_HALF;
                l_sin[sinU] = tmpsin + DEAD_TIME_HALF;
            }
        }     
               
    }
    else
    {
        if (sys_timer_cnt>138) 
        {
            sys_timer_cnt=0;
            if (mode>0)
            { 
                if(cur_freq<freq || cur_freq>freq)
                {
                    accel_cnt=accel_cnt+ACCELERATION;
                    if (accel_cnt>99) 
                    {
                        accel_cnt=0; 
                        if (cur_freq<freq) {cur_freq++;} else {cur_freq--;}
                        cur_period=period_table[cur_freq];
                        if (cur_freq<51) calc_sine_cnt=0; 
                    }
                }
            } 
            else
            {  
                if (error>0)
                {
                     error_led_cnt++;
                     if (error_led_cnt>error_led_period) 
                     {  
                        //ERROR_LED=!ERROR_LED;
                        error_led_cnt=0;  
                     }       
                }
                else
                {
                    //if(REVERSE_BUT==0) {mode=MODE_RUN;direct=DIRECTION_REVERSE;}
                    //if(FORWARD_BUT==0) {mode=MODE_RUN;direct=DIRECTION_FORWARD;} 
                    //  NORMAL_LED=1;
                } 
            }  
            if(STOP_BUT==0)
            { 
                if (mode==MODE_STOP)
                {
                    //overload_state=0;
                    //crytycal_voltage=0;    
                }
                else
                {
                   // mode=MODE_BRAKE; 
                }    
            }  
            slow_timer_cnt++;
            if (slow_timer_cnt==50) 
            {
                slow_timer_cnt=0;  
                if (mode==MODE_BRAKE)
                {
                    freq=1;
                    if (cur_freq==1)  brake_cnt++;
                        
                    if (brake_cnt>BRAKE_PERIOD) {brake_cnt=0;mode=MODE_STOP;}
                }
                else
                { 
                   // freq=read_adc(FREQUENCY_ADC)/17+1;  
                } 
            }
        }        
    }
}
}
