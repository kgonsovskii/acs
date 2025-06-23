namespace SevenSeals.Tss.Contour;

public interface IChannelEvents
{
    void OnControllerEvent(Channel ch, string msg);
    void OnError(Channel ch, Exception ex);
    void OnControllerError(Channel ch, Contour contour, Exception ex);
    void OnChangeState(Channel ch, bool state);
    void OnPollSpeed(Channel ch, int speed);
    void OnControllerState(Channel ch, Contour contour, char state);
    void OnControllersChanged(Channel ch);
    void OnWriteAllKeysAsync(Contour contour, string data);
}

public class ChannelEvents : IChannelEvents
{
  //  private readonly EventLog _eventLog;
 //   private readonly EventQueue _eventQueue;
    public ChannelEvents()//EventLog eventLog, EventQueue eventQueue)
    {
       // _eventLog = eventLog;
      //  _eventQueue = eventQueue;
    }
    public void OnControllerEvent(Channel channel, byte[] rawEvent)
    {
       // var controllerEvent = new ControllerEvent(channel.Id, rawEvent);
    //    _eventQueue.Push(controllerEvent);
       // if (_eventLog.IsLogging)
        //    _eventLog.Add(controllerEvent);
    }

    public void OnControllerState(Channel ch, Contour contour, char state)
    {
        throw new NotImplementedException();
    }

    public void OnControllerEvent(Channel ch, string msg)
    {
        throw new NotImplementedException();
    }

    public void OnError(Channel channel, Exception ex)
    {
      //  _eventQueue.Push(new ChannelErrorEvent(channel.Id, ex.GetType().Name, ex.Message));
    }

    public void OnControllerError(Channel channel, Contour contour, Exception ex)
    {
      //  _eventQueue.Push(new ControllerErrorEvent(channel.Id, ex.GetType().Name, ex.Message,
      //      controller.Address));
    }

    public void OnChangeState(Channel channel, bool ready)
    {
       // _eventQueue.Push(new ChannelStateEvent(channel.Id, ready));
    }

    public void OnPollSpeed(Channel channel, int value)
    {
      //  _eventQueue.Push(new ChannelPollSpeedEvent(channel.Id, value));
    }



    public void OnControllerState(Channel channel, Contour contour, byte state)
    {
      //  _eventQueue.Push(new ControllerStateEvent(channel.Id, controller.Address, state));
    }

    public void OnControllersChanged(Channel channel)
    {
       // _eventQueue.Push(new ControllersChangedEvent(channel.Id));
    }

    public void OnWriteAllKeysAsync(Contour contour, string error)
    {
        //_eventQueue.Push(new WriteAllKeysAsyncEvent(controller.Channel.Id, controller.Address, error));
    }
}
