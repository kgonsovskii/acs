using System.Net;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Shared;

public class ProtoForwardMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ProtoForwardMiddleware> _logger;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly Settings _settings;

    public ProtoForwardMiddleware(
        RequestDelegate next,
        ILogger<ProtoForwardMiddleware> logger,
        IHttpClientFactory httpClientFactory,
        Settings settings)
    {
        _next = next;
        _logger = logger;
        _httpClientFactory = httpClientFactory;
        _settings = settings;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        if (!context.Request.Headers.TryGetValue(ProtoHeaders.ForwardTo, out var forwardTo))
        {
            await _next(context);
            return;
        }

        try
        {
            var targetUri = new Uri(forwardTo.ToString());
            var client = _httpClientFactory.CreateClient();

            var request = new HttpRequestMessage
            {
                Method = new HttpMethod(context.Request.Method),
                RequestUri = new Uri(targetUri, context.Request.Path + context.Request.QueryString)
            };

            foreach (var header in context.Request.Headers)
            {
                if (!header.Key.Equals(ProtoHeaders.ForwardTo, StringComparison.OrdinalIgnoreCase))
                {
                    request.Headers.TryAddWithoutValidation(header.Key, header.Value.ToArray());
                }
            }

            if (context.Request.Headers.TryGetValue(ProtoHeaders.Agent, out var requestAgent) &&
                requestAgent.ToString().Equals(_settings.Agent, StringComparison.OrdinalIgnoreCase))
            {
                throw new InvalidOperationException($"Recursive forwarding detected. I'm {_settings.Agent}'");
            }

            _logger.LogInformation($"{requestAgent}: Forwarding to {targetUri}");

            if (context.Request.ContentLength > 0)
            {
                context.Request.EnableBuffering();
                var bodyStream = new MemoryStream();
                await context.Request.Body.CopyToAsync(bodyStream);
                bodyStream.Position = 0;

                request.Content = new StreamContent(bodyStream);

                if (context.Request.ContentType != null)
                {
                    request.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(context.Request.ContentType);
                }

                if (context.Request.ContentLength.HasValue)
                {
                    request.Content.Headers.ContentLength = context.Request.ContentLength;
                }
            }

            // Send request
            var response = await client.SendAsync(request);

            // Copy response
            context.Response.StatusCode = (int)response.StatusCode;

            // Copy response headers
            foreach (var header in response.Headers)
            {
                context.Response.Headers[header.Key] = header.Value.ToArray();
            }

            foreach (var header in response.Content.Headers)
            {
                context.Response.Headers[header.Key] = header.Value.ToArray();
            }

            var responseBody = await response.Content.ReadAsStreamAsync();
            await responseBody.CopyToAsync(context.Response.Body);
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Forwarding prevented: {Message}", ex.Message);
            context.Response.StatusCode = (int)HttpStatusCode.BadRequest;
            await context.Response.WriteAsync(ex.Message);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error forwarding request to {ForwardTo}", forwardTo!);
            context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
            await context.Response.WriteAsync($"Error forwarding request: {ex.Message}");
        }
    }
}
