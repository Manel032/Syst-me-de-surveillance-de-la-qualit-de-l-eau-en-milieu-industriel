
_EEPROM_WriteInt:

;eau.c,143 :: 		void EEPROM_WriteInt(unsigned char addr_lo, unsigned int value) {
;eau.c,147 :: 		EEPROM_Write(addr_lo, value & 0xFF);
	MOVF       FARG_EEPROM_WriteInt_addr_lo+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      255
	ANDWF      FARG_EEPROM_WriteInt_value+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;eau.c,148 :: 		Delay_ms(20);  // EEPROM write cycle requires time to complete
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_EEPROM_WriteInt0:
	DECFSZ     R13+0, 1
	GOTO       L_EEPROM_WriteInt0
	DECFSZ     R12+0, 1
	GOTO       L_EEPROM_WriteInt0
	NOP
	NOP
;eau.c,154 :: 		EEPROM_Write(addr_lo + 1, (value >> 8) & 0xFF);
	INCF       FARG_EEPROM_WriteInt_addr_lo+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       FARG_EEPROM_WriteInt_value+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVLW      255
	ANDWF      R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;eau.c,155 :: 		Delay_ms(20);  // EEPROM write cycle requires time to complete
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_EEPROM_WriteInt1:
	DECFSZ     R13+0, 1
	GOTO       L_EEPROM_WriteInt1
	DECFSZ     R12+0, 1
	GOTO       L_EEPROM_WriteInt1
	NOP
	NOP
;eau.c,157 :: 		}
L_end_EEPROM_WriteInt:
	RETURN
; end of _EEPROM_WriteInt

_EEPROM_ReadInt:

;eau.c,165 :: 		unsigned int EEPROM_ReadInt(unsigned char addr_lo) {
;eau.c,168 :: 		low_byte = EEPROM_Read(addr_lo);
	MOVF       FARG_EEPROM_ReadInt_addr_lo+0, 0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      EEPROM_ReadInt_low_byte_L0+0
	CLRF       EEPROM_ReadInt_low_byte_L0+1
;eau.c,169 :: 		high_byte = EEPROM_Read(addr_lo + 1);
	INCF       FARG_EEPROM_ReadInt_addr_lo+0, 0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      EEPROM_ReadInt_high_byte_L0+0
	CLRF       EEPROM_ReadInt_high_byte_L0+1
;eau.c,174 :: 		return (high_byte << 8) | low_byte;
	MOVF       EEPROM_ReadInt_high_byte_L0+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       EEPROM_ReadInt_low_byte_L0+0, 0
	IORWF      R0+0, 1
	MOVF       EEPROM_ReadInt_low_byte_L0+1, 0
	IORWF      R0+1, 1
;eau.c,175 :: 		}
L_end_EEPROM_ReadInt:
	RETURN
; end of _EEPROM_ReadInt

_EEPROM_InitializeDefaults:

;eau.c,182 :: 		void EEPROM_InitializeDefaults(void) {
;eau.c,187 :: 		EEPROM_WriteInt(EEPROM_TEMP_MIN_LO, DEFAULT_TEMP_MIN);
	MOVLW      1
	MOVWF      FARG_EEPROM_WriteInt_addr_lo+0
	MOVLW      35
	MOVWF      FARG_EEPROM_WriteInt_value+0
	MOVLW      0
	MOVWF      FARG_EEPROM_WriteInt_value+1
	CALL       _EEPROM_WriteInt+0
;eau.c,188 :: 		EEPROM_WriteInt(EEPROM_TEMP_MAX_LO, DEFAULT_TEMP_MAX);
	MOVLW      3
	MOVWF      FARG_EEPROM_WriteInt_addr_lo+0
	MOVLW      45
	MOVWF      FARG_EEPROM_WriteInt_value+0
	MOVLW      0
	MOVWF      FARG_EEPROM_WriteInt_value+1
	CALL       _EEPROM_WriteInt+0
;eau.c,189 :: 		EEPROM_WriteInt(EEPROM_PH_MIN_LO, DEFAULT_PH_MIN);
	MOVLW      5
	MOVWF      FARG_EEPROM_WriteInt_addr_lo+0
	MOVLW      44
	MOVWF      FARG_EEPROM_WriteInt_value+0
	MOVLW      1
	MOVWF      FARG_EEPROM_WriteInt_value+1
	CALL       _EEPROM_WriteInt+0
;eau.c,190 :: 		EEPROM_WriteInt(EEPROM_PH_MAX_LO, DEFAULT_PH_MAX);
	MOVLW      7
	MOVWF      FARG_EEPROM_WriteInt_addr_lo+0
	MOVLW      59
	MOVWF      FARG_EEPROM_WriteInt_value+0
	MOVLW      1
	MOVWF      FARG_EEPROM_WriteInt_value+1
	CALL       _EEPROM_WriteInt+0
;eau.c,195 :: 		EEPROM_WriteInt(EEPROM_ALERT_COUNT_LO, 0);
	MOVLW      16
	MOVWF      FARG_EEPROM_WriteInt_addr_lo+0
	CLRF       FARG_EEPROM_WriteInt_value+0
	CLRF       FARG_EEPROM_WriteInt_value+1
	CALL       _EEPROM_WriteInt+0
;eau.c,201 :: 		EEPROM_Write(EEPROM_INIT_FLAG_ADDR, EEPROM_INITIALIZED);
	CLRF       FARG_EEPROM_Write_Address+0
	MOVLW      170
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;eau.c,202 :: 		Delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_EEPROM_InitializeDefaults2:
	DECFSZ     R13+0, 1
	GOTO       L_EEPROM_InitializeDefaults2
	DECFSZ     R12+0, 1
	GOTO       L_EEPROM_InitializeDefaults2
	NOP
	NOP
;eau.c,205 :: 		}
L_end_EEPROM_InitializeDefaults:
	RETURN
; end of _EEPROM_InitializeDefaults

_EEPROM_SaveAlertCount:

;eau.c,211 :: 		void EEPROM_SaveAlertCount(void) {
;eau.c,212 :: 		EEPROM_WriteInt(EEPROM_ALERT_COUNT_LO, alert_count);
	MOVLW      16
	MOVWF      FARG_EEPROM_WriteInt_addr_lo+0
	MOVF       _alert_count+0, 0
	MOVWF      FARG_EEPROM_WriteInt_value+0
	MOVF       _alert_count+1, 0
	MOVWF      FARG_EEPROM_WriteInt_value+1
	CALL       _EEPROM_WriteInt+0
;eau.c,213 :: 		}
L_end_EEPROM_SaveAlertCount:
	RETURN
