#include "delay.h"

/**
	* SystemCoreClock/1000000     1us  interrupt once
	* SystemCoreClock/100000			10us interrupt once
	* SystemCoreClock/1000				1ms  interrupt once
	*/
void delay_ms(uint32_t u32Cnt)
{
	uint32_t u32end;

	SysTick->LOAD = 0xFFFFFF;
	SysTick->VAL  = 0;
	SysTick->CTRL = SysTick_CTRL_ENABLE_Msk | SysTick_CTRL_CLKSOURCE_Msk;
	
	while(u32Cnt-- > 0)
	{
		SysTick->VAL = 0;
		u32end = 0x1000000 - SystemCoreClock / 1000;
		while(SysTick->VAL > u32end)
		{
			;
		}
	}
	
	SysTick->CTRL = ( SysTick->CTRL & ( ~SysTick_CTRL_ENABLE_Msk ) );
}
