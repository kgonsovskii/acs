using System.Collections.Generic;

namespace SevenSeals.Tss.Web.Api.Models
{
    public class PlanResponse
    {
        public double PlanWidth { get; set; }
        public double PlanHeight { get; set; }
        public List<Shape> Shapes { get; set; } = new List<Shape>();
    }
}
