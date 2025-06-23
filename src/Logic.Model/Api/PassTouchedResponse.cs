using System.ComponentModel;
using Microsoft.AspNetCore.Mvc.ApiExplorer;
using SevenSeals.Tss.Actor;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic.Api;

public class PassTouchedResponse : ProtoResponse
{
    public required bool Result { get; set; }

    [TypeConverter(typeof(ExpandableObjectConverter))]
    public required Member Member { get; set; }

    [TypeConverter(typeof(ExpandableObjectConverter))]
    public required Spot Spot { get; set; }

    [TypeConverter(typeof(ExpandableObjectConverter))]
    public required Pass Pass { get; set; }
}
