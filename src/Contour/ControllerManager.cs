namespace SevenSeals.Tss.Contour;

public class ControllerManager : BaseManager<byte, Controller>
{
    protected override Controller CreateItem(byte key)
    {
        return new Controller(key);
    }
}