; end of _EEPROM_SaveAlertCount

_EEPROM_ClearAlertCount:

;eau.c,219 :: 		void EEPROM_ClearAlertCount(void) {
;eau.c,220 :: 		alert_count = 0;
	CLRF       _alert_count+0
	CLRF       _alert_count+1
;eau.c,221 :: 		EEPROM_WriteInt(EEPROM_ALERT_COUNT_LO, 0);
	MOVLW      16
	MOVWF      FARG_EEPROM_WriteInt_addr_lo+0
	CLRF       FARG_EEPROM_WriteInt_value+0
	CLRF       FARG_EEPROM_WriteInt_value+1
	CALL       _EEPROM_WriteInt+0
;eau.c,222 :: 		}
L_end_EEPROM_ClearAlertCount:
	RETURN
; end of _EEPROM_ClearAlertCount

_EEPROM_LoadThresholds:

;eau.c,231 :: 		void EEPROM_LoadThresholds(void) {
;eau.c,232 :: 		temp_min_threshold = EEPROM_ReadInt(EEPROM_TEMP_MIN_LO);
	MOVLW      1
	MOVWF      FARG_EEPROM_ReadInt_addr_lo+0
	CALL       _EEPROM_ReadInt+0
	MOVF       R0+0, 0
	MOVWF      _temp_min_threshold+0
	MOVF       R0+1, 0
	MOVWF      _temp_min_threshold+1
;eau.c,233 :: 		temp_max_threshold = EEPROM_ReadInt(EEPROM_TEMP_MAX_LO);
	MOVLW      3
	MOVWF      FARG_EEPROM_ReadInt_addr_lo+0
	CALL       _EEPROM_ReadInt+0
	MOVF       R0+0, 0
	MOVWF      _temp_max_threshold+0
	MOVF       R0+1, 0
	MOVWF      _temp_max_threshold+1
;eau.c,234 :: 		ph_min_threshold = EEPROM_ReadInt(EEPROM_PH_MIN_LO);
	MOVLW      5
	MOVWF      FARG_EEPROM_ReadInt_addr_lo+0
	CALL       _EEPROM_ReadInt+0
	MOVF       R0+0, 0
	MOVWF      _ph_min_threshold+0
	MOVF       R0+1, 0
	MOVWF      _ph_min_threshold+1
;eau.c,235 :: 		ph_max_threshold = EEPROM_ReadInt(EEPROM_PH_MAX_LO);
	MOVLW      7
	MOVWF      FARG_EEPROM_ReadInt_addr_lo+0
	CALL       _EEPROM_ReadInt+0
	MOVF       R0+0, 0
	MOVWF      _ph_max_threshold+0
	MOVF       R0+1, 0
	MOVWF      _ph_max_threshold+1
;eau.c,236 :: 		}
L_end_EEPROM_LoadThresholds:
	RETURN
; end of _EEPROM_LoadThresholds

_init_system:

;eau.c,243 :: 		void init_system(void) {
;eau.c,248 :: 		ADCON1 = 0x80;
	MOVLW      128
	MOVWF      ADCON1+0
;eau.c,254 :: 		TRISA = 0xFF;
	MOVLW      255
	MOVWF      TRISA+0
;eau.c,255 :: 		TRISB = 0xFF;
	MOVLW      255
	MOVWF      TRISB+0
;eau.c,261 :: 		OPTION_REG &= 0x7F;
	MOVLW      127
	ANDWF      OPTION_REG+0, 1
;eau.c,267 :: 		TRISC = 0x00; PORTC = 0x00;
	CLRF       TRISC+0
	CLRF       PORTC+0
;eau.c,268 :: 		TRISD = 0x00; PORTD = 0x00;
	CLRF       TRISD+0
	CLRF       PORTD+0
;eau.c,275 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;eau.c,276 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eau.c,277 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eau.c,283 :: 		ADC_Init();
	CALL       _ADC_Init+0
;eau.c,284 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_init_system3:
	DECFSZ     R13+0, 1
	GOTO       L_init_system3
	DECFSZ     R12+0, 1
	GOTO       L_init_system3
	DECFSZ     R11+0, 1
	GOTO       L_init_system3
	NOP
;eau.c,289 :: 		if (EEPROM_Read(EEPROM_INIT_FLAG_ADDR) != EEPROM_INITIALIZED) {
	CLRF       FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	XORLW      170
	BTFSC      STATUS+0, 2
	GOTO       L_init_system4
;eau.c,292 :: 		EEPROM_InitializeDefaults();
	CALL       _EEPROM_InitializeDefaults+0
;eau.c,293 :: 		}
L_init_system4:
;eau.c,297 :: 		EEPROM_LoadThresholds();
	CALL       _EEPROM_LoadThresholds+0
;eau.c,301 :: 		alert_count = EEPROM_ReadInt(EEPROM_ALERT_COUNT_LO);
	MOVLW      16
	MOVWF      FARG_EEPROM_ReadInt_addr_lo+0
	CALL       _EEPROM_ReadInt+0
	MOVF       R0+0, 0
	MOVWF      _alert_count+0
	MOVF       R0+1, 0
	MOVWF      _alert_count+1
;eau.c,306 :: 		system_state = STATE_VEILLE;
	CLRF       _system_state+0
;eau.c,307 :: 		previous_state = STATE_VEILLE;
	CLRF       _previous_state+0
;eau.c,308 :: 		current_quality_state = 0;
	CLRF       _current_quality_state+0
;eau.c,309 :: 		}
L_end_init_system:
	RETURN
; end of _init_system

_wait_button_release:

;eau.c,315 :: 		void wait_button_release(void) {
;eau.c,316 :: 		while (BTN_START == 0 || BTN_INTERV == 0 || BTN_RESET == 0 || BTN_CONSULT == 0) {
L_wait_button_release5:
	BTFSS      PORTB+0, 0
	GOTO       L__wait_button_release126
	BTFSS      PORTB+0, 5
	GOTO       L__wait_button_release126
	BTFSS      PORTB+0, 6
	GOTO       L__wait_button_release126
	BTFSS      PORTB+0, 7
	GOTO       L__wait_button_release126
	GOTO       L_wait_button_release6
L__wait_button_release126:
;eau.c,317 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_wait_button_release9:
	DECFSZ     R13+0, 1
	GOTO       L_wait_button_release9
	DECFSZ     R12+0, 1
	GOTO       L_wait_button_release9
	NOP
;eau.c,318 :: 		}
	GOTO       L_wait_button_release5
L_wait_button_release6:
;eau.c,319 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_wait_button_release10:
	DECFSZ     R13+0, 1
	GOTO       L_wait_button_release10
	DECFSZ     R12+0, 1
	GOTO       L_wait_button_release10
	NOP
	NOP
;eau.c,320 :: 		}
L_end_wait_button_release:
	RETURN
