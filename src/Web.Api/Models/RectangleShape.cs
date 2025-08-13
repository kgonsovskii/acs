namespace SevenSeals.Tss.Web.Api.Models
{
    public class RectangleShape : Shape
    {
        public RectangleShape()
        {
            Type = "rect";
        }

        public double W { get; set; }
        public double H { get; set; }
        public string Fill { get; set; }
        public string Stroke { get; set; }
        public int StrokeWidth { get; set; }
        public string Text { get; set; }
        public string ZoneId { get; set; }
    }
}
