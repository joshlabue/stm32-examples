/*  Blinky
 *  Blinks an LED on PA0 
 */

#include "stm32g0xx.h"

int main()
{
    RCC->IOPENR &= ~0x3f; // Reset bits 0-5 to 0
    RCC->IOPENR |= RCC_IOPENR_GPIOAEN; // Enable the clock for GPIOA

    GPIOA->MODER &= 0x00000000; // Reset all bits to 0
    GPIOA->MODER |= 0x00000001; // Set PA0 to output mode

    while(1)
    {
        GPIOA->ODR ^= 0x00000001; // Toggle PA0
        for(int i = 0; i < 500000; i++); // Delay
    }
}
