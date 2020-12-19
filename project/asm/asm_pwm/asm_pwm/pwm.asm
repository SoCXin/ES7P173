;/*********************************************************
;*Copyright (C), 2015, Shanghai Eastsoft Microelectronics Co., Ltd.
;*�ļ���:	pwm.asm
;*��  ��:	XieYF
;*��  ��:	V1.20
;*��  ��:	2014/11/25
;*��  ��:	��׼PWM����
;*��  ע:   ������ES7P173x
;����������ѧϰ����ʾʹ�ã����û�ֱ�����ô����������ķ��ջ������е��κη������Ρ�
;**********************************************************/
#INCLUDE<ES7P173X.INC>

ORG			0x000
GOTO        MAIN
;******************************************************************************
;*                      ������                                                *
;******************************************************************************
MAIN
    MOVI    0x55
    MOVA    OSCP
    MOVI    0xC0
	MOVA	OSCC			;�л�������ʱ�ӣ�2MHz��
    JBS		PWEN, SW_HS		;�ȴ�����ʱ���л����
    GOTO    $-1    
    MOVI    0xFF 
    MOVA    ANS0			;����Ϊ���ֶ˿�
    BCC     PCT,3			;PWM10��� 
    BSS     T8P1OC,PWM10EN	;ʹ��PWM10���
    MOVI    0x63			;����PWM���ڼĴ�����ʼֵ��400us��
    MOVA    T8P1P
    MOVI    0x32			;��ռ�ձȼĴ�������ֵ��ռ�ձ�50%
    MOVA    T8P1RL
    MOVI    0x85
    MOVA    T8P1C			;T8P1ʹ�ܣ��趨Ԥ��Ƶ1:4�����Ƶ��Ч,PWM���ģʽ
    GOTO    $
    END

  