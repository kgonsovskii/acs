using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Shared;

public class ProtoSwaggerFilter : IOperationFilter
{
    public void Apply(OpenApiOperation operation, OperationFilterContext context)
    {
        operation.Parameters ??= new List<OpenApiParameter>();

        operation.Parameters.Add(new OpenApiParameter
        {
            Name = ProtoHeaders.ForwardTo,
            In = ParameterLocation.Header,
            Description = "X-Forward-To header for request forwarding",
            Required = false,
            Schema = new OpenApiSchema
            {
                Type = "string"
            }
        });

        /*operation.Parameters.Add(new OpenApiParameter
        {
            Name = ProtoHeaders.TraceId,
            In = ParameterLocation.Header,
            Description = "Trace identifier for correlating requests",
            Required = false,
            Schema = new OpenApiSchema { Type = "string" }
        });

        operation.Parameters.Add(new OpenApiParameter
        {
            Name = ProtoHeaders.Agent,
            In = ParameterLocation.Header,
            Description = "Agent with Machine-Code identifier for correlating requests",
            Required = false,
            Schema = new OpenApiSchema { Type = "string" }
        });

        operation.Parameters.Add(new OpenApiParameter
        {
            Name = ProtoHeaders.Chop,
            In = ParameterLocation.Header,
            Description = "Chop value for request processing",
            Required = false,
            Schema = new OpenApiSchema { Type = "integer", Default = new OpenApiInteger(1) }
        });

        operation.Parameters.Add(new OpenApiParameter
        {
            Name = ProtoHeaders.Hash,
            In = ParameterLocation.Header,
            Description = "Hash value for request validation",
            Required = false,
            Schema = new OpenApiSchema { Type = "integer", Default = new OpenApiInteger(0) }
        });*/
    }
}
