

//        LCD PIN DEFINITIONS

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




//       OUTPUT PIN DEFINITIONS


#define LED_GREEN   PORTC.F3
#define LED_RED     PORTC.F4
#define LED_YELLOW  PORTC.F5
#define BUZZER      PORTD.F0




//       INPUT PIN DEFINITIONS

#define BTN_START   PORTB.F0
#define BTN_INTERV  PORTB.F5
#define BTN_RESET   PORTB.F6
#define BTN_CONSULT PORTB.F7




//         SYSTEM STATES

#define STATE_VEILLE        0
#define STATE_RUNNING       1
#define STATE_QUALITE       2
#define STATE_MEDIOCRE      3
#define STATE_CONSULTATION  4
#define STATE_INTERVENTION  5




//  EEPROM ADDRESS MAP

#define EEPROM_INIT_FLAG_ADDR     0x00    // Initialization flag location
#define EEPROM_TEMP_MIN_LO        0x01    // Temperature min threshold (low byte)
#define EEPROM_TEMP_MIN_HI        0x02    // Temperature min threshold (high byte)
#define EEPROM_TEMP_MAX_LO        0x03    // Temperature max threshold (low byte)
#define EEPROM_TEMP_MAX_HI        0x04    // Temperature max threshold (high byte)
#define EEPROM_PH_MIN_LO          0x05    // pH min threshold (low byte)
#define EEPROM_PH_MIN_HI          0x06    // pH min threshold (high byte)
#define EEPROM_PH_MAX_LO          0x07    // pH max threshold (low byte)
#define EEPROM_PH_MAX_HI          0x08    // pH max threshold (high byte)
#define EEPROM_ALERT_COUNT_LO     0x10    // Alert count (low byte)
#define EEPROM_ALERT_COUNT_HI     0x11    // Alert count (high byte)

#define EEPROM_INITIALIZED        0xAA    // EEPROM has been initialized




//  DEFAULT THRESHOLD VALUES


#define DEFAULT_TEMP_MIN  35
#define DEFAULT_TEMP_MAX  45
#define DEFAULT_PH_MIN    300
#define DEFAULT_PH_MAX    315




//        GLOBAL VARIABLES

unsigned char system_state;
unsigned char previous_state;
unsigned int alert_count;
unsigned char current_quality_state;
unsigned int adc_temp;
unsigned int adc_ph;
char txt_buffer[17];
char txt_temp[7];
char txt_ph[7];


// Threshold variables - now loaded from EEPROM instead of being constants

unsigned int temp_min_threshold;
unsigned int temp_max_threshold;
unsigned int ph_min_threshold;
unsigned int ph_max_threshold;


//       FUNCTION PROTOTYPES


// Original functions (unchanged signatures)

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


// EEPROM functions

void EEPROM_WriteInt(unsigned char addr_lo, unsigned int value);
unsigned int EEPROM_ReadInt(unsigned char addr_lo);
void EEPROM_InitializeDefaults(void);
void EEPROM_SaveAlertCount(void);
void EEPROM_ClearAlertCount(void);
void EEPROM_LoadThresholds(void);



// EEPROM_WriteInt

void EEPROM_WriteInt(unsigned char addr_lo, unsigned int value) {

    // Write low byte (bits 0-7)

    EEPROM_Write(addr_lo, value & 0xFF);
    Delay_ms(20);  // EEPROM write cycle requires time to complete



    // Write high byte (bits 8-15)

    EEPROM_Write(addr_lo + 1, (value >> 8) & 0xFF);
    Delay_ms(20);  // EEPROM write cycle requires time to complete

}




// EEPROM_ReadInt


unsigned int EEPROM_ReadInt(unsigned char addr_lo) {
    unsigned int low_byte, high_byte;

    low_byte = EEPROM_Read(addr_lo);
    high_byte = EEPROM_Read(addr_lo + 1);


    // Reconstruct 16-bit value: high byte shifted left 8 bits, OR with low byte

    return (high_byte << 8) | low_byte;
}



// EEPROM_InitializeDefaults


void EEPROM_InitializeDefaults(void) {


    // Write default threshold values to EEPROM

    EEPROM_WriteInt(EEPROM_TEMP_MIN_LO, DEFAULT_TEMP_MIN);
    EEPROM_WriteInt(EEPROM_TEMP_MAX_LO, DEFAULT_TEMP_MAX);
    EEPROM_WriteInt(EEPROM_PH_MIN_LO, DEFAULT_PH_MIN);
    EEPROM_WriteInt(EEPROM_PH_MAX_LO, DEFAULT_PH_MAX);


    // Initialize alert count to zero

    EEPROM_WriteInt(EEPROM_ALERT_COUNT_LO, 0);



    // Set initialization flag so we don't reinitialize on next power-up

    EEPROM_Write(EEPROM_INIT_FLAG_ADDR, EEPROM_INITIALIZED);
    Delay_ms(20);


}



// EEPROM_SaveAlertCount

void EEPROM_SaveAlertCount(void) {
    EEPROM_WriteInt(EEPROM_ALERT_COUNT_LO, alert_count);
}



