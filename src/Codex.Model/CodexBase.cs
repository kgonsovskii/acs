using System;

namespace SevenSeals.Tss.Codex;

public abstract class CodexBase
{
    public Guid Id { get; set; }
    public string? Name { get; set; }
    public string? Hint { get; set; }
} 