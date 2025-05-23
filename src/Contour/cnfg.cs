namespace SevenSeals.Tss.Contour;

public static class Cnfg
{
    public static void LoadConfig(string filePath)
    {
        if (!File.Exists(filePath))
        {
            throw new FileNotFoundException("Configuration file not found.", filePath);
        }

        string[] lines = File.ReadAllLines(filePath);
        foreach (string line in lines)
        {
            // Process each line of the configuration file
            Console.WriteLine($"Processing config line: {line}");
        }
    }
}