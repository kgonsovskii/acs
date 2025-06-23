using System.ComponentModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Logic.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic.Controllers;

public class LogicCallBackController : BaseController
{
    private readonly ILogicService _service;
    private readonly Settings _settings;
    private readonly IContourClient _contourClient;
    private readonly IServiceProvider _serviceProvider;

    public LogicCallBackController(IServiceProvider serviceProvider, IContourClient contourClient, ILogicService logicService, Settings settings) : base(settings)
    {
        _service = logicService;
        _serviceProvider = serviceProvider;
        _settings = settings;
        _contourClient = contourClient;
    }

    private static object locker = new();
    /// <summary>
    /// CallBack event initiated by Contours
    /// </summary>
    [HttpPut(nameof(OnContourCallBack))]
    [Description("CallBack event initiated by Contour")]
    [ProducesResponseType(typeof(CallBackResponse), StatusCodes.Status200OK)]
    [Produces("application/json")]
    public async Task<ActionResult<CallBackResponse>> OnContourCallBack(CallBackRequest request)
    {
        await _service.OnContourEvent(request.ContourSnapshot.Events);
        return OkProto(new CallBackResponse());
    }
}
