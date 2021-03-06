/*********************************************************
*Copyright (C), 2015, Shanghai Eastsoft Microelectronics Co., Ltd.
*文件名:	t16g1.c
*作  者:	XieYF
*版  本:	V1.20
*日  期:	2014/11/25
*描  述:	T16G1程序
*备  注:    适用于ES7P173x
本软件仅供学习和演示使用，对用户直接引用代码所带来的风险或后果不承担任何法律责任。
**********************************************************/
#include <hic.h>

//*************************************************************************
//                    中断服务程序
//*************************************************************************
void isr(void) interrupt
{
    if(T16G1IE&&T16G1IF)    //进入T16G中断
    {						        
        T16G1IF = 0;        //清除T16G中断标志
        T16GON = 0;         //关闭T16G定时器
        T16G1L	= 0x18;     //重载T16G寄存器值
        T16G1H	= 0xFC;
        T16GON = 1;         //打开T16G定时器
        PC1 = PC1^1;        //输出端口取反
    }
}
//*************************************************************************
//                      主程序
//*************************************************************************
void main()
{
    OSCP = 0x55;
	OSCC = 0xC0;	    //切换到高速时钟（2MHz）
    while (!SW_HS);	    //等待高速时钟切换完成
      
    ANS0 = 0xFF;	    //设置PC1端口为数字端口
    PC1 = 0;		    //设置PC1端口输出低电平
    PCT1 = 0; 		    //设置PC1端口为输出口    
    INTF0 = 0;			//清除T161G中断标志
    INTG = 0x00;	    //默认中断模式，中断入口地址0x004    
    T16G1L = 0x18;		//设置T16G11寄存器值
    T16G1H = 0xFC;		//设置T16G1H寄存器值    
    T16G1CH = 0x00;		//设置T16G1为定时器模式
    T16G1CL = 0x21;		//设置T16G1预分频比1：4, 打开T16G1定时器
    T16G1IE = 1;		//T16G1定时器中断使能
    PEIE = 1;			//使能外设中断
    GIE = 1;			//使能全局中断
    while(1);
}
