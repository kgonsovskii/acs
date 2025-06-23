using Gui.Shared;

namespace Gui.WinForms;

public class Program : GuiProgramBase<Startup>
{
    [STAThread]
    public static void Main(string[] args)
    {
        var program = new Program();
        program.Run(args);
    }
}
