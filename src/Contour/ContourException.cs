namespace SevenSeals.Tss.Contour;

public class ContourException: Exception
{
    public string ClassName { get; }

    public ContourException(string className, string message) : base(message)
    {
        ClassName = className;
    }
}
