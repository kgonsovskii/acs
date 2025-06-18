using Infra.Db;

namespace SevenSeals.Tss.Shared;

internal static class Program
{
    private static void Main()
    {
        var outputDir = AppContext.BaseDirectory;
        var schemaGenerator = new PostgresSchemaGenerator();
        var dbGenerator = new PostgresDatabaseGenerator(schemaGenerator);
        var sql = dbGenerator.GenerateDatabaseSql(outputDir);

        var srcDir = FindSrcDirectory(outputDir);
        if (srcDir == null)
        {
            Console.WriteLine("Could not locate /src directory from: " + outputDir);
            return;
        }
        var solutionRoot = Directory.GetParent(srcDir)!.FullName;
        var migrationsDir = Path.Combine(solutionRoot, "migrations");
        Directory.CreateDirectory(migrationsDir);
        var outFile = Path.Combine(migrationsDir, "schema.generated.sql");
        File.WriteAllText(outFile, sql);
        Console.WriteLine($"SQL schema generated to: {outFile}");
    }

    private static string? FindSrcDirectory(string startDir)
    {
        var dir = new DirectoryInfo(startDir);
        while (dir != null && dir.Name.ToLowerInvariant() != "src")
        {
            dir = dir.Parent;
        }
        return dir?.FullName;
    }
}
