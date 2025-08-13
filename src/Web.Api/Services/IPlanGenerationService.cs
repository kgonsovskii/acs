using SevenSeals.Tss.Atlas;
using SevenSeals.Tss.Web.Api.Models;

namespace SevenSeals.Tss.Web.Api.Services
{
    public interface IPlanGenerationService
    {
        PlanResponse GeneratePlanForZone(Zone selectedZone, Map map);
    }
}
