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


    private  readonly string _migrationsDir;
    public DbTool( Settings settings, ILogger<DbTool> logger)
    {
        _logger = logger;
        _settings = settings;
        settings.DataDir = "./";

        var outputDir = AppContext.BaseDirectory;
        var srcDir = FindSrcDirectory(outputDir);
        if (srcDir == null)
        {
            Console.WriteLine("Could not locate /src directory from: " + outputDir);
            return;
        }
        var solutionRoot = Directory.GetParent(srcDir)!.FullName;
        _migrationsDir = Path.Combine(solutionRoot, "migrations")!;
        Directory.CreateDirectory(_migrationsDir);
    }

    internal async Task Generate(string[] args)
    {

        var outputDir = AppContext.BaseDirectory;
        var dbGenerator = new PostgresDatabaseGenerator();
        var sql = dbGenerator.GenerateDatabaseSql(outputDir);

        var srcDir = FindSrcDirectory(outputDir);
        if (srcDir == null)
        {
            Console.WriteLine("Could not locate /src directory from: " + outputDir);
            return;
        }

        Del(_migrationsDir, "*.sql");

        var outFile = Path.Combine(_migrationsDir, "schema.0.sql");
        await File.WriteAllTextAsync(outFile, sql, new System.Text.UTF8Encoding(false));
        Console.WriteLine($"SQL schema generated to: {outFile}");


        var fakeGen = new PostgresFakeGenerator();
        var sqlFake = Path.Combine(_migrationsDir, "schema.1.sql");
        var sqlFakeData = fakeGen.GenerateFakeDataSql(outputDir,
            type => type != typeof(Zone) && type != typeof(Transit) && type != typeof(Spot));
        await File.WriteAllTextAsync(sqlFake, sqlFakeData, new System.Text.UTF8Encoding(false));
        Console.WriteLine($"Fake data SQL generated: {sqlFake}");

        Export<Spot, Guid>();
        Export<Transit, Guid>();
        Export<Zone, Guid>();
        Export<Pass, Guid>();
        Export<Member, Guid>();

        outFile = Path.Combine(_migrationsDir, "schema.sql");
        Concat(_migrationsDir, "*.sql", outFile);
    }

    private void Export<T,TId>() where T: class, IItem<TId> where TId : struct
    {
        var storage = new BaseJsonStorage<T, TId>(_settings, _logger);
        var a = storage.GetAll();
        var dbStorage = Adapters.GetAdapter<T, TId>(_settings.SqlDialect, _settings.ConnectionString);

        var sqlTest = Path.Combine(_migrationsDir, $"schema.{typeof(T).Name}.sql");
        var sqlTestData = dbStorage.DumpSql(a);
        File.WriteAllText(sqlTest, sqlTestData, new System.Text.UTF8Encoding(false));
        Directory.CreateDirectory(_migrationsDir);
    }

    public static void Del(string folderPath, string fileMask)
    {
        var files = Directory.GetFiles(folderPath, fileMask);
        foreach (var file in files)
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

        var files = Directory.GetFiles(folderPath, fileMask);

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
