;/*********************************************************
;*Copyright (C), 2015, Shanghai Eastsoft Microelectronics Co., Ltd.
;*文件名:	keyint.asm
;*作  者:	XieYF
;*版  本:	V1.20
;*日  期:	2014/11/25
;*描  述:	外部按键中断程序
;*备  注:   适用于ES7P173x
;本软件仅供学习和演示使用，对用户直接引用代码所带来的风险或后果不承担任何法律责任。
;**********************************************************/
#INCLUDE<ES7P173X.INC>

D1          EQU      0x04  ;Delay1初值
D2          EQU      0x05  ;Delay初值
PATMP       EQU      0x06

        ORG		0x000
        GOTO  	MAIN
;******************************************************************************
;                    中断服务程序
;******************************************************************************
        ORG    	0x004          ;中断入口地址
        PUSH    
        JBS     INTE0,KIE      ;判断是否允许KINT键盘中断
        GOTO	INT_EXIT
        JBS     INTF0,KIF      ;检测是否发生KINT中断
        GOTO	INT_EXIT
INT_KEYBOARD
WAIT:
        JBC     PA ,7          ;判断按键是否被按下，等待按键被按下
		GOTO    WAIT
		BCC		INTF0,KIF	   ;进入KINT7中断，清除中断标志 
		CALL    Delay
		JBC     PA ,7          ;确认按键是否真的被按下，若两次不一样则直接退出
		GOTO    INT_EXIT

        BTT     PB,5           ;PB端口输出取反
INT_EXIT
        POP
        RETIE
;******************************************************************************
;                    主程序 
;******************************************************************************
MAIN
    	MOVI    0x55
    	MOVA    OSCP
    	MOVI    0xC0
		MOVA	OSCC			;切换到高速时钟（2MHz）
		JBS		PWEN, SW_HS		;等待高速时钟切换完成
    	GOTO    $-1 
   
        MOVI    0xFF			;设置所有的模拟端口为数字端口
        MOVA    ANS0
        MOVA    ANS1
        CLR     PA
        CLR     PB
        SETR    PAT           	;设置PA全部为输入端口
        CLR     PBT
        BCC     N_PAU,7        	;使能PA7端口（KIN7）弱上拉
        CLR		INTC0			;默认中断模式，中断入口地址0x004
        BSS     INTC0,KMSK7    	;使能KINT7（PA7），其余通道关闭
        MOV		PA,0			;清除中断标志前，对端口操作一次
        BCC		INTF0,KIF		;清除KINT中断标志
        JBC		INTF0,KIF		;判断中断标志清除是否成功？
        GOTO    $-2				;中断标志清除不成功则重复进行
        BSS     INTE0,KIE 		;使能KEY中断
        BSS     INTG,GIE       	;使能全局中断 
        GOTO    $
 ;*****************
 ;延时20ms子程序  *
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
