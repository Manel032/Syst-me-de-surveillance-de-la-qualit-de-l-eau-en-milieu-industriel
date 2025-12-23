#line 1 "C:/micro v001/eau.c"




sbit LCD_RS at RC0_bit;
sbit LCD_EN at RC1_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;

sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_EN_Direction at TRISC1_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;
#line 87 "C:/micro v001/eau.c"
unsigned char system_state;
unsigned char previous_state;
unsigned int alert_count;
unsigned char current_quality_state;
unsigned int adc_temp;
unsigned int adc_ph;
char txt_buffer[17];
char txt_temp[7];
char txt_ph[7];




unsigned int temp_min_threshold;
unsigned int temp_max_threshold;
unsigned int ph_min_threshold;
unsigned int ph_max_threshold;







void init_system(void);
void clear_all_outputs(void);
void wait_button_release(void);
unsigned char check_buttons(void);
void read_sensors(void);
unsigned char is_quality_good(void);
unsigned char blink_all_leds_with_check(void);
void blink_green_3_times_3sec(void);
void blink_green_5_times(void);
void blink_red_and_buzzer(void);
void state_veille(void);
void state_demarrage(void);
void display_qualite(void);
void display_mediocre(void);
void check_quality(void);
void state_consultation(void);
void state_intervention(void);




void EEPROM_WriteInt(unsigned char addr_lo, unsigned int value);
unsigned int EEPROM_ReadInt(unsigned char addr_lo);
void EEPROM_InitializeDefaults(void);
void EEPROM_SaveAlertCount(void);
void EEPROM_ClearAlertCount(void);
void EEPROM_LoadThresholds(void);





void EEPROM_WriteInt(unsigned char addr_lo, unsigned int value) {



 EEPROM_Write(addr_lo, value & 0xFF);
 Delay_ms(20);





 EEPROM_Write(addr_lo + 1, (value >> 8) & 0xFF);
 Delay_ms(20);

}







unsigned int EEPROM_ReadInt(unsigned char addr_lo) {
 unsigned int low_byte, high_byte;

 low_byte = EEPROM_Read(addr_lo);
 high_byte = EEPROM_Read(addr_lo + 1);




 return (high_byte << 8) | low_byte;
}






void EEPROM_InitializeDefaults(void) {




 EEPROM_WriteInt( 0x01 ,  35 );
 EEPROM_WriteInt( 0x03 ,  45 );
 EEPROM_WriteInt( 0x05 ,  300 );
 EEPROM_WriteInt( 0x07 ,  315 );




 EEPROM_WriteInt( 0x10 , 0);





 EEPROM_Write( 0x00 ,  0xAA );
 Delay_ms(20);


}





void EEPROM_SaveAlertCount(void) {
 EEPROM_WriteInt( 0x10 , alert_count);
}





void EEPROM_ClearAlertCount(void) {
 alert_count = 0;
 EEPROM_WriteInt( 0x10 , 0);
}








void EEPROM_LoadThresholds(void) {
 temp_min_threshold = EEPROM_ReadInt( 0x01 );
 temp_max_threshold = EEPROM_ReadInt( 0x03 );
 ph_min_threshold = EEPROM_ReadInt( 0x05 );
 ph_max_threshold = EEPROM_ReadInt( 0x07 );
}






void init_system(void) {




 ADCON1 = 0x80;





 TRISA = 0xFF;
 TRISB = 0xFF;





 OPTION_REG &= 0x7F;





 TRISC = 0x00; PORTC = 0x00;
 TRISD = 0x00; PORTD = 0x00;






 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);





 ADC_Init();
 Delay_ms(100);




 if (EEPROM_Read( 0x00 ) !=  0xAA ) {


 EEPROM_InitializeDefaults();
 }



 EEPROM_LoadThresholds();



 alert_count = EEPROM_ReadInt( 0x10 );




 system_state =  0 ;
 previous_state =  0 ;
 current_quality_state = 0;
}





void wait_button_release(void) {
 while ( PORTB.F0  == 0 ||  PORTB.F5  == 0 ||  PORTB.F6  == 0 ||  PORTB.F7  == 0) {
 Delay_ms(10);
 }
 Delay_ms(50);
}

