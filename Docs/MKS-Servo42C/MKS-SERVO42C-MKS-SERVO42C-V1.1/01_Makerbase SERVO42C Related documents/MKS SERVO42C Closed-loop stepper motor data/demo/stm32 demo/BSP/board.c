#include "board.h"

/**
	*	@brief		Peripheral clock initialization
	*	@param		no
	*	@retval		no
	*/
void clock_init(void)
{
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);	//Enable GPIOA port clock
}

/**
	*	@brief		gpio pin initialization
	*	@param		no
	*	@retval		no
	*/
void gpio_init(void)
{
/**************************************************************
	*	PA5 --- En (Select L or Hold for En option on the screen of the closed-loop driver board)
	*	PA6 --- Stp
	*	PA7 --- Dir
***************************************************************/
 GPIO_InitTypeDef  GPIO_InitStructure;
 GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5 | GPIO_Pin_6 | GPIO_Pin_7;
 GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
 GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
 GPIO_Init(GPIOA, &GPIO_InitStructure);
 GPIO_ResetBits(GPIOA, GPIO_Pin_5 | GPIO_Pin_6 | GPIO_Pin_7);
}

/**
	*	@brief		Onboard initialization
	*	@param		no
	*	@retval		no
	*/
void board_init(void)
{
	clock_init();	/* Turn on peripheral clock */
	gpio_init();	/* Initialize GPIO */
}