// EEPROM_ClearAlertCount

void EEPROM_ClearAlertCount(void) {
    alert_count = 0;
    EEPROM_WriteInt(EEPROM_ALERT_COUNT_LO, 0);
}





// EEPROM_LoadThresholds


void EEPROM_LoadThresholds(void) {
    temp_min_threshold = EEPROM_ReadInt(EEPROM_TEMP_MIN_LO);
    temp_max_threshold = EEPROM_ReadInt(EEPROM_TEMP_MAX_LO);
    ph_min_threshold = EEPROM_ReadInt(EEPROM_PH_MIN_LO);
    ph_max_threshold = EEPROM_ReadInt(EEPROM_PH_MAX_LO);
}



// INITIALIZATION


void init_system(void) {


    // Configure ADC: Right justified result, all analog inputs

    ADCON1 = 0x80;



    // Configure PORTA and PORTB as inputs

    TRISA = 0xFF;
    TRISB = 0xFF;



    // Enable internal pull-ups on PORTB

    OPTION_REG &= 0x7F;



    // Configure PORTC and PORTD as outputs

    TRISC = 0x00; PORTC = 0x00;
    TRISD = 0x00; PORTD = 0x00;




    // Initialize LCD

    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);



    // Initialize ADC

    ADC_Init();
    Delay_ms(100);


    // EEPROM INITIALIZATION

    if (EEPROM_Read(EEPROM_INIT_FLAG_ADDR) != EEPROM_INITIALIZED) {

        // First run: write all default values to EEPROM
        EEPROM_InitializeDefaults();
    }


    // Load threshold values from EEPROM into RAM variables
    EEPROM_LoadThresholds();


    // Load alert count from EEPROM (persists across power cycles!)
    alert_count = EEPROM_ReadInt(EEPROM_ALERT_COUNT_LO);


    // Initialize state variables

    system_state = STATE_VEILLE;
    previous_state = STATE_VEILLE;
    current_quality_state = 0;
}



// BUTTON HANDLING

void wait_button_release(void) {
    while (BTN_START == 0 || BTN_INTERV == 0 || BTN_RESET == 0 || BTN_CONSULT == 0) {
        Delay_ms(10);
    }
    Delay_ms(50);
}

unsigned char check_buttons(void) {
    if (BTN_RESET == 0) {
        Delay_ms(50);
        if (BTN_RESET == 0) { wait_button_release(); return 6; }

    }
    if (BTN_START == 0) {
        Delay_ms(50);
        if (BTN_START == 0) { wait_button_release(); return 1; }

    }
    if (BTN_INTERV == 0) {
        Delay_ms(50);
        if (BTN_INTERV == 0) { wait_button_release(); return 5; }

    }
    if (BTN_CONSULT == 0) {
        Delay_ms(50);
        if (BTN_CONSULT == 0) { wait_button_release(); return 7; }

    }
    return 0;
}


// SENSOR FUNCTIONS

void read_sensors(void) {
    Delay_ms(5);
    adc_temp = ADC_Read(0);
    Delay_ms(20);
    Delay_ms(5);
    adc_ph = ADC_Read(1);
}

unsigned char is_quality_good(void) {
    read_sensors();

    // Now using threshold variables loaded from EEPROM instead of hardcoded #define constants

    if ((adc_temp >= temp_min_threshold && adc_temp <= temp_max_threshold) &&
        (adc_ph >= ph_min_threshold && adc_ph <= ph_max_threshold))
        return 1;
    return 0;
}


// LED and BUZZER FUNCTIONS

void clear_all_outputs(void) {
    LED_GREEN = 0;
    LED_RED = 0;
    LED_YELLOW = 0;
    BUZZER = 0;
}

unsigned char blink_all_leds_with_check(void) {
    unsigned char i, btn;

    LED_GREEN = 1; LED_RED = 1; LED_YELLOW = 1;
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
        LED_GREEN = 1; Delay_ms(500);
        LED_GREEN = 0; Delay_ms(500);
    }
}

void blink_green_5_times(void) {
    unsigned char i;
    clear_all_outputs();
    for (i = 0; i < 5; i++) {
        LED_GREEN = 1; Delay_ms(250);
        LED_GREEN = 0; Delay_ms(250);
    }
}

void blink_red_and_buzzer(void) {
    LED_RED = 1; BUZZER = 1; Delay_ms(200);
    LED_RED = 0; BUZZER = 0; Delay_ms(200);
}


// STATE HANDLERS

