namespace SevenSeals.Tss.Contour;

public class AppState
{
    public readonly CancellationTokenSource CancellationTokenSource = new();

    public CancellationToken CancellationToken => CancellationTokenSource.Token;
}
