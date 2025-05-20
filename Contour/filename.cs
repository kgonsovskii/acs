using System;
using System.IO;

namespace Tss
{
    public static class Filename
    {
        public static string GetFileName(string filePath)
        {
            return Path.GetFileName(filePath);
        }
    }
} 