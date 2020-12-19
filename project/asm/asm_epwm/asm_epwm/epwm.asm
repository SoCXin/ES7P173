;/*********************************************************
;*Copyright (C), 2015, Shanghai Eastsoft Microelectronics Co., Ltd.
;*文件名:	epwm.asm
;*作  者:	XieYF
;*版  本:	V1.20
;*日  期:	2014/11/25
;*描  述:	增强型EPWM程序
;*备  注:   适用于ES7P173x
;本软件仅供学习和演示使用，对用户直接引用代码所带来的风险或后果不承担任何法律责任。
;**********************************************************/
#INCLUDE<ES7P173X.INC>
    ORG     0x000
    NOP
    GOTO    MAIN
;******************************************************************************
;                      主程序
;******************************************************************************
MAIN
    MOVI    0x55
    MOVA    OSCP
    MOVI    0xC0
	MOVA	OSCC			;切换到高速时钟（2MHz）
    JBS		PWEN, SW_HS		;等待高速时钟切换完成
    GOTO    $-1 
    MOVI    0xFF 
    MOVA    ANS0            ;设置为数字端口
    CLR     PC
    CLR     PCT
    MOVI    0x63
    MOVA    T8P2P           ;设置EPWM周期寄存器初始值（400us）
    MOVI    0x32
    MOVA    T8P2RL          ;向占空比寄存器赋初值，占空比50%                     
    MOVI    0x03
    MOVA    T8P2OC          ;PWM20/PWM21输出使能
    MOVI    0x32
    MOVA    PDD2C			;设置EPWM自动重启动，死区延时时间50us
    MOVI    0X40	
    MOVA    EPWM2C          ;设置为半桥输出,PC1/PC2为带死区时间控制的EPWM输出端口
    MOVI    0X00
    MOVA    TE2AS           ;设置TE2关断事件发生后输出端口输出低电平,禁止自动关断
    MOVI    0X85            ;设置T8P2预分频1:4，并启动T8P2
    MOVA    T8P2C 
    GOTO    $
    END

  
