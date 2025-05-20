using System;
using System.IO;

namespace Tss
{
    public static class File
    {
        public static void WriteToFile(string filePath, string content)
        {
            try
            {
                System.IO.File.WriteAllText(filePath, content);
                Console.WriteLine($"Content written to {filePath}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error writing to file: {ex.Message}");
            }
        }
    }
} 