; end of _wait_button_release

_check_buttons:

;eau.c,322 :: 		unsigned char check_buttons(void) {
;eau.c,323 :: 		if (BTN_RESET == 0) {
	BTFSC      PORTB+0, 6
	GOTO       L_check_buttons11
;eau.c,324 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_check_buttons12:
	DECFSZ     R13+0, 1
	GOTO       L_check_buttons12
	DECFSZ     R12+0, 1
	GOTO       L_check_buttons12
	NOP
	NOP
;eau.c,325 :: 		if (BTN_RESET == 0) { wait_button_release(); return 6; }
	BTFSC      PORTB+0, 6
	GOTO       L_check_buttons13
	CALL       _wait_button_release+0
	MOVLW      6
	MOVWF      R0+0
	GOTO       L_end_check_buttons
L_check_buttons13:
;eau.c,327 :: 		}
L_check_buttons11:
;eau.c,328 :: 		if (BTN_START == 0) {
	BTFSC      PORTB+0, 0
	GOTO       L_check_buttons14
;eau.c,329 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_check_buttons15:
	DECFSZ     R13+0, 1
	GOTO       L_check_buttons15
	DECFSZ     R12+0, 1
	GOTO       L_check_buttons15
	NOP
	NOP
;eau.c,330 :: 		if (BTN_START == 0) { wait_button_release(); return 1; }
	BTFSC      PORTB+0, 0
	GOTO       L_check_buttons16
	CALL       _wait_button_release+0
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_check_buttons
L_check_buttons16:
;eau.c,332 :: 		}
L_check_buttons14:
;eau.c,333 :: 		if (BTN_INTERV == 0) {
	BTFSC      PORTB+0, 5
	GOTO       L_check_buttons17
;eau.c,334 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_check_buttons18:
	DECFSZ     R13+0, 1
	GOTO       L_check_buttons18
	DECFSZ     R12+0, 1
	GOTO       L_check_buttons18
	NOP
	NOP
;eau.c,335 :: 		if (BTN_INTERV == 0) { wait_button_release(); return 5; }
	BTFSC      PORTB+0, 5
	GOTO       L_check_buttons19
	CALL       _wait_button_release+0
	MOVLW      5
	MOVWF      R0+0
	GOTO       L_end_check_buttons
L_check_buttons19:
;eau.c,337 :: 		}
L_check_buttons17:
;eau.c,338 :: 		if (BTN_CONSULT == 0) {
	BTFSC      PORTB+0, 7
	GOTO       L_check_buttons20
;eau.c,339 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_check_buttons21:
	DECFSZ     R13+0, 1
	GOTO       L_check_buttons21
	DECFSZ     R12+0, 1
	GOTO       L_check_buttons21
	NOP
	NOP
;eau.c,340 :: 		if (BTN_CONSULT == 0) { wait_button_release(); return 7; }
	BTFSC      PORTB+0, 7
	GOTO       L_check_buttons22
	CALL       _wait_button_release+0
	MOVLW      7
	MOVWF      R0+0
	GOTO       L_end_check_buttons
L_check_buttons22:
;eau.c,342 :: 		}
L_check_buttons20:
;eau.c,343 :: 		return 0;
	CLRF       R0+0
;eau.c,344 :: 		}
L_end_check_buttons:
	RETURN
; end of _check_buttons

_read_sensors:

;eau.c,349 :: 		void read_sensors(void) {
;eau.c,350 :: 		Delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_read_sensors23:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensors23
	DECFSZ     R12+0, 1
	GOTO       L_read_sensors23
	NOP
	NOP
;eau.c,351 :: 		adc_temp = ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_temp+0
	MOVF       R0+1, 0
	MOVWF      _adc_temp+1
;eau.c,352 :: 		Delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_read_sensors24:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensors24
	DECFSZ     R12+0, 1
	GOTO       L_read_sensors24
	NOP
	NOP
;eau.c,353 :: 		Delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_read_sensors25:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensors25
	DECFSZ     R12+0, 1
	GOTO       L_read_sensors25
	NOP
	NOP
;eau.c,354 :: 		adc_ph = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_ph+0
	MOVF       R0+1, 0
	MOVWF      _adc_ph+1
;eau.c,355 :: 		}
L_end_read_sensors:
	RETURN
; end of _read_sensors

_is_quality_good:

;eau.c,357 :: 		unsigned char is_quality_good(void) {
;eau.c,358 :: 		read_sensors();
	CALL       _read_sensors+0
;eau.c,362 :: 		if ((adc_temp >= temp_min_threshold && adc_temp <= temp_max_threshold) &&
	MOVF       _temp_min_threshold+1, 0
	SUBWF      _adc_temp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__is_quality_good146
	MOVF       _temp_min_threshold+0, 0
	SUBWF      _adc_temp+0, 0
L__is_quality_good146:
	BTFSS      STATUS+0, 0
	GOTO       L_is_quality_good32
	MOVF       _adc_temp+1, 0
	SUBWF      _temp_max_threshold+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__is_quality_good147
	MOVF       _adc_temp+0, 0
	SUBWF      _temp_max_threshold+0, 0
L__is_quality_good147:
	BTFSS      STATUS+0, 0
	GOTO       L_is_quality_good32
;eau.c,363 :: 		(adc_ph >= ph_min_threshold && adc_ph <= ph_max_threshold))
L__is_quality_good129:
	MOVF       _ph_min_threshold+1, 0
	SUBWF      _adc_ph+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__is_quality_good148
	MOVF       _ph_min_threshold+0, 0
	SUBWF      _adc_ph+0, 0
L__is_quality_good148:
	BTFSS      STATUS+0, 0
	GOTO       L_is_quality_good32
	MOVF       _adc_ph+1, 0
	SUBWF      _ph_max_threshold+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__is_quality_good149
	MOVF       _adc_ph+0, 0
	SUBWF      _ph_max_threshold+0, 0
L__is_quality_good149:
	BTFSS      STATUS+0, 0
	GOTO       L_is_quality_good32
L__is_quality_good128:
L__is_quality_good127:
;eau.c,364 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_is_quality_good
L_is_quality_good32:
;eau.c,365 :: 		return 0;
	CLRF       R0+0
;eau.c,366 :: 		}
L_end_is_quality_good:
	RETURN
