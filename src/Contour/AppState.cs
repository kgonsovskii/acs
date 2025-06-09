namespace SevenSeals.Tss.Contour;

public class AppState
{
    public readonly CancellationTokenSource CancellationTokenSource = new CancellationTokenSource();

    public CancellationToken CancellationToken => CancellationTokenSource.Token;
}
