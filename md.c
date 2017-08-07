<<<<<<< HEAD
#include <mega48.h>

// Declare your global variables here
 char d=0;
// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here
 d++;
}
interrupt [WDT] void wdt_timeout_isr(void)
=======
//початок Налаштування
#define DEAD_TIME_HALF      2   //Мертвий час (1 = 0.26 мкс)
#define ACCELERATION        40  //Прискорення  (Гц/сек)
#define NORM_VOLTAGE        512 // Нормальне значення робочої напруги в одиницях АЦП (Макс:1023)
#define MAX_BRAKE_VOLTAGE   562 // Максимальне допустипе значення напруги при гальмуванні в одиницях АЦП (Макс:1023)
#define CRYTYCAL_VOLTAGE    594 // Критичне значення напруги в одиницях АЦП (Макс:1023)
#define BRAKE_PERIOD        2 // Період гальмування двигуна (1/2 сек)
#define NORM_TEMP_DRIVER    200 // Нормальне значення температури драйвера в одиницях АЦП (Макс:1023)
#define MAX_TEMP_DRIVER     300 // Максимальне допустипе значення температури драйвера в одиницях АЦП (Макс:1023)


//Кінець налаштувань


#define SINE_TABLE_LENGTH   66 // Кількість значень в таблиці синусів
#define HALF_ST_LENGTH      33 // Кількість значень в таблиці синусів для напівперіода

#define DIRECTION_FORWARD       0 // Константа руху вперед
#define DIRECTION_REVERSE       1 // Константа руху назад

#define MODE_STOP      0 // режим "Зупинений"
#define MODE_RUN       1 // режим "Робота"
#define MODE_BRAKE     2 // режим "Гальмування"

#define ERROR_NO            0 // Помилки відчсутні
#define ERROR_POWER         1 // Відсутність живлення
#define ERROR_OVERVOLTAGE   2 // Перенапруга на конденсаторі
#define ERROR_OVERLOAD      3 // Перевантаження по струму
#define ERROR_DRIVERTEMP    4 // Перегрів драйвера
#define ERROR_MOTORTEMP     5 // Перегрів Двигуна

// Роспіновка
#define FORWARD_BUT     PIND.1  //  Кнопка запуску вперед
#define STOP_BUT        PIND.0  //  Кнопка зупинки
#define REVERSE_BUT     PINC.0  //  Кнопка запуску назад

#define POWER_SENS      PIND.2  // Пропажа сети - нормальное состояние лог.0, при лог.1 - сделать стоп привода, после появления лог.0 - выждать 4 секунды>зажечть светодиод PC2> разрешить генерацию. 
#define CAP_VOLTAGE     3       //ADC3 - пренапряжение силовой части ( больше +340В).С силового конденсатора через делитель заходит сигнал. Номинальное напряжение на порте 2,5В (310В) все что выше 2,75 (340В) является перенапряжением. В случае перенапряжения от 2,75 до 2,9В - приостанавливать торможение, до тех пор пока не упадет до 2,5В. В случае перенапряжения выше 2,9В - резко прекратить генерацию, на светодиод PC1 подать сигнал с частотой 3 Гц. Выйти из аварии через нажатие PD0. 
#define DRIVER_TEMP     4       //ADC4 - измерение перегрева силовой части. Согласно таблицам расчитать работы терморезистора. При перегреве выше 80 градусов. Сделать остановку привода, на светодиод PC1 подать сигнал с частотой 2Гц. Работу привода возобновить с охлаждением до 50 градусов. (Нужно запоминать значение аварии, что бы нельзя было сбить защиту путем включения, выключения привода) 
#define FREQUENCY_ADC   7       //ADC7 - регулировка частоты
#define NORMAL_LED      PORTC.1 // - светодиод индикации работы - начинает гореть спустя 4 секунды после (включения PD2) При включении генерации мигает с частотой 2 Гц. 
#define ERROR_LED       PORTC.2 // - светодиод индикации аварии
#define OVER_LOAD       PINB.4  // - сверхток - лог.0 (подтянут через 10К к 5В) - при подаче лог.0 на этот вывод - резко прекратить генерацию, на светодиод PC1 подать постоянный сигнал. Выйти из аварии через нажатие PD0. 
#define OVER_MOTORTEMP  PIND.4  // - Перегрев двигателя - нормальное состояние лог.0 при появлении лог.1. сделать стоп привода, подать на PC1 сигнал с частотой 1Гц. Разрешить работу только при появлении лог.0.


