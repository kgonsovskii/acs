using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Shared;

public class XForwardToHeaderFilter : IOperationFilter
{
    public void Apply(OpenApiOperation operation, OperationFilterContext context)
    {
        if (operation.Parameters == null)
            operation.Parameters = new List<OpenApiParameter>();

        operation.Parameters.Add(new OpenApiParameter
        {
            Name = "X-Forward-To",
            In = ParameterLocation.Header,
            Description = "X-Forward-To header for request forwarding",
            Required = false,
            Schema = new OpenApiSchema
            {
                Type = "string"
            }
        });
    }
} 