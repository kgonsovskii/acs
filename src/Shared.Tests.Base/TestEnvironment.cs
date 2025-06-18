namespace SevenSeals.Tss.Shared
{
    public static class TestEnvironment
    {
        public static bool IsRunningInCi =>
            Environment.GetEnvironmentVariable("CI") != null ||
            Environment.GetEnvironmentVariable("GITHUB_ACTIONS") != null ||
            Environment.GetEnvironmentVariable("GITLAB_CI") != null ||
            Environment.GetEnvironmentVariable("GITVERSE_CI") != null;

        public static string GetCiProvider()
        {
            if (Environment.GetEnvironmentVariable("GITHUB_ACTIONS") != null)
                return "GitHub Actions";
            if (Environment.GetEnvironmentVariable("GITLAB_CI") != null)
                return "GitLab CI";
            if (Environment.GetEnvironmentVariable("GITVERSE_CI") != null)
                return "GitVerse CI";
            if (Environment.GetEnvironmentVariable("CI") != null)
                return "Unknown CI";
            return "Local";
        }

        public static void SkipIfNotCi(string reason = "This test should only run in CI environment")
        {
            if (!IsRunningInCi)
            {
                throw new SkipException(reason);
            }
        }

        public static void SkipIfCi(string reason = "This test should only run locally")
        {
            if (IsRunningInCi)
            {
                throw new SkipException(reason);
            }
        }
    }

    public class SkipException : Exception
    {
        public SkipException(string message) : base(message) { }
    }
}
