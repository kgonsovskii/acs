HEADERnamespace a;


namespace SevenSeals.Tss.Contour.Events
{
    public class ControllerStateSendableEvent : ChannelSendableEvent
    {
        public ControllerStateSendableEvent(ControllerStateEvent evt) : base("ControllerState", evt)
        {
            Parameters["ADDR"] = evt.ControllerAddress;
            Parameters["STATE"] = evt.State;
        }
    }
}
