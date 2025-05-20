using System;

namespace Tss
{
    public static class Modbus
    {
        public static void ReadHoldingRegisters(int address, int count)
        {
            Console.WriteLine($"Reading {count} holding registers starting at address {address}");
        }
    }
} 