#include "stm32f0xx_conf.h"
#include <stdint.h>
// main.cpp

#include "stm32f0xx.h"
void delay(int ms);

int main() {

    // Enable clock for GPIOC
    RCC->AHBENR |= RCC_AHBENR_GPIOCEN;

    // Set PC9 as output
    GPIOC->MODER |= GPIO_MODER_MODER9_0;

    while(1) {
        // Toggle PC9
        GPIOC->ODR ^= GPIO_ODR_9;

        // Delay
        delay(500);
    }
}

void delay(int ms) {
	for(int i = 0; i<ms * (SystemCoreClock/8000); i++)
	{
		__NOP();
	}
}


