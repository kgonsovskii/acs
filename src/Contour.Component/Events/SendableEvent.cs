namespace SevenSeals.Tss.Contour.Events;


    public abstract class SendableEvent
    {
        protected SendableEvent(string name)
        {
            Name = name;
        }

        public string Name { get; }
        public Dictionary<string, object> Parameters { get; } = new();

        public abstract Task ExecuteAsync(object client, bool noAck);

        public static SendableEvent Create(Event evt)
        {
            return evt switch
            {
                ControllerEvent controllerEvent => CreateControllerSendableEvent(controllerEvent),
                ChannelErrorEvent channelErrorEvent => new ChannelErrorSendableEvent("ChannelError", channelErrorEvent),
            //    ControllerErrorEvent controllerErrorEvent => new ControllerErrorSendableEvent(controllerErrorEvent),
                ChannelStateEvent channelStateEvent => new ChannelStateSendableEvent(channelStateEvent),
                ChannelPollSpeedEvent channelPollSpeedEvent => new ChannelPollSpeedSendableEvent(channelPollSpeedEvent),
                ControllerStateEvent controllerStateEvent => new ControllerStateSendableEvent(controllerStateEvent),
                ChannelsChangedEvent => new TimestampedSendableEvent("ChannelsChanged", evt),
                ControllersChangedEvent controllersChangedEvent => new ChannelSendableEvent("ControllersChanged", controllersChangedEvent),
                ClientsChangedEvent => new TimestampedSendableEvent("ClientsChanged", evt),
                QueueFullEvent => new TimestampedSendableEvent("QueueFull", evt),
                WriteAllKeysAsyncEvent writeAllKeysAsyncEvent => new WriteAllKeysAsyncSendableEvent(writeAllKeysAsyncEvent),
                _ => throw new ArgumentException("Unknown event type", nameof(evt))
            };
        }

        private static SendableEvent CreateControllerSendableEvent(ControllerEvent evt)
        {
            return evt.GetKind() switch
            {
                ControllerEvent.Kind.Key => new ControllerPortKeySendableEvent(evt),
                ControllerEvent.Kind.Button => new ControllerPortButtonSendableEvent(evt),
                ControllerEvent.Kind.DoorOpen => new ControllerPortDoorOpenSendableEvent(evt),
                ControllerEvent.Kind.DoorClose => new ControllerPortDoorCloseSendableEvent(evt),
                ControllerEvent.Kind.Power220V => new Controller220VSendableEvent(evt),
                ControllerEvent.Kind.Case => new ControllerCaseSendableEvent(evt),
                ControllerEvent.Kind.Timer => new ControllerTimerSendableEvent(evt),
                ControllerEvent.Kind.AutoTimeout => new ControllerAutoTimeoutSendableEvent(evt),
                ControllerEvent.Kind.Restart => new ControllerRestartSendableEvent(evt),
                ControllerEvent.Kind.Start => new ControllerStartSendableEvent(evt),
                ControllerEvent.Kind.StaticSensor => new ControllerStaticSensorSendableEvent(evt),
                _ => throw new ArgumentException("Unknown controller event kind")
            };
        }
    }

