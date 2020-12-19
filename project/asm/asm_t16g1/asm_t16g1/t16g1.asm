;/*********************************************************
;*Copyright (C), 2015, Shanghai Eastsoft Microelectronics Co., Ltd.
;*文件名:	t16g1.asm
;*作  者:	XieYF
;*版  本:	V1.20
;*日  期:	2014/11/25
;*描  述:	T16G1程序
;*备  注:   适用于ES7P173x
;本软件仅供学习和演示使用，对用户直接引用代码所带来的风险或后果不承担任何法律责任。
;**********************************************************/
#INCLUDE<ES7P173X.INC>

        ORG	    0x000
        GOTO	MAIN
        ;******************************************************************************
        ;                     中断服务程序                                            *
        ;******************************************************************************
        ORG         0x004               ;中断程序入口地址
        PUSH

        JBC         INTE0,T16G1IE       ;判断是否允许T16G1定时器溢出中断
        JBS         INTF0,T16G1IF       ;检测是否发生T16G1定时器溢出中断
        GOTO        INT_EXIT    
        BCC         INTF0,T16G1IF       ;T16G1定时器中断发生,清除中断标志位
        JBC         INTF0,T16G1IF       ;判断中断标志清除是否成功？
        GOTO        $-2                 ;中断标志清除不成功则重复进行
INT_T8N
        BCC         T16G1CL,T16GON      ;关闭T16G1定时器
        MOVI        0x18                ;T16G1定时器赋初值
        MOVA        T16G1L
        MOVI        0XFC
        MOVA        T16G1H
        BSS         T16G1CL,T16GON      ;打开T16G1定时器
        BTT         PC,1
INT_EXIT
        POP			
        RETIE

    ;******************************************************************************
    ;                         主程序
    ;******************************************************************************
MAIN
        MOVI        0X55
        MOVA        OSCP
        MOVI        0XC0
		MOVA		OSCC				;切换到高速时钟（2MHz）
		JBS			PWEN, SW_HS			;等待高速时钟切换完成
    	GOTO        $-1     
        MOVI        0xFF		 	
        MOVA        ANS0                ;所有模拟端口设置为数字端口
        BCC         PC,1				;PC1端口设置为输出低电平
        BCC         PCT,1               ;设置PC1端口为输出口
        CLR         INTF0               ;中断标志位清零
        MOVI        0x18                
        MOVA        T16G1L              ;T16G1定时器赋初值
        MOVI        0XFC                
        MOVA        T16G1H              ;T16G1定时器赋初值
        MOVI        0X21
        MOVA        T16G1CL             ;设置T16G1预分频比1：4, 打开T16G1定时器
        BSS         T16G1CL,T16GON      ;打开T16G1定时器
        BSS         INTE0,T16G1IE
        BSS         INTG,PEIE
        BSS         INTG,GIE
        GOTO        $
        END