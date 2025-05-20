using System;

namespace Tss
{
    public static class I2c
    {
        public static void ReadData(int address)
        {
            Console.WriteLine($"Reading data from I2C address {address}");
        }
    }
} 