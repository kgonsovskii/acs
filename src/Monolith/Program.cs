using System.Diagnostics.CodeAnalysis;
using SevenSeals.Tss.Shared;
using System.Reflection;

namespace SevenSeals.Tss.Monolith;

[SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
public class Program
{
    private static readonly CancellationTokenSource CancellationTokenSource = new();
    private static readonly List<Task> ServiceTasks = [];

    public static async Task Main(string[] args)
    {
        Console.WriteLine("Starting all services...");

        Console.CancelKeyPress += (_, e) =>
        {
            e.Cancel = true;
            CancellationTokenSource.Cancel();
        };

        try
        {
            var programBaseType = typeof(ProgramBase);

            var loadedAssemblies = AppDomain.CurrentDomain.GetAssemblies().ToList();
            var loadedNames = loadedAssemblies.Select(a => a.GetName().Name).ToHashSet();

            var outputDir = AppDomain.CurrentDomain.BaseDirectory;
            foreach (var dll in Directory.GetFiles(outputDir, "*.dll"))
            {
                var name = Path.GetFileNameWithoutExtension(dll);
                if (!loadedNames.Contains(name))
                {
                    loadedAssemblies.Add(Assembly.LoadFrom(dll));
                }
            }

            var programTypes = loadedAssemblies
                .SelectMany(a => a.GetTypes())
                .Where(t => programBaseType.IsAssignableFrom(t)
                            && t != programBaseType
                            && !t.IsAbstract
                            && !t.FullName!.Contains("Tests")
                            && !t.FullName!.Contains("Shared")
                            && t.GetConstructor(Type.EmptyTypes) != null)
                .ToList();

            foreach (var type in programTypes)
            {
                var instance = (ProgramBase)Activator.CreateInstance(type)!;
                StartService(instance, args);
            }

            Console.WriteLine("All services started. Press Ctrl+C to stop.");

            await Task.Delay(-1, CancellationTokenSource.Token);
        }
        catch (OperationCanceledException)
        {
            Console.WriteLine("\nShutting down services...");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Fatal error: {ex.Message}");
            throw;
        }
        finally
        {
            if (ServiceTasks.Any())
            {
                await Task.WhenAll(ServiceTasks);
            }

            Console.WriteLine("All services stopped.");
        }
    }

    private static void StartService(ProgramBase program, string[] args)
    {
        var serviceName = program.GetType().Name.Replace("Program", "");

        var task = Task.Run(() =>
        {
            try
            {
                Console.WriteLine($"Starting {serviceName} service...");
                program.Run(args);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error in {serviceName} service: {ex.Message}");
                CancellationTokenSource.Cancel();
                throw;
            }
        }, CancellationTokenSource.Token);

        ServiceTasks.Add(task);
    }
}
