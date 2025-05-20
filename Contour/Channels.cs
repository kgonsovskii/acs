using System;
using System.Collections.Generic;
using System.Threading;

namespace Tss
{
    public class Channels
    {
        private readonly Dictionary<string, Channel> channels = new Dictionary<string, Channel>();
        private readonly ChannelEvents events = new ChannelEvents();
        private readonly object sync = new object();

        public SerialChannel Add(ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout, string devStr, uint speed)
        {
            lock (sync)
            {
                var ch = new SerialChannel(events, responseTimeout, aliveTimeout, deadTimeout, devStr, speed);
                channels[ch.Id] = ch;
                return ch;
            }
        }

        public IPChannel Add(ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout, string host, ushort port)
        {
            lock (sync)
            {
                var ch = new IPChannel(events, responseTimeout, aliveTimeout, deadTimeout, host, port);
                channels[ch.Id] = ch;
                return ch;
            }
        }

        public Channel this[string id]
        {
            get
            {
                lock (sync)
                {
                    if (channels.TryGetValue(id, out var channel))
                        return channel;
                    throw new KeyNotFoundException($"Channel {id} not found");
                }
            }
        }

        public void Erase(string id)
        {
            lock (sync)
            {
                channels.Remove(id);
            }
        }

        public void Clear()
        {
            lock (sync)
            {
                channels.Clear();
            }
        }

        public int Count
        {
            get
            {
                lock (sync)
                {
                    return channels.Count;
                }
            }
        }

        public bool IsEmpty
        {
            get
            {
                lock (sync)
                {
                    return channels.Count == 0;
                }
            }
        }
    }

    public class ChannelEvents
    {
        public void OnControllerEvent(Channel channel, byte[] rawEvent)
        {
            var controllerEvent = new ControllerEvent(channel.Id, rawEvent);
            Servcont.Instance.EventQueue.Push(controllerEvent);
            if (Servcont.Instance.CoEvtLog.IsLogging)
                Servcont.Instance.CoEvtLog.Add(controllerEvent);
        }

        public void OnError(Channel channel, Exception ex)
        {
            Servcont.Instance.EventQueue.Push(new ChannelErrorEvent(channel.Id, ex.GetType().Name, ex.Message));
        }

        public void OnControllerError(Channel channel, Controller controller, Exception ex)
        {
            Servcont.Instance.EventQueue.Push(new ControllerErrorEvent(channel.Id, ex.GetType().Name, ex.Message, controller.Address));
        }

        public void OnChangeState(Channel channel, bool ready)
        {
            Servcont.Instance.EventQueue.Push(new ChannelStateEvent(channel.Id, ready));
        }

        public void OnPollSpeed(Channel channel, int value)
        {
            Servcont.Instance.EventQueue.Push(new ChannelPollSpeedEvent(channel.Id, value));
        }

        public void OnControllerState(Channel channel, Controller controller, byte state)
        {
            Servcont.Instance.EventQueue.Push(new ControllerStateEvent(channel.Id, controller.Address, state));
        }

        public void OnControllersChanged(Channel channel)
        {
            Servcont.Instance.EventQueue.Push(new ControllersChangedEvent(channel.Id));
        }

        public void OnWriteAllKeysAsync(Controller controller, string error)
        {
            Servcont.Instance.EventQueue.Push(new WriteAllKeysAsyncEvent(controller.Channel.Id, controller.Address, error));
        }
    }
} 