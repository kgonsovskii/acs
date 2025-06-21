using Gui.Shared;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace Gui.ControlPanel.WinForms;

public class Program : GuiProgramBase<Startup>
{
    /// <summary>
    ///  The main entry point for the application.
    /// </summary>
    [STAThread]
    public static void Main(string[] args)
    {
        var program = new Program();
        program.Run(args);
    }

    protected async Task RunApp(IServiceProvider services)
    {
        ApplicationConfiguration.Initialize();

        using var scope = services.CreateScope();
        var mainForm = scope.ServiceProvider.GetRequiredService<MainForm>();

        Application.Run(mainForm);

        await Task.CompletedTask;
    }
}
