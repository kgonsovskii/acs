namespace SevenSeals.Tss.Contour.Api;

public class WaitForPassRequest: ContourRequest
{

}

public class WaitForPassResponse : ContourResponse
{
    public required string KeyNumber {get; set;}
}
