using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Person.Services;

namespace SevenSeals.Tss.Person.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddPersonServices(this IServiceCollection services)
    {
        services.AddScoped<IEmployeeService, EmployeeService>();
        services.AddScoped<IKeyService, KeyService>();
        return services;
    }
} 