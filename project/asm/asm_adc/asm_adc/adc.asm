;/*********************************************************
;*Copyright (C), 2015, Shanghai Eastsoft Microelectronics Co., Ltd.
;*文件名:	adc.asm
;*作  者:	XieYF
;*版  本:	V1.20
;*日  期:	2014/11/25
;*描  述:	ADC程序
;*备  注:   适用于ES7P173X
;本软件仅供学习和演示使用，对用户直接引用代码所带来的风险或后果不承担任何法律责任。
;**********************************************************/
#INCLUDE<ES7P173X.INC>


ADCRH_L1    EQU  		0x00	;保存A/D转换值低4位
ADCRH_H1    EQU 	 	0x01	;保存A/D转换值高8位
ADCRH_L2    EQU  		0x02	;保存A/D转换值低4位
ADCRH_H2    EQU 	 	0x03	;保存A/D转换值高8位
D1          EQU     	0x04  	;Delay1初值
D2          EQU      	0x05  	;Delay初值


    ORG	    0x000
    nop
    GOTO    MAIN
    ORG     0x20
    ;******************************************************************************
    ;                      主程序
    ;******************************************************************************
MAIN:
    MOVI    0x55
    MOVA    OSCP
    MOVI    0xC0
	MOVA	OSCC			;切换到高速时钟（2MHz）
    JBS		PWEN, SW_HS		;等待高速时钟切换完成
    GOTO    $-1    
    CLR     ANS0			;AIN0,AIN1所在端口配置为模拟端口
    MOVI    0xE8
    MOVA    ADCC1			;采样时间8个ADC时钟，时钟选择位Fosc/64，结果低位对齐
LOOP:
    MOVI    0X1
    MOVA    ADCC0			;使能ADC转换器，选中通道0   
    MOVI    0xE8
    MOVA    ADCC1			;采样时间8个ADC时钟，时钟选择为Fosc/64，结果低位对齐 
    BSS     ADCC0,ADTRG     ;
AD_Wait:
    JBC	    ADCC0, ADTRG    ;等待A/D转换完成
    GOTO    AD_Wait
    MOV	    ADCRH,0			;读取高8位转换结果
    MOVA    ADCRH_H1
    MOV	    ADCRL,0
    MOVA    ADCRH_L1
    MOVI    0X9
    MOVA    ADCC0			;使能ADC转换器，选中通道2   
    CALL    Delay           ;ADC 通道切换延时
    BSS     ADCC0,ADTRG     ;
AD_Wait1:
    JBC	    ADCC0, ADTRG	;等待A/D转换完成
    GOTO    AD_Wait1
    MOV	    ADCRH,0			;读取高8位转换结果
    MOVA    ADCRH_H2
    MOV	    ADCRL,0
    MOVA    ADCRH_L2
    GOTO    LOOP
    ;*****************
    ;延时子程序  *
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
