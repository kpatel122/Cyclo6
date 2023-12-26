#include "board.h"
#include "delay.h"

/**************************************************************
***	connect:
		*	PA5---En (Select L or Hold for the En option on the screen of the closed-loop driver board)
		*	PA6---Stp
		*	PA7---Dir
		*	V+,Gnd---10~28V
		*	Gnd---Gnd

***	Precautions:
		*	Connect the wire first, then power on, do not unplug or plug when the power is on! ! !
		*	When powering on, first supply power with 10~28V, 
		* and then supply power with STM32 control board USB! ! ! 
		* Avoid damage caused by some effects.
		*	When the power is off, first cut off the USB power supply of the STM32 control board, 
		* and then cut off the 10~28V power supply.
***************************************************************/
int main (void)
{	
	__IO int32_t i = 0, j = 0;	__IO bool cntDir = false;

/**********************************************************
***	Initialize on-board peripherals
**********************************************************/
	board_init();

/**********************************************************
***	Delay 1.2 seconds to wait for the closed-loop drive board to be initialized
**********************************************************/	
	delay_ms(1200);

/**********************************************************
***	Pulse control
**********************************************************/
	while(1)
	{
/**********************************************************
***	The time interval between high and low levels, that is, 
***	half of the pulse time (control the rotation speed of the motor)
**********************************************************/
		j = 3200;	while(j--);

/**********************************************************
***	Invert D6 (Stp pin)
**********************************************************/
		GPIOA->ODR ^= GPIO_Pin_6;

/**********************************************************
***	Record the number of IO inversions (IO inversion times = 2 times the number of pulses)
**********************************************************/
		if(cntDir)	{--i;}	else	{++i;}

/**********************************************************
***	PA6 (Stp pin) is inverted 6400 times, that is, 3200 pulses are sent
*** Under 16 subdivision, send 3200 pulses, the motor rotates one circle (1.8 degree motor)
**********************************************************/
		if(i >= 6400)
		{
			GPIO_SetBits(GPIOA, GPIO_Pin_7);	cntDir = true;	delay_ms(1000);		//Switch direction rotation
		}
		else if(i == 0)
		{
			GPIO_ResetBits(GPIOA, GPIO_Pin_7);	cntDir = false;	delay_ms(1000);	//Switch direction rotation
	}
}

