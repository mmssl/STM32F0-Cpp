#include "stm32f0xx_conf.h"
#include <stdint.h>
#include "stm32f0xx.h"

class GpioPin {
public:
    GpioPin(GPIO_TypeDef* port, uint16_t pin) : mPort(port), mPin(pin) {
        init();
    }

    bool Read() const {
        return (mPort->IDR & mPin) != 0;
    }

    void Set() {
        mPort->BSRR = mPin;
    }

    void Clear() {
        mPort->BRR = mPin;
    }

    void Toggle() {
        mPort->ODR ^= mPin;
    }

private:
    GPIO_TypeDef* mPort;
    uint16_t mPin;

    void init() {
        // Enable the clock for the GPIO port
        if(mPort == GPIOA) RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
        if(mPort == GPIOB) RCC->AHBENR |= RCC_AHBENR_GPIOBEN;
        if(mPort == GPIOC) RCC->AHBENR |= RCC_AHBENR_GPIOCEN;

        // Set the pin as a general purpose output
        mPort->MODER &= ~(3U << (2 * mPin)); // Clear mode
        mPort->MODER |= (1U << (2 * mPin));  // Set as output

        // Set output type as push-pull
        mPort->OTYPER &= ~(1U << mPin);

        // Set speed to low
        mPort->OSPEEDR &= ~(3U << (2 * mPin));
    }
};

void delay(int time) {
    while(time--) {
        __NOP();
    }
}

int main() {
    GpioPin led(GPIOC, GPIO_Pin_9);

    while(1) {
        led.Toggle();
        delay(1000000);
    }
}


