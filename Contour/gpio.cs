using System;

namespace Tss
{
    public static class Gpio
    {
        public static void SetPin(int pin, bool value)
        {
            Console.WriteLine($"Setting pin {pin} to {value}");
        }
    }
} 