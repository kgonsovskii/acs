using System;
using System.Threading;

namespace Tss
{
    public static class Timer
    {
        public static void StartTimer(int interval)
        {
            System.Timers.Timer timer = new System.Timers.Timer(interval);
            timer.Elapsed += (sender, e) => Console.WriteLine("Timer elapsed.");
            timer.Start();
        }
    }
} 