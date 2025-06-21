namespace Infra;

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


    public static string ToPascalCase(this string input)
    {
        if (string.IsNullOrEmpty(input))
            return input;

        // Handle snake_case
        if (input.Contains('_'))
        {
            var parts = input.Split('_');
            var result = "";
            foreach (var part in parts)
            {
                if (!string.IsNullOrEmpty(part))
                {
                    result += char.ToUpperInvariant(part[0]) + part.Substring(1).ToLowerInvariant();
                }
            }
            return result;
        }

        // Handle camelCase or regular string
        return char.ToUpperInvariant(input[0]) + input.Substring(1);
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
