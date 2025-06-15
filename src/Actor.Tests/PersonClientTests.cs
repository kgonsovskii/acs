using Shared.Tests;
using Xunit;

namespace SevenSeals.Tss.Actor;

public class ActorClientTests : TestBase
{
    private readonly PersonClient _personClient;

    public ActorClientTests()
    {
        _personClient = GetClient<PersonClient>();
    }

    [Fact]
    public async Task GetEmployees_ShouldReturnEmployees()
    {
        // Arrange
        var employee1 = await _personClient.CreateEmployeeAsync(new Employee
        {
            FirstName = "John",
            LastName = "Doe",
            Department = "IT"
        });
        var employee2 = await _personClient.CreateEmployeeAsync(new Employee
        {
            FirstName = "Jane",
            LastName = "Smith",
            Department = "HR"
        });

        // Act
        var result = await _personClient.GetEmployeesAsync();

        // Assert
        Assert.Contains(result, e => e.Id == employee1.Id && e.FirstName == employee1.FirstName);
        Assert.Contains(result, e => e.Id == employee2.Id && e.FirstName == employee2.FirstName);
    }

    [Fact]
    public async Task CreateEmployee_ShouldReturnCreatedEmployee()
    {
        // Arrange
        var employee = new Employee
        {
            FirstName = "John",
            LastName = "Doe",
            Department = "IT",
            Position = "Developer"
        };

        // Act
        var result = await _personClient.CreateEmployeeAsync(employee);

        // Assert
        Assert.NotEqual(Guid.Empty, result.Id);
        Assert.Equal(employee.FirstName, result.FirstName);
        Assert.Equal(employee.LastName, result.LastName);
        Assert.Equal(employee.Department, result.Department);
        Assert.Equal(employee.Position, result.Position);
    }

    [Fact]
    public async Task GetKeys_ShouldReturnKeys()
    {
        // Arrange
        var key1 = await _personClient.CreateKeyAsync(new Key
        {
            KeyNumber = "K001",
            Type = KeyType.Physical
        });
        var key2 = await _personClient.CreateKeyAsync(new Key
        {
            KeyNumber = "K002",
            Type = KeyType.Virtual
        });

        // Act
        var result = await _personClient.GetKeysAsync();

        // Assert
        Assert.Contains(result, k => k.Id == key1.Id && k.KeyNumber == key1.KeyNumber);
        Assert.Contains(result, k => k.Id == key2.Id && k.KeyNumber == key2.KeyNumber);
    }

    [Fact]
    public async Task AssignKeyToPerson_ShouldSucceed()
    {
        // Arrange
        var employee = await _personClient.CreateEmployeeAsync(new Employee
        {
            FirstName = "John",
            LastName = "Doe"
        });
        var key = await _personClient.CreateKeyAsync(new Key
        {
            KeyNumber = "K001",
            Type = KeyType.Physical
        });

        // Act
        await _personClient.AssignKeyToPersonAsync(key.Id, employee.Id);

        // Assert
        var keys = await _personClient.GetKeysByPersonAsync(employee.Id);
        Assert.Contains(keys, k => k.Id == key.Id);
    }

    [Fact]
    public async Task DeactivateKey_ShouldSucceed()
    {
        // Arrange
        var key = await _personClient.CreateKeyAsync(new Key
        {
            KeyNumber = "K001",
            Type = KeyType.Physical
        });

        // Act
        await _personClient.DeactivateKeyAsync(key.Id, KeyStatus.Lost);

        // Assert
        var updatedKey = await _personClient.GetKeyAsync(key.Id);
        Assert.Equal(KeyStatus.Lost, updatedKey!.Status);
    }

    [Fact]
    public async Task GetEmployeesByDepartment_ShouldReturnFilteredEmployees()
    {
        // Arrange
        var department = "IT";
        var employee1 = await _personClient.CreateEmployeeAsync(new Employee
        {
            FirstName = "John",
            LastName = "Doe",
            Department = department
        });
        var employee2 = await _personClient.CreateEmployeeAsync(new Employee
        {
            FirstName = "Jane",
            LastName = "Smith",
            Department = department
        });
        await _personClient.CreateEmployeeAsync(new Employee
        {
            FirstName = "Bob",
            LastName = "Johnson",
            Department = "HR"
        });

        // Act
        var result = await _personClient.GetEmployeesByDepartmentAsync(department);

        // Assert
        Assert.Equal(2, result.Count);
        Assert.All(result, e => Assert.Equal(department, e.Department));
        Assert.Contains(result, e => e.Id == employee1.Id);
        Assert.Contains(result, e => e.Id == employee2.Id);
    }
}
