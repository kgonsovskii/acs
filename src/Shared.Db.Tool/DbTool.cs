using Infra.Db;
using Infra.Db.AllAdapters;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Actor;
using SevenSeals.Tss.Atlas;
using SevenSeals.Tss.Contour;

namespace SevenSeals.Tss.Shared;

public class DbTool
{
    private readonly Settings _settings;
    private readonly ILogger _logger;


    private readonly string _migrationsDir = string.Empty;
    public DbTool( Settings settings, ILogger<DbTool> logger)
    {
        _logger = logger;
        _settings = settings;

        var outputDir = AppContext.BaseDirectory;
        var srcDir = FindSrcDirectory(outputDir);
        if (srcDir == null)
        {
            throw new InvalidOperationException($"Could not locate /src directory from: {outputDir}");
        }
        var solutionRoot = Directory.GetParent(srcDir)!.FullName;
        _migrationsDir = Path.Combine(solutionRoot, "migrations")!;
        Directory.CreateDirectory(_migrationsDir);

        // Set the data directory to the initdata folder
        var initdataDir = Path.Combine(outputDir, "initdata");
        if (Directory.Exists(initdataDir))
        {
            settings.DataDir = initdataDir;
            _logger.LogInformation($"Using initdata directory: {initdataDir}");
        }
        else
        {
            throw new InvalidOperationException($"initdata directory not found at {initdataDir}, using current directory");
        }
    }

    internal async Task Generate(string[] args)
    {
        var outputDir = AppContext.BaseDirectory;
        var srcDir = FindSrcDirectory(outputDir);
        if (srcDir == null)
        {
            throw new InvalidOperationException($"Could not locate /src directory from: {outputDir}");
        }

        // Create SQL subfolder and clear it
        var sqlDir = Path.Combine(_migrationsDir, "sql");
        if (Directory.Exists(sqlDir))
        {
            Directory.Delete(sqlDir, true);
        }
        Directory.CreateDirectory(sqlDir);

        // Generate schema for each SQL dialect
        foreach (var (dialect, mapping) in Adapters.Map)
        {
            Console.WriteLine($"Generating schema for {dialect}...");

            var outFile = Path.Combine(sqlDir, $"schema.{dialect}.sql");
            var mask = $"*.{dialect}.sql";
            Del(sqlDir, dialect.ToString());

            // Generate database schema
            var dbGenerator = Adapters.GetGenerator(dialect);
            var sql = dbGenerator.GenerateDatabaseSql(outputDir);
            var schemaFile = Path.Combine(sqlDir, $"schema.0.{dialect}.sql");
            await File.WriteAllTextAsync(schemaFile, sql, new System.Text.UTF8Encoding(false));
            Console.WriteLine($"SQL schema generated to: {schemaFile}");

            // Generate fake data
            var fakeGen = Adapters.GetFakeGenerator(dialect);
            var fakeDataFile = Path.Combine(sqlDir, $"schema.1.{dialect}.sql");
            var sqlFakeData = fakeGen.GenerateFakeDataSql(outputDir,
                type => type != typeof(Zone) && type != typeof(Transit) && type != typeof(Spot));
            await File.WriteAllTextAsync(fakeDataFile, sqlFakeData, new System.Text.UTF8Encoding(false));
            Console.WriteLine($"Fake data SQL generated: {fakeDataFile}");

            // Export data for each type
            Export<Spot, Guid>(dialect, sqlDir);
            Export<Transit, Guid>(dialect, sqlDir);
            Export<Zone, Guid>(dialect, sqlDir);
            Export<Pass, Guid>(dialect, sqlDir);
            Export<Member, Guid>(dialect, sqlDir);

            // Concatenate all files for this dialect
            Concat(sqlDir, mask, outFile);
            break;
        }
    }

    private void Export<T,TId>(SqlDialect dialect, string sqlDir) where T: class, IItem<TId> where TId : struct
    {
        var storage = new BaseJsonStorage<T, TId>(_settings, _logger);
        var a = storage.GetAll();
        _logger.LogInformation($"Loaded {a.Count} {typeof(T).Name} items from {_settings.DataDir}");

        var dbStorage = Adapters.GetAdapter<T, TId>(dialect, _settings.ConnectionString);

        var sqlTest = Path.Combine(sqlDir, $"schema.{typeof(T).Name}.{dialect}.sql");
        var sqlTestData = dbStorage.DumpSql(a);
        File.WriteAllText(sqlTest, sqlTestData, new System.Text.UTF8Encoding(false));
        Directory.CreateDirectory(sqlDir);
        _logger.LogInformation($"Exported {typeof(T).Name} SQL to: {sqlTest}");
    }

    public static void Del(string folderPath, string nameContain)
    {
        var all = Directory
            .EnumerateFiles(folderPath)
            .ToList();

        var toDelete = all
            .Where(a => a.Contains(nameContain, StringComparison.OrdinalIgnoreCase))
            .ToList();

        foreach (var file in toDelete)
        {
            File.Delete(file);
        }
    }

    public static void Concat(string folderPath, string fileMask, string outputFilePath)
    {
        if (File.Exists(outputFilePath))
        {
            File.Delete(outputFilePath);
        }

        var files = GetFiles(folderPath, fileMask);

        using (var writer = new StreamWriter(outputFilePath, false, new System.Text.UTF8Encoding(false)))
        {
            writer.WriteLine("\\encoding UTF8");
            foreach (var file in files)
            {
                string content = File.ReadAllText(file);
                writer.WriteLine(content);
            }
        }
    }

    private static List<string> GetFiles(string folderPath, string fileMask)
    {
        var files = Directory.GetFiles(folderPath, fileMask).ToList();

        // Keep schema versioned files first, then type-specific files with Zone before Transit
        static int GetGroup(string fileName)
        {
            var name = fileName.ToLowerInvariant();
            if (name.Contains("schema.0.")) return 0; // DDL
            if (name.Contains("schema.1.")) return 1; // fake/common data
            return 2; // typed data
        }

        static int GetTypePriority(string fileName)
        {
            // Ensure Zone goes before Transit to satisfy FKs when concatenating
            var name = fileName.ToLowerInvariant();
            if (name.Contains("zone")) return 0;
            if (name.Contains("transit")) return 2;
            return 1; // others in between
        }

        var ordered = files
            .Select((path, index) => new { path, index, name = Path.GetFileName(path) })
            .OrderBy(f => GetGroup(f.name))
            .ThenBy(f => GetTypePriority(f.name))
            .ThenBy(f => f.index) // stable order within same priority
            .Select(f => f.path)
            .ToList();

        return ordered;
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
