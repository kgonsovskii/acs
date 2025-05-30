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
                ControllerEvent.KindEnum.Key => new ControllerPortKeySendableEvent(evt),
                ControllerEvent.KindEnum.Button => new ControllerPortButtonSendableEvent(evt),
                ControllerEvent.KindEnum.DoorOpen => new ControllerPortDoorOpenSendableEvent(evt),
                ControllerEvent.KindEnum.DoorClose => new ControllerPortDoorCloseSendableEvent(evt),
                ControllerEvent.KindEnum.Power220V => new Controller220VSendableEvent(evt),
                ControllerEvent.KindEnum.Case => new ControllerCaseSendableEvent(evt),
                ControllerEvent.KindEnum.Timer => new ControllerTimerSendableEvent(evt),
                ControllerEvent.KindEnum.AutoTimeout => new ControllerAutoTimeoutSendableEvent(evt),
                ControllerEvent.KindEnum.Restart => new ControllerRestartSendableEvent(evt),
                ControllerEvent.KindEnum.Start => new ControllerStartSendableEvent(evt),
                ControllerEvent.KindEnum.StaticSensor => new ControllerStaticSensorSendableEvent(evt),
                _ => throw new ArgumentException("Unknown controller event kind")
            };
        }
    }

