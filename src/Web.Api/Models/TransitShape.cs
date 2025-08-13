namespace SevenSeals.Tss.Web.Api.Models
{
    public class TransitShape : Shape
    {
        public TransitShape()
        {
            Type = "transit";
        }

        public double R { get; set; }
        public string Fill { get; set; }
        public string Stroke { get; set; }
        public int StrokeWidth { get; set; }
        public string Text { get; set; }
        public string FromZoneId { get; set; }
        public string ToZoneId { get; set; }
    }
}
