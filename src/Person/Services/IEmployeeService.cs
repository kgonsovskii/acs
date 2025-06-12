using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SevenSeals.Tss.Person;

namespace SevenSeals.Tss.Person.Services;

public interface IEmployeeService
{
    Task<IEnumerable<Employee>> GetEmployeesAsync();
    Task<Employee?> GetEmployeeAsync(Guid id);
    Task<IEnumerable<Employee>> GetEmployeesByDepartmentAsync(string department);
    Task<Employee> CreateEmployeeAsync(Employee employee);
    Task<bool> UpdateEmployeeAsync(Guid id, Employee employee);
    Task<bool> DeleteEmployeeAsync(Guid id);
} 