/*********************************************************
*Copyright (C), 2015, Shanghai Eastsoft Microelectronics Co., Ltd.
*�ļ���:	t8n.c
*��  ��:	XieYF
*��  ��:	V1.20
*��  ��:	2014/11/25
*��  ��:	��ʱ������
*��  ע:    ������ES7P173x
����������ѧϰ����ʾʹ�ã����û�ֱ�����ô����������ķ��ջ������е��κη������Ρ�
**********************************************************/
#include <hic.h>

//*************************************************************************
//                          �жϷ������                                        
//*************************************************************************
void isr(void) interrupt
{
    if(T8NIE&&T8NIF)        //����T8N��ʱ���ж�		
    {					        
        T8NIF = 0;		    //��T8N�жϱ�־
        T8N = T8N+6;		//����T8N��ֵ�����Ͻ����ж�ʱ��
        PB5 = PB5^1;		//����˿�ȡ��
    }
}
//*************************************************************************
//                             ������
//*************************************************************************
void main()
{
        OSCP = 0x55;		//ʱ�ӿ���д��������
		OSCC = 0xC0;	    //�л�������ʱ�ӣ�2MHz��
		while (!SW_HS);	    //�ȴ�����ʱ���л����

        ANS0 = 0xFF;        //����PB5Ϊ���ֶ˿�
        PB5 = 0;		    //����PB5�˿�����͵�ƽ
        PBT5 = 0; 		    //����PB5�˿�Ϊ�����      
        T8NC = 0x07;	    //����T8NΪ��ʱ��ģʽ����Ƶ��Ϊ1:256 
        T8N = 6;		    //�趨ʱ����ֵ
        T8NPRE = 1;		    //ʹ��Ԥ��Ƶ��
        T8NIE = 1;		    //ʹ��T8N��ʱ���ж�
        GIE = 1;		    //ʹ��ȫ���ж�
        T8NEN = 1;		    //��T8NEN��ʱ��
        while(1);
}