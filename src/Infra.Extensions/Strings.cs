namespace Infra.Extensions;

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

    public static string ToSnakeCase(this string input)
    {
        if (string.IsNullOrEmpty(input))
            return input;

        var result = "";
        for (int i = 0; i < input.Length; i++)
        {
            var c = input[i];
            if (char.IsUpper(c))
            {
                if (i > 0)
                    result += "_";
                result += char.ToLowerInvariant(c);
            }
            else
            {
                result += c;
            }
        }

        return result;
    }
}