void state_veille(void) {
    unsigned char btn;

    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1,1,"systeme en");
    Lcd_Out(2,1,"veille");

    while (system_state == STATE_VEILLE) {
        btn = blink_all_leds_with_check();
        if (btn == 1) system_state = STATE_RUNNING;
        else if (btn == 7) system_state = STATE_CONSULTATION;
        else if (btn == 5) system_state = STATE_INTERVENTION;
        else if (btn == 6) {


            // MODIFIED: Reset button now clears EEPROM alert count

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

    system_state = STATE_QUALITE;
    current_quality_state = 1;
}

void display_qualite(void) {
    unsigned char btn, q;
    clear_all_outputs();

    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1,1,"Eau de");
    Lcd_Out(2,1,"qualite");
    LED_GREEN = 1;
    current_quality_state = 1;

    while (system_state == STATE_QUALITE) {
        q = is_quality_good();
        if (q == 0) {
            alert_count++;
            EEPROM_SaveAlertCount();  // Save to EEPROM for persistence
            current_quality_state = 0;
            system_state = STATE_MEDIOCRE;
            return;
        }

        btn = check_buttons();
        if (btn == 6) {
            EEPROM_ClearAlertCount();  // Clear EEPROM on reset
            system_state = STATE_VEILLE;
            return;
        }
        if (btn == 7) { system_state = STATE_CONSULTATION; return; }
        if (btn == 5) { system_state = STATE_INTERVENTION; return; }

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

    while (system_state == STATE_MEDIOCRE) {
        blink_red_and_buzzer();
        q = is_quality_good();

        if (q == 1) {
            current_quality_state = 1;
            system_state = STATE_QUALITE;
            return;
        }

        btn = check_buttons();
        if (btn == 6) {
            EEPROM_ClearAlertCount();  // Clear EEPROM on reset
            system_state = STATE_VEILLE;
            return;
        }
        if (btn == 7) { system_state = STATE_CONSULTATION; return; }
        if (btn == 5) { system_state = STATE_INTERVENTION; return; }
    }
}

void check_quality(void) {
    unsigned char q = is_quality_good();

    if (q == 1) {
        system_state = STATE_QUALITE;
        current_quality_state = 1;
    } else {
        alert_count++;
        EEPROM_SaveAlertCount();  // Save to EEPROM for persistence
        system_state = STATE_MEDIOCRE;
        current_quality_state = 0;
    }

    while (system_state == STATE_QUALITE || system_state == STATE_MEDIOCRE) {
        if (system_state == STATE_QUALITE) display_qualite();
        else display_mediocre();
    }
}


// CONSULTATION STATE

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

    while (system_state == STATE_CONSULTATION) {


        // LIVE monitoring inside consultation

        {
            unsigned char q = is_quality_good();

            if (q == 0 && current_quality_state == 1) {
                alert_count++;
                EEPROM_SaveAlertCount();  // Save to EEPROM for persistence
                current_quality_state = 0;
                last_alert_value = 9999;   // force LCD update
            }
            else if (q == 1 && current_quality_state == 0) {
                current_quality_state = 1;
            }
        }



        // LIVE update of alert count on LCD

        if (alert_count != last_alert_value) {
            last_alert_value = alert_count;
            IntToStr(alert_count, txt_buffer);
            Ltrim(txt_buffer);

            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1,1,"Alerte");
            Lcd_Out(2,1,txt_buffer);
            Lcd_Out_CP(" alertes");
        }


        // Buttons (no delay, instant response)

        btn = check_buttons();
        if (btn == 6) {
            EEPROM_ClearAlertCount();  // Clear EEPROM on reset
            system_state = STATE_VEILLE;
            return;
        }
        if (btn == 1) { system_state = STATE_RUNNING; return; }
        if (btn == 5) { system_state = STATE_INTERVENTION; return; }

        // Already handled by refresh
        if (btn == 7) { }

        Delay_ms(5);
    }
}


// INTERVENTION STATE

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

        if (btn == 1) { system_state = STATE_RUNNING; return; }
        if (btn == 6) {
            EEPROM_ClearAlertCount();  // Clear EEPROM on reset
            system_state = STATE_VEILLE;
            return;
        }
        if (btn == 7) { system_state = STATE_CONSULTATION; return; }
    }

    system_state = STATE_VEILLE;
}



// MAIN PROGRAM



void main() {
    init_system();

    while (1) {

        if (system_state != STATE_VEILLE) {
            unsigned char q = is_quality_good();

            if (q == 0 && current_quality_state == 1) {
                alert_count++;
                EEPROM_SaveAlertCount();  // Save to EEPROM for persistence
                current_quality_state = 0;
                system_state = STATE_MEDIOCRE;
            }
            else if (q == 1 && current_quality_state == 0) {
                current_quality_state = 1;
                system_state = STATE_QUALITE;
            }
        }

        switch (system_state) {


            case STATE_VEILLE:
                clear_all_outputs();

                // Alert count is NO LONGER cleared here automatically.
                // It now persists in EEPROM across power cycles and state changes.
                // To clear it, we must explicitly press the RESET button (RB6).

                current_quality_state = 0;
                state_veille();
                break;

            case STATE_RUNNING:
                state_demarrage();
                check_quality();
                break;

            case STATE_QUALITE:
            case STATE_MEDIOCRE:
                check_quality();
                break;

            case STATE_CONSULTATION:
                state_consultation();
                break;

            case STATE_INTERVENTION:
                state_intervention();
                break;

            default:
                system_state = STATE_VEILLE;
                break;
        }
    }
}

