namespace SevenSeals.Tss.Shared;

public class ApiException(string message) : InvalidOperationException(message);
