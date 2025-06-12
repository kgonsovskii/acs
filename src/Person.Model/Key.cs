using System;

namespace SevenSeals.Tss.Person;

public class Key : PersonBase
{
    public string? KeyNumber { get; set; }
    public KeyType Type { get; set; }
    public KeyStatus Status { get; set; }
    public DateTime IssueDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public Guid? AssignedToPersonId { get; set; }
}

public enum KeyType
{
    Physical,
    Virtual,
    Card,
    Mobile
}

public enum KeyStatus
{
    Active,
    Lost,
    Stolen,
    Expired,
    Deactivated
} 