unsigned char check_buttons(void) {
 if ( PORTB.F6  == 0) {
 Delay_ms(50);
 if ( PORTB.F6  == 0) { wait_button_release(); return 6; }

 }
 if ( PORTB.F0  == 0) {
 Delay_ms(50);
 if ( PORTB.F0  == 0) { wait_button_release(); return 1; }

 }
 if ( PORTB.F5  == 0) {
 Delay_ms(50);
 if ( PORTB.F5  == 0) { wait_button_release(); return 5; }

 }
 if ( PORTB.F7  == 0) {
 Delay_ms(50);
 if ( PORTB.F7  == 0) { wait_button_release(); return 7; }

 }
 return 0;
}




void read_sensors(void) {
 Delay_ms(5);
 adc_temp = ADC_Read(0);
 Delay_ms(20);
 Delay_ms(5);
 adc_ph = ADC_Read(1);
}

unsigned char is_quality_good(void) {
 read_sensors();



 if ((adc_temp >= temp_min_threshold && adc_temp <= temp_max_threshold) &&
 (adc_ph >= ph_min_threshold && adc_ph <= ph_max_threshold))
 return 1;
 return 0;
}




void clear_all_outputs(void) {
  PORTC.F3  = 0;
  PORTC.F4  = 0;
  PORTC.F5  = 0;
  PORTD.F0  = 0;
}

unsigned char blink_all_leds_with_check(void) {
 unsigned char i, btn;

  PORTC.F3  = 1;  PORTC.F4  = 1;  PORTC.F5  = 1;
 for (i = 0; i < 10; i++) {
 Delay_ms(25);
 btn = check_buttons();
 if (btn) { clear_all_outputs(); return btn; }
 }

 clear_all_outputs();
 for (i = 0; i < 10; i++) {
 Delay_ms(25);
 btn = check_buttons();
 if (btn) return btn;
 }

 return 0;
}

void blink_green_3_times_3sec(void) {
 unsigned char i;
 clear_all_outputs();
 for (i = 0; i < 3; i++) {
  PORTC.F3  = 1; Delay_ms(500);
  PORTC.F3  = 0; Delay_ms(500);
 }
}

void blink_green_5_times(void) {
 unsigned char i;
 clear_all_outputs();
 for (i = 0; i < 5; i++) {
  PORTC.F3  = 1; Delay_ms(250);
  PORTC.F3  = 0; Delay_ms(250);
 }
}

void blink_red_and_buzzer(void) {
  PORTC.F4  = 1;  PORTD.F0  = 1; Delay_ms(200);
  PORTC.F4  = 0;  PORTD.F0  = 0; Delay_ms(200);
}




void state_veille(void) {
 unsigned char btn;

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"systeme en");
 Lcd_Out(2,1,"veille");

 while (system_state ==  0 ) {
 btn = blink_all_leds_with_check();
 if (btn == 1) system_state =  1 ;
 else if (btn == 7) system_state =  4 ;
 else if (btn == 5) system_state =  5 ;
 else if (btn == 6) {




 EEPROM_ClearAlertCount();
 current_quality_state = 0;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"systeme en");
 Lcd_Out(2,1,"veille");
 }
 }
}


void state_demarrage(void) {
 clear_all_outputs();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"systeme");
 Lcd_Out(2,1,"demarre");
 blink_green_3_times_3sec();

 system_state =  2 ;
 current_quality_state = 1;
}

void display_qualite(void) {
 unsigned char btn, q;
 clear_all_outputs();

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Eau de");
 Lcd_Out(2,1,"qualite");
  PORTC.F3  = 1;
 current_quality_state = 1;

 while (system_state ==  2 ) {
 q = is_quality_good();
 if (q == 0) {
 alert_count++;
 EEPROM_SaveAlertCount();
 current_quality_state = 0;
 system_state =  3 ;
 return;
 }

 btn = check_buttons();
 if (btn == 6) {
 EEPROM_ClearAlertCount();
 system_state =  0 ;
 return;
 }
 if (btn == 7) { system_state =  4 ; return; }
 if (btn == 5) { system_state =  5 ; return; }

 Delay_ms(100);
 }
}