; end of _is_quality_good

_clear_all_outputs:

;eau.c,371 :: 		void clear_all_outputs(void) {
;eau.c,372 :: 		LED_GREEN = 0;
	BCF        PORTC+0, 3
;eau.c,373 :: 		LED_RED = 0;
	BCF        PORTC+0, 4
;eau.c,374 :: 		LED_YELLOW = 0;
	BCF        PORTC+0, 5
;eau.c,375 :: 		BUZZER = 0;
	BCF        PORTD+0, 0
;eau.c,376 :: 		}
L_end_clear_all_outputs:
	RETURN
; end of _clear_all_outputs

_blink_all_leds_with_check:

;eau.c,378 :: 		unsigned char blink_all_leds_with_check(void) {
;eau.c,381 :: 		LED_GREEN = 1; LED_RED = 1; LED_YELLOW = 1;
	BSF        PORTC+0, 3
	BSF        PORTC+0, 4
	BSF        PORTC+0, 5
;eau.c,382 :: 		for (i = 0; i < 10; i++) {
	CLRF       blink_all_leds_with_check_i_L0+0
L_blink_all_leds_with_check33:
	MOVLW      10
	SUBWF      blink_all_leds_with_check_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_blink_all_leds_with_check34
;eau.c,383 :: 		Delay_ms(25);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_blink_all_leds_with_check36:
	DECFSZ     R13+0, 1
	GOTO       L_blink_all_leds_with_check36
	DECFSZ     R12+0, 1
	GOTO       L_blink_all_leds_with_check36
	NOP
;eau.c,384 :: 		btn = check_buttons();
	CALL       _check_buttons+0
	MOVF       R0+0, 0
	MOVWF      blink_all_leds_with_check_btn_L0+0
;eau.c,385 :: 		if (btn) { clear_all_outputs(); return btn; }
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_blink_all_leds_with_check37
	CALL       _clear_all_outputs+0
	MOVF       blink_all_leds_with_check_btn_L0+0, 0
	MOVWF      R0+0
	GOTO       L_end_blink_all_leds_with_check
L_blink_all_leds_with_check37:
;eau.c,382 :: 		for (i = 0; i < 10; i++) {
	INCF       blink_all_leds_with_check_i_L0+0, 1
;eau.c,386 :: 		}
	GOTO       L_blink_all_leds_with_check33
L_blink_all_leds_with_check34:
;eau.c,388 :: 		clear_all_outputs();
	CALL       _clear_all_outputs+0
;eau.c,389 :: 		for (i = 0; i < 10; i++) {
	CLRF       blink_all_leds_with_check_i_L0+0
L_blink_all_leds_with_check38:
	MOVLW      10
	SUBWF      blink_all_leds_with_check_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_blink_all_leds_with_check39
;eau.c,390 :: 		Delay_ms(25);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_blink_all_leds_with_check41:
	DECFSZ     R13+0, 1
	GOTO       L_blink_all_leds_with_check41
	DECFSZ     R12+0, 1
	GOTO       L_blink_all_leds_with_check41
	NOP
;eau.c,391 :: 		btn = check_buttons();
	CALL       _check_buttons+0
	MOVF       R0+0, 0
	MOVWF      blink_all_leds_with_check_btn_L0+0
;eau.c,392 :: 		if (btn) return btn;
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_blink_all_leds_with_check42
	MOVF       blink_all_leds_with_check_btn_L0+0, 0
	MOVWF      R0+0
	GOTO       L_end_blink_all_leds_with_check
L_blink_all_leds_with_check42:
;eau.c,389 :: 		for (i = 0; i < 10; i++) {
	INCF       blink_all_leds_with_check_i_L0+0, 1
;eau.c,393 :: 		}
	GOTO       L_blink_all_leds_with_check38
L_blink_all_leds_with_check39:
;eau.c,395 :: 		return 0;
	CLRF       R0+0
;eau.c,396 :: 		}
L_end_blink_all_leds_with_check:
	RETURN
; end of _blink_all_leds_with_check

_blink_green_3_times_3sec:

;eau.c,398 :: 		void blink_green_3_times_3sec(void) {
;eau.c,400 :: 		clear_all_outputs();
	CALL       _clear_all_outputs+0
;eau.c,401 :: 		for (i = 0; i < 3; i++) {
	CLRF       blink_green_3_times_3sec_i_L0+0
L_blink_green_3_times_3sec43:
	MOVLW      3
	SUBWF      blink_green_3_times_3sec_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_blink_green_3_times_3sec44
;eau.c,402 :: 		LED_GREEN = 1; Delay_ms(500);
	BSF        PORTC+0, 3
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_blink_green_3_times_3sec46:
	DECFSZ     R13+0, 1
	GOTO       L_blink_green_3_times_3sec46
	DECFSZ     R12+0, 1
	GOTO       L_blink_green_3_times_3sec46
	DECFSZ     R11+0, 1
	GOTO       L_blink_green_3_times_3sec46
	NOP
	NOP
;eau.c,403 :: 		LED_GREEN = 0; Delay_ms(500);
	BCF        PORTC+0, 3
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_blink_green_3_times_3sec47:
	DECFSZ     R13+0, 1
	GOTO       L_blink_green_3_times_3sec47
	DECFSZ     R12+0, 1
	GOTO       L_blink_green_3_times_3sec47
	DECFSZ     R11+0, 1
	GOTO       L_blink_green_3_times_3sec47
	NOP
	NOP
;eau.c,401 :: 		for (i = 0; i < 3; i++) {
	INCF       blink_green_3_times_3sec_i_L0+0, 1
;eau.c,404 :: 		}
	GOTO       L_blink_green_3_times_3sec43
L_blink_green_3_times_3sec44:
;eau.c,405 :: 		}
L_end_blink_green_3_times_3sec:
	RETURN
; end of _blink_green_3_times_3sec

_blink_green_5_times:

;eau.c,407 :: 		void blink_green_5_times(void) {
;eau.c,409 :: 		clear_all_outputs();
	CALL       _clear_all_outputs+0
;eau.c,410 :: 		for (i = 0; i < 5; i++) {
	CLRF       blink_green_5_times_i_L0+0
L_blink_green_5_times48:
	MOVLW      5
	SUBWF      blink_green_5_times_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_blink_green_5_times49
;eau.c,411 :: 		LED_GREEN = 1; Delay_ms(250);
	BSF        PORTC+0, 3
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_blink_green_5_times51:
	DECFSZ     R13+0, 1
	GOTO       L_blink_green_5_times51
	DECFSZ     R12+0, 1
	GOTO       L_blink_green_5_times51
	DECFSZ     R11+0, 1
	GOTO       L_blink_green_5_times51
	NOP
	NOP
;eau.c,412 :: 		LED_GREEN = 0; Delay_ms(250);
	BCF        PORTC+0, 3
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_blink_green_5_times52:
	DECFSZ     R13+0, 1
	GOTO       L_blink_green_5_times52
	DECFSZ     R12+0, 1
	GOTO       L_blink_green_5_times52
	DECFSZ     R11+0, 1
	GOTO       L_blink_green_5_times52
	NOP
	NOP
;eau.c,410 :: 		for (i = 0; i < 5; i++) {
	INCF       blink_green_5_times_i_L0+0, 1
;eau.c,413 :: 		}
	GOTO       L_blink_green_5_times48
L_blink_green_5_times49:
;eau.c,414 :: 		}
L_end_blink_green_5_times:
	RETURN
; end of _blink_green_5_times

_blink_red_and_buzzer:

;eau.c,416 :: 		void blink_red_and_buzzer(void) {
;eau.c,417 :: 		LED_RED = 1; BUZZER = 1; Delay_ms(200);
	BSF        PORTC+0, 4
	BSF        PORTD+0, 0
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_blink_red_and_buzzer53:
	DECFSZ     R13+0, 1
	GOTO       L_blink_red_and_buzzer53
	DECFSZ     R12+0, 1
	GOTO       L_blink_red_and_buzzer53
	DECFSZ     R11+0, 1
	GOTO       L_blink_red_and_buzzer53
;eau.c,418 :: 		LED_RED = 0; BUZZER = 0; Delay_ms(200);
	BCF        PORTC+0, 4
	BCF        PORTD+0, 0
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_blink_red_and_buzzer54:
	DECFSZ     R13+0, 1
	GOTO       L_blink_red_and_buzzer54
	DECFSZ     R12+0, 1
	GOTO       L_blink_red_and_buzzer54
	DECFSZ     R11+0, 1
	GOTO       L_blink_red_and_buzzer54
;eau.c,419 :: 		}
L_end_blink_red_and_buzzer:
	RETURN
; end of _blink_red_and_buzzer

_state_veille:

;eau.c,424 :: 		void state_veille(void) {
;eau.c,427 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eau.c,428 :: 		Lcd_Out(1,1,"systeme en");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,429 :: 		Lcd_Out(2,1,"veille");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,431 :: 		while (system_state == STATE_VEILLE) {
L_state_veille55:
	MOVF       _system_state+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_state_veille56
;eau.c,432 :: 		btn = blink_all_leds_with_check();
	CALL       _blink_all_leds_with_check+0
	MOVF       R0+0, 0
	MOVWF      state_veille_btn_L0+0
;eau.c,433 :: 		if (btn == 1) system_state = STATE_RUNNING;
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_state_veille57
	MOVLW      1
	MOVWF      _system_state+0
	GOTO       L_state_veille58
L_state_veille57:
;eau.c,434 :: 		else if (btn == 7) system_state = STATE_CONSULTATION;
	MOVF       state_veille_btn_L0+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_state_veille59
	MOVLW      4
	MOVWF      _system_state+0
	GOTO       L_state_veille60
L_state_veille59:
;eau.c,435 :: 		else if (btn == 5) system_state = STATE_INTERVENTION;
	MOVF       state_veille_btn_L0+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_state_veille61
	MOVLW      5
	MOVWF      _system_state+0
	GOTO       L_state_veille62
L_state_veille61:
;eau.c,436 :: 		else if (btn == 6) {
	MOVF       state_veille_btn_L0+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_state_veille63
;eau.c,441 :: 		EEPROM_ClearAlertCount();
	CALL       _EEPROM_ClearAlertCount+0
;eau.c,442 :: 		current_quality_state = 0;
	CLRF       _current_quality_state+0
;eau.c,443 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eau.c,444 :: 		Lcd_Out(1,1,"systeme en");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,445 :: 		Lcd_Out(2,1,"veille");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,446 :: 		}
L_state_veille63:
L_state_veille62:
L_state_veille60:
L_state_veille58:
;eau.c,447 :: 		}
	GOTO       L_state_veille55
L_state_veille56:
;eau.c,448 :: 		}
L_end_state_veille:
	RETURN
; end of _state_veille

_state_demarrage:

;eau.c,451 :: 		void state_demarrage(void) {
;eau.c,452 :: 		clear_all_outputs();
	CALL       _clear_all_outputs+0
;eau.c,453 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eau.c,454 :: 		Lcd_Out(1,1,"systeme");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,455 :: 		Lcd_Out(2,1,"demarre");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,456 :: 		blink_green_3_times_3sec();
	CALL       _blink_green_3_times_3sec+0
;eau.c,458 :: 		system_state = STATE_QUALITE;
	MOVLW      2
	MOVWF      _system_state+0
;eau.c,459 :: 		current_quality_state = 1;
	MOVLW      1
	MOVWF      _current_quality_state+0
;eau.c,460 :: 		}
L_end_state_demarrage:
	RETURN
; end of _state_demarrage

_display_qualite:

;eau.c,462 :: 		void display_qualite(void) {
;eau.c,464 :: 		clear_all_outputs();
	CALL       _clear_all_outputs+0
;eau.c,466 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eau.c,467 :: 		Lcd_Out(1,1,"Eau de");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,468 :: 		Lcd_Out(2,1,"qualite");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,469 :: 		LED_GREEN = 1;
	BSF        PORTC+0, 3
;eau.c,470 :: 		current_quality_state = 1;
	MOVLW      1
	MOVWF      _current_quality_state+0
;eau.c,472 :: 		while (system_state == STATE_QUALITE) {
L_display_qualite64:
	MOVF       _system_state+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_display_qualite65
;eau.c,473 :: 		q = is_quality_good();
	CALL       _is_quality_good+0
;eau.c,474 :: 		if (q == 0) {
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_display_qualite66
;eau.c,475 :: 		alert_count++;
	INCF       _alert_count+0, 1
	BTFSC      STATUS+0, 2
	INCF       _alert_count+1, 1
;eau.c,476 :: 		EEPROM_SaveAlertCount();  // Save to EEPROM for persistence
	CALL       _EEPROM_SaveAlertCount+0
;eau.c,477 :: 		current_quality_state = 0;
	CLRF       _current_quality_state+0
;eau.c,478 :: 		system_state = STATE_MEDIOCRE;
	MOVLW      3
	MOVWF      _system_state+0
;eau.c,479 :: 		return;
	GOTO       L_end_display_qualite
;eau.c,480 :: 		}
L_display_qualite66:
;eau.c,482 :: 		btn = check_buttons();
	CALL       _check_buttons+0
	MOVF       R0+0, 0
	MOVWF      display_qualite_btn_L0+0
;eau.c,483 :: 		if (btn == 6) {
	MOVF       R0+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_display_qualite67
;eau.c,484 :: 		EEPROM_ClearAlertCount();  // Clear EEPROM on reset
	CALL       _EEPROM_ClearAlertCount+0
;eau.c,485 :: 		system_state = STATE_VEILLE;
	CLRF       _system_state+0
;eau.c,486 :: 		return;
	GOTO       L_end_display_qualite
;eau.c,487 :: 		}
L_display_qualite67:
;eau.c,488 :: 		if (btn == 7) { system_state = STATE_CONSULTATION; return; }
	MOVF       display_qualite_btn_L0+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_display_qualite68
	MOVLW      4
	MOVWF      _system_state+0
	GOTO       L_end_display_qualite
L_display_qualite68:
;eau.c,489 :: 		if (btn == 5) { system_state = STATE_INTERVENTION; return; }
	MOVF       display_qualite_btn_L0+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_display_qualite69
	MOVLW      5
	MOVWF      _system_state+0
	GOTO       L_end_display_qualite
L_display_qualite69:
;eau.c,491 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_display_qualite70:
	DECFSZ     R13+0, 1
	GOTO       L_display_qualite70
	DECFSZ     R12+0, 1
	GOTO       L_display_qualite70
	DECFSZ     R11+0, 1
	GOTO       L_display_qualite70
	NOP
;eau.c,492 :: 		}
	GOTO       L_display_qualite64
L_display_qualite65:
;eau.c,493 :: 		}
L_end_display_qualite:
	RETURN
; end of _display_qualite

_display_mediocre:

;eau.c,495 :: 		void display_mediocre(void) {
;eau.c,497 :: 		clear_all_outputs();
	CALL       _clear_all_outputs+0
;eau.c,499 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eau.c,500 :: 		Lcd_Out(1,1,"Eau");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,501 :: 		Lcd_Out(2,1,"mediocre");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,502 :: 		current_quality_state = 0;
	CLRF       _current_quality_state+0
;eau.c,504 :: 		while (system_state == STATE_MEDIOCRE) {
L_display_mediocre71:
	MOVF       _system_state+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_display_mediocre72
;eau.c,505 :: 		blink_red_and_buzzer();
	CALL       _blink_red_and_buzzer+0
;eau.c,506 :: 		q = is_quality_good();
	CALL       _is_quality_good+0
;eau.c,508 :: 		if (q == 1) {
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_display_mediocre73
;eau.c,509 :: 		current_quality_state = 1;
	MOVLW      1
	MOVWF      _current_quality_state+0
;eau.c,510 :: 		system_state = STATE_QUALITE;
	MOVLW      2
	MOVWF      _system_state+0
;eau.c,511 :: 		return;
	GOTO       L_end_display_mediocre
;eau.c,512 :: 		}
L_display_mediocre73:
;eau.c,514 :: 		btn = check_buttons();
	CALL       _check_buttons+0
	MOVF       R0+0, 0
	MOVWF      display_mediocre_btn_L0+0
;eau.c,515 :: 		if (btn == 6) {
	MOVF       R0+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_display_mediocre74
;eau.c,516 :: 		EEPROM_ClearAlertCount();  // Clear EEPROM on reset
	CALL       _EEPROM_ClearAlertCount+0
;eau.c,517 :: 		system_state = STATE_VEILLE;
	CLRF       _system_state+0
;eau.c,518 :: 		return;
	GOTO       L_end_display_mediocre
;eau.c,519 :: 		}
L_display_mediocre74:
;eau.c,520 :: 		if (btn == 7) { system_state = STATE_CONSULTATION; return; }
	MOVF       display_mediocre_btn_L0+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_display_mediocre75
	MOVLW      4
	MOVWF      _system_state+0
	GOTO       L_end_display_mediocre
L_display_mediocre75:
;eau.c,521 :: 		if (btn == 5) { system_state = STATE_INTERVENTION; return; }
	MOVF       display_mediocre_btn_L0+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_display_mediocre76
	MOVLW      5
	MOVWF      _system_state+0
	GOTO       L_end_display_mediocre
L_display_mediocre76:
;eau.c,522 :: 		}
	GOTO       L_display_mediocre71
L_display_mediocre72:
;eau.c,523 :: 		}
L_end_display_mediocre:
	RETURN
; end of _display_mediocre

_check_quality:

;eau.c,525 :: 		void check_quality(void) {
;eau.c,526 :: 		unsigned char q = is_quality_good();
	CALL       _is_quality_good+0
;eau.c,528 :: 		if (q == 1) {
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_check_quality77
;eau.c,529 :: 		system_state = STATE_QUALITE;
	MOVLW      2
	MOVWF      _system_state+0
;eau.c,530 :: 		current_quality_state = 1;
	MOVLW      1
	MOVWF      _current_quality_state+0
;eau.c,531 :: 		} else {
	GOTO       L_check_quality78
L_check_quality77:
;eau.c,532 :: 		alert_count++;
	INCF       _alert_count+0, 1
	BTFSC      STATUS+0, 2
	INCF       _alert_count+1, 1
;eau.c,533 :: 		EEPROM_SaveAlertCount();  // Save to EEPROM for persistence
	CALL       _EEPROM_SaveAlertCount+0
;eau.c,534 :: 		system_state = STATE_MEDIOCRE;
	MOVLW      3
	MOVWF      _system_state+0
;eau.c,535 :: 		current_quality_state = 0;
	CLRF       _current_quality_state+0
;eau.c,536 :: 		}
L_check_quality78:
;eau.c,538 :: 		while (system_state == STATE_QUALITE || system_state == STATE_MEDIOCRE) {
L_check_quality79:
	MOVF       _system_state+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__check_quality130
	MOVF       _system_state+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__check_quality130
	GOTO       L_check_quality80
L__check_quality130:
;eau.c,539 :: 		if (system_state == STATE_QUALITE) display_qualite();
	MOVF       _system_state+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_check_quality83
	CALL       _display_qualite+0
	GOTO       L_check_quality84
L_check_quality83:
;eau.c,540 :: 		else display_mediocre();
	CALL       _display_mediocre+0
L_check_quality84:
;eau.c,541 :: 		}
	GOTO       L_check_quality79
L_check_quality80:
;eau.c,542 :: 		}
L_end_check_quality:
	RETURN
; end of _check_quality

_state_consultation:

;eau.c,547 :: 		void state_consultation(void) {
;eau.c,551 :: 		clear_all_outputs();
	CALL       _clear_all_outputs+0
;eau.c,553 :: 		IntToStr(alert_count, txt_buffer);
	MOVF       _alert_count+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _alert_count+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_buffer+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;eau.c,554 :: 		Ltrim(txt_buffer);
	MOVLW      _txt_buffer+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;eau.c,555 :: 		last_alert_value = alert_count;
	MOVF       _alert_count+0, 0
	MOVWF      state_consultation_last_alert_value_L0+0
	MOVF       _alert_count+1, 0
	MOVWF      state_consultation_last_alert_value_L0+1
;eau.c,557 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eau.c,558 :: 		Lcd_Out(1,1,"Alerte");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,559 :: 		Lcd_Out(2,1,txt_buffer);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt_buffer+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,560 :: 		Lcd_Out_CP(" alertes");
	MOVLW      ?lstr12_eau+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;eau.c,562 :: 		while (system_state == STATE_CONSULTATION) {
L_state_consultation85:
	MOVF       _system_state+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_state_consultation86
;eau.c,568 :: 		unsigned char q = is_quality_good();
	CALL       _is_quality_good+0
	MOVF       R0+0, 0
	MOVWF      state_consultation_q_L2+0
;eau.c,570 :: 		if (q == 0 && current_quality_state == 1) {
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_state_consultation89
	MOVF       _current_quality_state+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_state_consultation89
L__state_consultation132:
;eau.c,571 :: 		alert_count++;
	INCF       _alert_count+0, 1
	BTFSC      STATUS+0, 2
	INCF       _alert_count+1, 1
;eau.c,572 :: 		EEPROM_SaveAlertCount();  // Save to EEPROM for persistence
	CALL       _EEPROM_SaveAlertCount+0
;eau.c,573 :: 		current_quality_state = 0;
	CLRF       _current_quality_state+0
;eau.c,574 :: 		last_alert_value = 9999;   // force LCD update
	MOVLW      15
	MOVWF      state_consultation_last_alert_value_L0+0
	MOVLW      39
	MOVWF      state_consultation_last_alert_value_L0+1
;eau.c,575 :: 		}
	GOTO       L_state_consultation90
L_state_consultation89:
;eau.c,576 :: 		else if (q == 1 && current_quality_state == 0) {
	MOVF       state_consultation_q_L2+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_state_consultation93
	MOVF       _current_quality_state+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_state_consultation93
L__state_consultation131:
;eau.c,577 :: 		current_quality_state = 1;
	MOVLW      1
	MOVWF      _current_quality_state+0
;eau.c,578 :: 		}
L_state_consultation93:
L_state_consultation90:
;eau.c,585 :: 		if (alert_count != last_alert_value) {
	MOVF       _alert_count+1, 0
	XORWF      state_consultation_last_alert_value_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__state_consultation161
	MOVF       state_consultation_last_alert_value_L0+0, 0
	XORWF      _alert_count+0, 0
L__state_consultation161:
	BTFSC      STATUS+0, 2
	GOTO       L_state_consultation94
;eau.c,586 :: 		last_alert_value = alert_count;
	MOVF       _alert_count+0, 0
	MOVWF      state_consultation_last_alert_value_L0+0
	MOVF       _alert_count+1, 0
	MOVWF      state_consultation_last_alert_value_L0+1
;eau.c,587 :: 		IntToStr(alert_count, txt_buffer);
	MOVF       _alert_count+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _alert_count+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_buffer+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;eau.c,588 :: 		Ltrim(txt_buffer);
	MOVLW      _txt_buffer+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;eau.c,590 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eau.c,591 :: 		Lcd_Out(1,1,"Alerte");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,592 :: 		Lcd_Out(2,1,txt_buffer);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt_buffer+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,593 :: 		Lcd_Out_CP(" alertes");
	MOVLW      ?lstr14_eau+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;eau.c,594 :: 		}
L_state_consultation94:
;eau.c,599 :: 		btn = check_buttons();
	CALL       _check_buttons+0
	MOVF       R0+0, 0
	MOVWF      state_consultation_btn_L0+0
;eau.c,600 :: 		if (btn == 6) {
	MOVF       R0+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_state_consultation95
;eau.c,601 :: 		EEPROM_ClearAlertCount();  // Clear EEPROM on reset
	CALL       _EEPROM_ClearAlertCount+0
;eau.c,602 :: 		system_state = STATE_VEILLE;
	CLRF       _system_state+0
;eau.c,603 :: 		return;
	GOTO       L_end_state_consultation
;eau.c,604 :: 		}
L_state_consultation95:
;eau.c,605 :: 		if (btn == 1) { system_state = STATE_RUNNING; return; }
	MOVF       state_consultation_btn_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_state_consultation96
	MOVLW      1
	MOVWF      _system_state+0
	GOTO       L_end_state_consultation
L_state_consultation96:
;eau.c,606 :: 		if (btn == 5) { system_state = STATE_INTERVENTION; return; }
	MOVF       state_consultation_btn_L0+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_state_consultation97
	MOVLW      5
	MOVWF      _system_state+0
	GOTO       L_end_state_consultation
L_state_consultation97:
;eau.c,609 :: 		if (btn == 7) { }
	MOVF       state_consultation_btn_L0+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_state_consultation98
L_state_consultation98:
;eau.c,611 :: 		Delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_state_consultation99:
	DECFSZ     R13+0, 1
	GOTO       L_state_consultation99
	DECFSZ     R12+0, 1
	GOTO       L_state_consultation99
	NOP
	NOP
;eau.c,612 :: 		}
	GOTO       L_state_consultation85
L_state_consultation86:
;eau.c,613 :: 		}
L_end_state_consultation:
	RETURN
; end of _state_consultation

_state_intervention:

;eau.c,618 :: 		void state_intervention(void) {
;eau.c,622 :: 		clear_all_outputs();
	CALL       _clear_all_outputs+0
;eau.c,623 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;eau.c,624 :: 		Lcd_Out(1,1,"prob");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr15_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,625 :: 		Lcd_Out(2,1,"resolu");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr16_eau+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;eau.c,627 :: 		blink_green_5_times();
	CALL       _blink_green_5_times+0
;eau.c,629 :: 		for (i = 0; i < 50; i++) {
	CLRF       state_intervention_i_L0+0
	CLRF       state_intervention_i_L0+1
L_state_intervention100:
	MOVLW      0
	SUBWF      state_intervention_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__state_intervention163
	MOVLW      50
	SUBWF      state_intervention_i_L0+0, 0
L__state_intervention163:
	BTFSC      STATUS+0, 0
	GOTO       L_state_intervention101
;eau.c,630 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_state_intervention103:
	DECFSZ     R13+0, 1
	GOTO       L_state_intervention103
	DECFSZ     R12+0, 1
	GOTO       L_state_intervention103
	DECFSZ     R11+0, 1
	GOTO       L_state_intervention103
	NOP
;eau.c,631 :: 		btn = check_buttons();
	CALL       _check_buttons+0
	MOVF       R0+0, 0
	MOVWF      state_intervention_btn_L0+0
;eau.c,633 :: 		if (btn == 1) { system_state = STATE_RUNNING; return; }
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_state_intervention104
	MOVLW      1
	MOVWF      _system_state+0
	GOTO       L_end_state_intervention
L_state_intervention104:
;eau.c,634 :: 		if (btn == 6) {
	MOVF       state_intervention_btn_L0+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_state_intervention105
;eau.c,635 :: 		EEPROM_ClearAlertCount();  // Clear EEPROM on reset
	CALL       _EEPROM_ClearAlertCount+0
;eau.c,636 :: 		system_state = STATE_VEILLE;
	CLRF       _system_state+0
;eau.c,637 :: 		return;
	GOTO       L_end_state_intervention
;eau.c,638 :: 		}
L_state_intervention105:
;eau.c,639 :: 		if (btn == 7) { system_state = STATE_CONSULTATION; return; }
	MOVF       state_intervention_btn_L0+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_state_intervention106
	MOVLW      4
	MOVWF      _system_state+0
	GOTO       L_end_state_intervention
L_state_intervention106:
;eau.c,629 :: 		for (i = 0; i < 50; i++) {
	INCF       state_intervention_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       state_intervention_i_L0+1, 1
;eau.c,640 :: 		}
	GOTO       L_state_intervention100
L_state_intervention101:
;eau.c,642 :: 		system_state = STATE_VEILLE;
	CLRF       _system_state+0
;eau.c,643 :: 		}
L_end_state_intervention:
	RETURN
; end of _state_intervention

_main:

;eau.c,651 :: 		void main() {
;eau.c,652 :: 		init_system();
	CALL       _init_system+0
;eau.c,654 :: 		while (1) {
L_main107:
;eau.c,656 :: 		if (system_state != STATE_VEILLE) {
	MOVF       _system_state+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main109
;eau.c,657 :: 		unsigned char q = is_quality_good();
	CALL       _is_quality_good+0
	MOVF       R0+0, 0
	MOVWF      main_q_L2+0
;eau.c,659 :: 		if (q == 0 && current_quality_state == 1) {
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main112
	MOVF       _current_quality_state+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main112
L__main134:
;eau.c,660 :: 		alert_count++;
	INCF       _alert_count+0, 1
	BTFSC      STATUS+0, 2
	INCF       _alert_count+1, 1
;eau.c,661 :: 		EEPROM_SaveAlertCount();  // Save to EEPROM for persistence
	CALL       _EEPROM_SaveAlertCount+0
;eau.c,662 :: 		current_quality_state = 0;
	CLRF       _current_quality_state+0
;eau.c,663 :: 		system_state = STATE_MEDIOCRE;
	MOVLW      3
	MOVWF      _system_state+0
;eau.c,664 :: 		}
	GOTO       L_main113
L_main112:
;eau.c,665 :: 		else if (q == 1 && current_quality_state == 0) {
	MOVF       main_q_L2+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main116
	MOVF       _current_quality_state+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main116
L__main133:
;eau.c,666 :: 		current_quality_state = 1;
	MOVLW      1
	MOVWF      _current_quality_state+0
;eau.c,667 :: 		system_state = STATE_QUALITE;
	MOVLW      2
	MOVWF      _system_state+0
;eau.c,668 :: 		}
L_main116:
L_main113:
;eau.c,669 :: 		}
L_main109:
;eau.c,671 :: 		switch (system_state) {
	GOTO       L_main117
;eau.c,674 :: 		case STATE_VEILLE:
L_main119:
;eau.c,675 :: 		clear_all_outputs();
	CALL       _clear_all_outputs+0
;eau.c,681 :: 		current_quality_state = 0;
	CLRF       _current_quality_state+0
;eau.c,682 :: 		state_veille();
	CALL       _state_veille+0
;eau.c,683 :: 		break;
	GOTO       L_main118
;eau.c,685 :: 		case STATE_RUNNING:
L_main120:
;eau.c,686 :: 		state_demarrage();
	CALL       _state_demarrage+0
;eau.c,687 :: 		check_quality();
	CALL       _check_quality+0
;eau.c,688 :: 		break;
	GOTO       L_main118
;eau.c,690 :: 		case STATE_QUALITE:
L_main121:
;eau.c,691 :: 		case STATE_MEDIOCRE:
L_main122:
;eau.c,692 :: 		check_quality();
	CALL       _check_quality+0
;eau.c,693 :: 		break;
	GOTO       L_main118
;eau.c,695 :: 		case STATE_CONSULTATION:
L_main123:
;eau.c,696 :: 		state_consultation();
	CALL       _state_consultation+0
;eau.c,697 :: 		break;
	GOTO       L_main118
;eau.c,699 :: 		case STATE_INTERVENTION:
L_main124:
;eau.c,700 :: 		state_intervention();
	CALL       _state_intervention+0
;eau.c,701 :: 		break;
	GOTO       L_main118
;eau.c,703 :: 		default:
L_main125:
;eau.c,704 :: 		system_state = STATE_VEILLE;
	CLRF       _system_state+0
;eau.c,705 :: 		break;
	GOTO       L_main118
;eau.c,706 :: 		}
L_main117:
	MOVF       _system_state+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main119
	MOVF       _system_state+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main120
	MOVF       _system_state+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main121
	MOVF       _system_state+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main122
	MOVF       _system_state+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_main123
	MOVF       _system_state+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main124
	GOTO       L_main125
L_main118:
;eau.c,707 :: 		}
	GOTO       L_main107
;eau.c,708 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
