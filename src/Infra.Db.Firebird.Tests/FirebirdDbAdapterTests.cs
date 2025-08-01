using Microsoft.VisualStudio.TestTools.UnitTesting;
using FluentAssertions;
using Infra.Db;
using Infra.Db.Attributes;

namespace SevenSeals.Tss.Infra.Db.Firebird.Tests;

[TestClass]
public class FirebirdDbAdapterTests
{
    private const string ConnectionString = "jdbc:firebirdsql://localhost:3050/C:/ACS2/Base/Acs.fdb;User=sysdba;Password=masterkey";

    [TestMethod]
    public void FirebirdDbAdapter_ShouldBeCreated_WithValidConnectionString()
    {
        // Act
        var adapter = new FirebirdDbAdapter<TestEntity, int>(ConnectionString);

        // Assert
        adapter.Should().NotBeNull();
    }

    [TestMethod]
    public void FirebirdDbAdapter_ShouldThrowException_WithInvalidConnectionString()
    {
        // Act & Assert
        Action act = () => new FirebirdDbAdapter<TestEntity, int>(null!);
        act.Should().Throw<ArgumentNullException>();
    }

    [TestMethod]
    public void FirebirdDbAdapter_ShouldThrowException_WithTypeWithoutDbTableAttribute()
    {
        // Act & Assert
        Action act = () => new FirebirdDbAdapter<InvalidEntity, int>(ConnectionString);
        act.Should().Throw<InvalidOperationException>()
            .WithMessage("*must be decorated with DbTableAttribute*");
    }

    [TestMethod]
    public void FirebirdDbAdapter_ShouldThrowException_WithTypeWithoutPrimaryKey()
    {
        // Act & Assert
        Action act = () => new FirebirdDbAdapter<EntityWithoutPrimaryKey, int>(ConnectionString);
        act.Should().Throw<InvalidOperationException>()
            .WithMessage("*must have a property decorated with DbPrimaryKeyAttribute*");
    }

    [TestMethod]
    public void FirebirdDbAdapter_ShouldThrowException_WithMismatchedIdType()
    {
        // Act & Assert
        Action act = () => new FirebirdDbAdapter<TestEntity, long>(ConnectionString);
        act.Should().Throw<InvalidOperationException>()
            .WithMessage("*TId type Int64 must match the primary key type Int32*");
    }

    // Test entity classes
    [DbTable(TableName = "test_entities")]
    public class TestEntity
    {
        [DbPrimaryKey]
        public int Id { get; set; }
        
        public string Name { get; set; } = string.Empty;
        
        public DateTime CreatedAt { get; set; }
    }

    public class InvalidEntity
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }

    [DbTable(TableName = "entities_without_primary_key")]
    public class EntityWithoutPrimaryKey
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }
} 