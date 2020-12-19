;/*********************************************************
;*Copyright (C), 2015, Shanghai Eastsoft Microelectronics Co., Ltd.
;*文件名:	t8n.asm
;*作  者:	XieYF
;*版  本:	V1.20
;*日  期:	2014/11/25
;*描  述:	定时器程序
;*备  注:   适用于ES7P173x
;本软件仅供学习和演示使用，对用户直接引用代码所带来的风险或后果不承担任何法律责任。
;**********************************************************/
#INCLUDE<ES7P173X.INC>

        ORG			0x000
        GOTO		MAIN
        ;******************************************************************************
        ;                     中断服务程序                                            *
        ;******************************************************************************
        ORG    		0x004           ;中断程序入口地址
        PUSH

        JBC         INTE0,T8NIE     ;判断是否允许T8N定时器溢出中断
        JBS         INTF0,T8NIF     ;检测是否发生T8N定时器溢出中断
        GOTO        INT_EXIT
        BCC         INTF0,T8NIF     ;T8N定时器中断发生,清除中断标志位
        JBC         INTF0,T8NIF     ;判断中断标志清除是否成功？
        GOTO        $-2             ;中断标志清除不成功则重复进行
INT_T8N
        MOVI        .6              ;T8N定时器赋初值
        ADD         T8N,1
        BTT         PB,5            ;PA1端口取反输出
INT_EXIT
        POP			
        RETIE

    ;******************************************************************************
    ;                         主程序
    ;******************************************************************************
MAIN
        MOVI	    0x55
        MOVA	    OSCP            ;时钟控制写保护解锁
        MOVI	    0xC0
		MOVA		OSCC			;切换到高速时钟（2MHz）
		JBS			PWEN, SW_HS		;等待高速时钟切换完成
        GOTO	    $-1
        MOVI        0xFF		 	
        MOVA        ANS0            ;所有模拟端口设置为数字端口
        CLR         PBT	            ;PB端口所有I/O全部设置为输出口
        CLR         INTG			;采用默认中断模式,中断入口地址0x004
T8N_INI
        MOVI        0x7	 			;设定T8N为定时器模式，预分频器分配给T8N，分频比1:256
        MOVA        T8NC
        BSS         T8NC,T8NPRE 
        CLR         INTC0           ;清除所有中断(含T8N)标志
        JBC         INTC0,T8NIF     ;判断中断标志清除是否成功？
        GOTO        $-2             ;中断标志清除不成功则重复进行
        MOVI        .6				;T8N定时器赋初值
        MOVA        T8N
        BSS         T8NC, T8NEN     ;打开T8N定时器
        BSS         INTE0,T8NIE     ;使能T8N定时器中断
        BSS         INTG,GIE	    ;使能全局中断
 LOOP:
        NOP
        GOTO		LOOP
        END
