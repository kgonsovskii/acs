using System;
using System.Collections.Generic;

namespace SevenSeals.Tss.Person;

public class Employee : PersonBase
{
    public string? EmployeeId { get; set; }
    public string? Department { get; set; }
    public string? Position { get; set; }
    public DateTime HireDate { get; set; }
    public DateTime? TerminationDate { get; set; }
    public List<Guid> AccessLevelIds { get; set; } = new();
    public List<Guid> KeyIds { get; set; } = new();
} 