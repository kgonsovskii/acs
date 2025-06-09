namespace SevenSeals.Tss.Contour;

public class SpotException : Exception
{
    public SpotException(Contour contour, string className, string message)
        : base($"{className}: {message}")
    {
        Contour = contour;
    }

    public Contour Contour { get; }
}