void display_mediocre(void) {
 unsigned char btn, q;
 clear_all_outputs();

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Eau");
 Lcd_Out(2,1,"mediocre");
 current_quality_state = 0;

 while (system_state ==  3 ) {
 blink_red_and_buzzer();
 q = is_quality_good();

 if (q == 1) {
 current_quality_state = 1;
 system_state =  2 ;
 return;
 }

 btn = check_buttons();
 if (btn == 6) {
 EEPROM_ClearAlertCount();
 system_state =  0 ;
 return;
 }
 if (btn == 7) { system_state =  4 ; return; }
 if (btn == 5) { system_state =  5 ; return; }
 }
}

void check_quality(void) {
 unsigned char q = is_quality_good();

 if (q == 1) {
 system_state =  2 ;
 current_quality_state = 1;
 } else {
 alert_count++;
 EEPROM_SaveAlertCount();
 system_state =  3 ;
 current_quality_state = 0;
 }

 while (system_state ==  2  || system_state ==  3 ) {
 if (system_state ==  2 ) display_qualite();
 else display_mediocre();
 }
}




void state_consultation(void) {
 unsigned char btn;
 unsigned int last_alert_value;

 clear_all_outputs();

 IntToStr(alert_count, txt_buffer);
 Ltrim(txt_buffer);
 last_alert_value = alert_count;

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Alerte");
 Lcd_Out(2,1,txt_buffer);
 Lcd_Out_CP(" alertes");

 while (system_state ==  4 ) {




 {
 unsigned char q = is_quality_good();

 if (q == 0 && current_quality_state == 1) {
 alert_count++;
 EEPROM_SaveAlertCount();
 current_quality_state = 0;
 last_alert_value = 9999;
 }
 else if (q == 1 && current_quality_state == 0) {
 current_quality_state = 1;
 }
 }





 if (alert_count != last_alert_value) {
 last_alert_value = alert_count;
 IntToStr(alert_count, txt_buffer);
 Ltrim(txt_buffer);

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Alerte");
 Lcd_Out(2,1,txt_buffer);
 Lcd_Out_CP(" alertes");
 }




 btn = check_buttons();
 if (btn == 6) {
 EEPROM_ClearAlertCount();
 system_state =  0 ;
 return;
 }
 if (btn == 1) { system_state =  1 ; return; }
 if (btn == 5) { system_state =  5 ; return; }


 if (btn == 7) { }

 Delay_ms(5);
 }
}




void state_intervention(void) {
 unsigned char btn;
 unsigned int i;

 clear_all_outputs();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"prob");
 Lcd_Out(2,1,"resolu");

 blink_green_5_times();

 for (i = 0; i < 50; i++) {
 Delay_ms(100);
 btn = check_buttons();

 if (btn == 1) { system_state =  1 ; return; }
 if (btn == 6) {
 EEPROM_ClearAlertCount();
 system_state =  0 ;
 return;
 }
 if (btn == 7) { system_state =  4 ; return; }
 }

 system_state =  0 ;
}







void main() {
 init_system();

 while (1) {

 if (system_state !=  0 ) {
 unsigned char q = is_quality_good();

 if (q == 0 && current_quality_state == 1) {
 alert_count++;
 EEPROM_SaveAlertCount();
 current_quality_state = 0;
 system_state =  3 ;
 }
 else if (q == 1 && current_quality_state == 0) {
 current_quality_state = 1;
 system_state =  2 ;
 }
 }

 switch (system_state) {


 case  0 :
 clear_all_outputs();





 current_quality_state = 0;
 state_veille();
 break;

 case  1 :
 state_demarrage();
 check_quality();
 break;

 case  2 :
 case  3 :
 check_quality();
 break;

 case  4 :
 state_consultation();
 break;

 case  5 :
 state_intervention();
 break;

 default:
 system_state =  0 ;
 break;
 }
 }
}
