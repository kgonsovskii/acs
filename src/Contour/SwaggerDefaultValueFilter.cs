using System.ComponentModel;
using System.Reflection;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Contour;

public class ContourSwaggerDefaultValueFilter : ISchemaFilter
{
    private readonly List<Spot>? _map;

    public ContourSwaggerDefaultValueFilter(IServiceProvider serviceProvider)
    {
        _map = serviceProvider.GetRequiredService<ISpotStorage>().GetAll().ToList();
    }

    public void Apply(OpenApiSchema schema, SchemaFilterContext context)
    {
        if (_map == null)
            return;
        if (schema.Properties == null || context.Type == null)
            return;

        var properties = context.Type.GetProperties();
        foreach (var property in properties)
        {
            var defaultValueAttribute = property.GetCustomAttribute<DefaultValueAttribute>();

            var propertyName = char.ToLowerInvariant(property.Name[0]) + property.Name.Substring(1);
            if (schema.Properties.ContainsKey(propertyName))
            {
                var defaultValue = GetValueFromSettings(property.Name, context.Type) ?? defaultValueAttribute?.Value;
                if (defaultValue == null)
                    continue;
                schema.Properties[propertyName].Default = OpenApiAnyFactory.CreateFromJson(
                    System.Text.Json.JsonSerializer.Serialize(defaultValue)
                );
            }
        }
    }

    private object? GetValueFromSettings(string propertyName, Type classType)
    {
        if (_map != null)
        {
            return (propertyName, classType.Name) switch
            {
                (nameof(IpOptions.Port), _) => _map.FirstOrDefault(a => a.Options.Type == ChannelType.Ip)?.Options
                    .AsIpOptions().Port,
                (nameof(IpOptions.Host), _) => _map.FirstOrDefault(a => a.Options.Type == ChannelType.Ip)?.Options
                    .AsIpOptions().Host,
                (nameof(ComPortOptions.PortName), _) => _map.FirstOrDefault(a => a.Options.Type == ChannelType.ComPort)?.Options.AsComPortOptions().PortName,
                ("Address", _) => _map
                    .FirstOrDefault(a => a.Options.Type == ChannelType.Ip)!.Addresses.First(),
                _ => null
            };
        }

        return null;
    }
}
