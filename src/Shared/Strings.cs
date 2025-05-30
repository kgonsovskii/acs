namespace SevenSeals.Tss.Shared;

public static class Strings
{
    public static string ToCamelCase(this string input)
    {
        if (string.IsNullOrEmpty(input))
            return input;

        const string suffix = "Request";
        if (input.EndsWith(suffix) && input.Length > suffix.Length)
            input = input.Substring(0, input.Length - suffix.Length);

        return char.ToLowerInvariant(input[0]) + input.Substring(1);
    }
}