#include <mega48.h>
#include <md.h>
#include <delay.h>

// Declare your global variables here
volatile int out_cnt=0; // Лічильник імпульсів зовнішнього генератора
char p1l=0xFF,p1h=0x00,p2l=0xFF,p2h=0x00,p3l=0xFF,p3h=0x00; //Буфер для значень PWM
char sys_timer_cnt=0;// Лічильник системного таймера
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
>>>>>>> origin/master
{
// Place your code here
  PORTC.2=!PORTC.2;
}
void main(void)
{
<<<<<<< HEAD
// Declare your local variables here

// Crystal Oscillator division factor: 1
=======
volatile char tmp=0,tmpsin=0,tmptabpos=0,tmptabpos2=0;// Cлужбові
volatile char mode=0; //Режим роботи пристрою (0-стоп, 1-Робота, 2-Гальмування)
bit direct=0; // Напрям руху (0-вперед, 1-назад)
volatile int cur_period=0; // Поточний період для синусоїди
volatile char sinU=0,sinV=22,sinW=44; // Початкові значення здвигу по таблиці синусів
volatile signed char h_sin[SINE_TABLE_LENGTH],l_sin[SINE_TABLE_LENGTH]; // Поточна таблиця синусів
volatile char cur_freq=0;// діюча частота двигуна
volatile char freq=0;// встановлена частота двигуна 
volatile char calc_sine_cnt=0;// Кількість прорахованих значень синуса 
volatile char amp_freq=0;// Частота для виборуамплітуди 
char accel_cnt=0;// Лічильник прискорення 
char brake_cnt=0;// Лічильник гальмування 
char error_led_cnt=0; // Лічильник індикації помилки
char error_led_period=0; // Період індикації помилки
char error=0; // Помилка
char slow_timer_cnt=0; // таймер для не критичних процесів
>>>>>>> origin/master
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif
<<<<<<< HEAD

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T 
=======
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
>>>>>>> origin/master
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
<<<<<<< HEAD

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

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
// OC1A Period: 0,06375 ms Width: 3,75 us
// OC1B Period: 0,06375 ms Width: 0,06375 ms
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
=======
TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (1<<COM0B1) | (1<<COM0B0) | (0<<WGM01) | (1<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;
>>>>>>> origin/master
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
<<<<<<< HEAD
OCR1AL=100;
OCR1BH=0x00;
OCR1BL=150;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Phase correct PWM top=0xFF
// OC2A output: Non-Inverted PWM
// OC2B output: Inverted PWM
// Timer Period: 0,06375 ms
// Output Pulse(s):
// OC2A Period: 0,06375 ms Width: 0 us
// OC2B Period: 0,06375 ms Width: 0,06375 ms
=======
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
>>>>>>> origin/master
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (1<<COM2B0) | (0<<WGM21) | (1<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;
<<<<<<< HEAD

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (1<<OCIE1A) | (0<<TOIE1);

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
=======
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
EICRA=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (1<<INT0);
EIFR=(0<<INTF1) | (1<<INTF0);
>>>>>>> origin/master
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
ADCSRB=(0<<ACME);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

<<<<<<< HEAD
// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2k
// Watchdog timeout action: Interrupt
#pragma optsize-
WDTCSR=(0<<WDIF) | (0<<WDIE) | (0<<WDP3) | (1<<WDCE) | (0<<WDE) | (0<<WDP2) | (0<<WDP1) | (0<<WDP0);
WDTCSR=(1<<WDIF) | (1<<WDIE) | (0<<WDP3) | (0<<WDCE) | (0<<WDE) | (0<<WDP2) | (0<<WDP1) | (0<<WDP0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

=======
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
>>>>>>> origin/master
// Global enable interrupts
#asm("sei")

while (1)
<<<<<<< HEAD
      {
      // Place your code here

      }
}
=======
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
>>>>>>> origin/master
