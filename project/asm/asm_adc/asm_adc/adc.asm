;/*********************************************************
;*Copyright (C), 2015, Shanghai Eastsoft Microelectronics Co., Ltd.
;*�ļ���:	adc.asm
;*��  ��:	XieYF
;*��  ��:	V1.20
;*��  ��:	2014/11/25
;*��  ��:	ADC����
;*��  ע:   ������ES7P173X
;���������ѧϰ����ʾʹ�ã����û�ֱ�����ô����������ķ��ջ������е��κη������Ρ�
;**********************************************************/
#INCLUDE<ES7P173X.INC>


ADCRH_L1    EQU  		0x00	;����A/Dת��ֵ��4λ
ADCRH_H1    EQU 	 	0x01	;����A/Dת��ֵ��8λ
ADCRH_L2    EQU  		0x02	;����A/Dת��ֵ��4λ
ADCRH_H2    EQU 	 	0x03	;����A/Dת��ֵ��8λ
D1          EQU     	0x04  	;Delay1��ֵ
D2          EQU      	0x05  	;Delay��ֵ


    ORG	    0x000
    nop
    GOTO    MAIN
    ORG     0x20
    ;******************************************************************************
    ;                      ������
    ;******************************************************************************
MAIN:
    MOVI    0x55
    MOVA    OSCP
    MOVI    0xC0
	MOVA	OSCC			;�л�������ʱ�ӣ�2MHz��
    JBS		PWEN, SW_HS		;�ȴ�����ʱ���л����
    GOTO    $-1    
    CLR     ANS0			;AIN0,AIN1���ڶ˿�����Ϊģ��˿�
    MOVI    0xE8
    MOVA    ADCC1			;����ʱ��8��ADCʱ�ӣ�ʱ��ѡ��λFosc/64�������λ����
LOOP:
    MOVI    0X1
    MOVA    ADCC0			;ʹ��ADCת������ѡ��ͨ��0   
    MOVI    0xE8
    MOVA    ADCC1			;����ʱ��8��ADCʱ�ӣ�ʱ��ѡ��ΪFosc/64�������λ���� 
    BSS     ADCC0,ADTRG     ;
AD_Wait:
    JBC	    ADCC0, ADTRG    ;�ȴ�A/Dת�����
    GOTO    AD_Wait
    MOV	    ADCRH,0			;��ȡ��8λת�����
    MOVA    ADCRH_H1
    MOV	    ADCRL,0
    MOVA    ADCRH_L1
    MOVI    0X9
    MOVA    ADCC0			;ʹ��ADCת������ѡ��ͨ��2   
    CALL    Delay           ;ADC ͨ���л���ʱ
    BSS     ADCC0,ADTRG     ;
AD_Wait1:
    JBC	    ADCC0, ADTRG	;�ȴ�A/Dת�����
    GOTO    AD_Wait1
    MOV	    ADCRH,0			;��ȡ��8λת�����
    MOVA    ADCRH_H2
    MOV	    ADCRL,0
    MOVA    ADCRH_L2
    GOTO    LOOP
    ;*****************
    ;��ʱ�ӳ���  *
    ;*****************
Delay:                      
    MOVI    0X50        ;
    MOVA    D2
Delay1:
    MOVI    0xff
    MOVA    D1
Delay2: 
    JDEC    D1,1
    GOTO Delay2
    JDEC    D2,1
    GOTO    Delay1
    RET   
    END
