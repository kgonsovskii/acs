using System.Collections.Concurrent;
using Microsoft.Extensions.Logging;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SevenSeals.Tss.Shared.Tests.Base;

public class TestLogProvider : ILoggerProvider
{
    private readonly TestContext _testContext;
    private readonly ConcurrentDictionary<string, TestLogger> _loggers = new();

    public TestLogProvider(TestContext testContext)
    {
        _testContext = testContext;
    }

    public ILogger CreateLogger(string categoryName)
    {
        return _loggers.GetOrAdd(categoryName, name => new TestLogger(name, _testContext));
    }

    public void Dispose() { }
}

public class TestLogger : ILogger
{
    private readonly string _categoryName;
    private readonly TestContext _testContext;

    public TestLogger(string categoryName, TestContext testContext)
    {
        _categoryName = categoryName;
        _testContext = testContext;
    }

    public IDisposable BeginScope<TState>(TState state) => default!;

    public bool IsEnabled(LogLevel logLevel) => true;

    public void Log<TState>(LogLevel logLevel, EventId eventId,
        TState state, Exception exception, Func<TState, Exception?, string> formatter)
    {
        _testContext.WriteLine($"[{logLevel}] {_categoryName}: {formatter(state, exception)}");
    }
}

