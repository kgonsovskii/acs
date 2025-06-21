using Infra.Db.Attributes;

namespace Infra.Db;

// Simple base class for Atlas entities
public abstract class AtlasBase
{
    [DbPrimaryKey]
    public Guid Id { get; set; }
}

// Table with single-column and composite indexes
[DbTable]
[DbCompositeIndex(nameof(UserId), nameof(Title), IsUnique = true)]
public class Post
{
    [DbPrimaryKey]
    public int Id { get; set; }
    [DbIndex]
    public int UserId { get; set; }
    [DbIndex(Name = "idx_title")]
    public string Title { get; set; } = string.Empty;
    [DbIndex(IsUnique = true)]
    public string Slug { get; set; } = string.Empty;
}

// Table with a unique index on Name
[DbTable]
public class User
{
    [DbPrimaryKey]
    public int Id { get; set; }
    [DbIndex(IsUnique = true)]
    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
}

// Table with multiple indexes and composite index
[DbTable]
[DbCompositeIndex(nameof(UserId), nameof(Timestamp))]
public class Activity
{
    [DbPrimaryKey]
    public int Id { get; set; }
    [DbIndex]
    public int UserId { get; set; }
    [DbIndex]
    public DateTime Timestamp { get; set; }
    public string Action { get; set; } = string.Empty;
}

[DbTable]
public class Taggable
{
    [DbPrimaryKey]
    public int Id { get; set; }
    [DbCsvString]
    public string[] Tags { get; set; } = [];
    [DbCsvString]
    public List<string> Labels { get; set; } = [];
}

public enum ChannelType { Ip, ComPort }

public class IpOptions
{
    public string IpAddress { get; set; } = string.Empty;
    public int Port { get; set; }
}

public class ComPortOptions
{
    public string PortName { get; set; } = string.Empty;
    public int BaudRate { get; set; }
}

[DbTable]
public class PolyModel
{
    [DbPrimaryKey] public Guid Id { get; set; }
    [DbEnumTable] public ChannelType ChannelType { get; set; }
    [DbPolymorphicTable(typeof(IpOptions), typeof(ComPortOptions))]
    public object ChannelOptions { get; set; } = null!;
}

// Example enums (no attributes on enums themselves)
public enum KeyType
{
    Physical = 1,
    Virtual = 2,
    Card = 3,
    Mobile = 4
}

public enum KeyStatus
{
    Active = 1,
    Lost = 2,
    Stolen = 3,
    Expired = 4,
    Deactivated = 5
}

public enum ActorType
{
    Person = 1,
    Drone = 2
}

public enum StorageType
{
    Json = 1,
    Postgres = 2,
    Firebird = 3,
    MongoDb = 4,
    MySql = 5,
    MsSql = 6
}

// Example table that uses enum types
[DbTable]
public class Key
{
    [DbPrimaryKey]
    public Guid Id { get; set; }
    public string? KeyNumber { get; set; }
    [DbEnumTable(DescriptionColumnName = "description")] public KeyType Type { get; set; }
    [DbEnumTable(DescriptionColumnName = "description")] public KeyStatus Status { get; set; }
    public DateTime IssueDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
}

[DbTable]
public class Actor
{
    [DbPrimaryKey]
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    [DbEnumTable(TableName = "actor_types", DescriptionColumnName = "description")] public ActorType Type { get; set; }
    [DbEnumTable(TableName = "storage_types", DescriptionColumnName = "description")] public StorageType PreferredStorage { get; set; }
}

// Example table with various nullable types
[DbTable]
public class NullableTestModel
{
    [DbPrimaryKey]
    public Guid Id { get; set; }

    // Nullable reference types
    public string? NullableString { get; set; }
    public string RequiredString { get; set; } = string.Empty;

    // Nullable value types
    public int? NullableInt { get; set; }
    public int RequiredInt { get; set; }

    public long? NullableLong { get; set; }
    public long RequiredLong { get; set; }

    public DateTime? NullableDateTime { get; set; }
    public DateTime RequiredDateTime { get; set; }

    public bool? NullableBool { get; set; }
    public bool RequiredBool { get; set; }

    public double? NullableDouble { get; set; }
    public double RequiredDouble { get; set; }

    public Guid? NullableGuid { get; set; }
    public Guid RequiredGuid { get; set; }

    public byte? NullableByte { get; set; }
    public byte RequiredByte { get; set; }

    // Nullable enums
    [DbEnumTable] public KeyType? NullableKeyType { get; set; }
    [DbEnumTable] public KeyType RequiredKeyType { get; set; }

    // Arrays and collections
    [DbCsvString] public string[]? NullableStringArray { get; set; }
    [DbCsvString] public string[] RequiredStringArray { get; set; } = [];

    [DbCsvString] public List<string>? NullableStringList { get; set; }
    [DbCsvString] public List<string> RequiredStringList { get; set; } = [];
}

public enum ZoneType
{
    Building,
    Floor,
    Room,
    Area
}

[DbTable]
public class Zone : AtlasBase
{
    [DbEnumTable]
    public ZoneType Type { get; set; }

    public Guid? ParentId { get; set; }

    [DbChildTable]
    public List<Zone> Children { get; set; } = [];
}

[DbTable]
public class Department : AtlasBase
{
    public string Name { get; set; } = string.Empty;

    [DbChildTable(TableName = "department_employee")]
    public List<Employee> Employees { get; set; } = [];
}

[DbTable]
public class Employee : AtlasBase
{
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;

    [DbEnumTable]
    public EmployeeRole Role { get; set; }
}

public enum EmployeeRole
{
    Manager,
    Developer,
    Tester,
    Designer
}

[DbTable]
public class Project : AtlasBase
{
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;

    [DbChildTable]
    public List<Zena> Zenas { get; set; } = [];

    [DbChildTable]
    public List<TeamMember> TeamMembers { get; set; } = [];
}

[DbTable]
public class Zena : AtlasBase
{
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;

    [DbEnumTable]
    public TaskStatus Status { get; set; }

    [DbEnumTable]
    public TaskPriority Priority { get; set; }
}

public enum TaskStatus
{
    Todo,
    InProgress,
    Review,
    Done
}

public enum TaskPriority
{
    Low,
    Medium,
    High,
    Critical
}

[DbTable]
public class TeamMember : AtlasBase
{
    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;

    [DbEnumTable]
    public TeamRole Role { get; set; }
}

public enum TeamRole
{
    Lead,
    Member,
    Observer
}
