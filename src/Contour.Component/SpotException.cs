namespace SevenSeals.Tss.Contour;

public class SpotException : Exception
{
    public SpotException(Spot spot, string className, string message)
        : base($"{className}: {message}")
    {
        Spot = spot;
    }

    public Spot Spot { get; }
}
