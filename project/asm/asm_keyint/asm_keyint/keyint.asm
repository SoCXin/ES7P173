;/*********************************************************
;*Copyright (C), 2015, Shanghai Eastsoft Microelectronics Co., Ltd.
;*�ļ���:	keyint.asm
;*��  ��:	XieYF
;*��  ��:	V1.20
;*��  ��:	2014/11/25
;*��  ��:	�ⲿ�����жϳ���
;*��  ע:   ������ES7P173x
;���������ѧϰ����ʾʹ�ã����û�ֱ�����ô����������ķ��ջ������е��κη������Ρ�
;**********************************************************/
#INCLUDE<ES7P173X.INC>

D1          EQU      0x04  ;Delay1��ֵ
D2          EQU      0x05  ;Delay��ֵ
PATMP       EQU      0x06

        ORG		0x000
        GOTO  	MAIN
;******************************************************************************
;                    �жϷ������
;******************************************************************************
        ORG    	0x004          ;�ж���ڵ�ַ
        PUSH    
        JBS     INTE0,KIE      ;�ж��Ƿ�����KINT�����ж�
        GOTO	INT_EXIT
        JBS     INTF0,KIF      ;����Ƿ���KINT�ж�
        GOTO	INT_EXIT
INT_KEYBOARD
WAIT:
        JBC     PA ,7          ;�жϰ����Ƿ񱻰��£��ȴ�����������
		GOTO    WAIT
		BCC		INTF0,KIF	   ;����KINT7�жϣ�����жϱ�־ 
		CALL    Delay
		JBC     PA ,7          ;ȷ�ϰ����Ƿ���ı����£������β�һ����ֱ���˳�
		GOTO    INT_EXIT

        BTT     PB,5           ;PB�˿����ȡ��
INT_EXIT
        POP
        RETIE
;******************************************************************************
;                    ������ 
;******************************************************************************
MAIN
    	MOVI    0x55
    	MOVA    OSCP
    	MOVI    0xC0
		MOVA	OSCC			;�л�������ʱ�ӣ�2MHz��
		JBS		PWEN, SW_HS		;�ȴ�����ʱ���л����
    	GOTO    $-1 
   
        MOVI    0xFF			;�������е�ģ��˿�Ϊ���ֶ˿�
        MOVA    ANS0
        MOVA    ANS1
        CLR     PA
        CLR     PB
        SETR    PAT           	;����PAȫ��Ϊ����˿�
        CLR     PBT
        BCC     N_PAU,7        	;ʹ��PA7�˿ڣ�KIN7��������
        CLR		INTC0			;Ĭ���ж�ģʽ���ж���ڵ�ַ0x004
        BSS     INTC0,KMSK7    	;ʹ��KINT7��PA7��������ͨ���ر�
        MOV		PA,0			;����жϱ�־ǰ���Զ˿ڲ���һ��
        BCC		INTF0,KIF		;���KINT�жϱ�־
        JBC		INTF0,KIF		;�ж��жϱ�־����Ƿ�ɹ���
        GOTO    $-2				;�жϱ�־������ɹ����ظ�����
        BSS     INTE0,KIE 		;ʹ��KEY�ж�
        BSS     INTG,GIE       	;ʹ��ȫ���ж� 
        GOTO    $
 ;*****************
 ;��ʱ20ms�ӳ���  *
 ;*****************
Delay:                      
        MOVI    0X3       ;
        MOVA    D2
Delay1:
        MOVI    0xe8
        MOVA    D1
Delay2: 
        JDEC    D1,1
        GOTO    Delay2
        JDEC    D2,1
        GOTO    Delay1
        RET    
        END
