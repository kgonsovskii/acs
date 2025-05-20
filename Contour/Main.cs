using System;
using System.Collections.Generic;
using System.Threading;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.IO;
using System.Linq;
using System.Data.SQLite;

namespace Tss
{
    public class Program
    {
        private static Servcont app;

        public static void Main(string[] args)
        {
            try
            {
                app = new Servcont(args);
                app.Run();
            }
            catch (Exception ex)
            {
                Sys.HandleException(ex);
            }
        }
    }

    public class Servcont
    {
        public static Servcont Instance { get; private set; }
        private readonly string[] args;
        private readonly Channels channels;
        private readonly EventQueue eventQueue;
        private readonly Clients clients;
        private readonly CoEvtLog coEvtLog;
        private readonly object sync = new object();
        private readonly object taskSync = new object();
        private readonly Semaphore semaphore;
        private Thread thread;
        private bool cleanupClients;
        private bool stopEventQueue;

        public Servcont(string[] args)
        {
            Instance = this;
            this.args = args;
            channels = new Channels();
            eventQueue = new EventQueue();
            clients = new Clients();
            coEvtLog = new CoEvtLog();
            semaphore = new Semaphore(0, 1);
        }

        public void Run()
        {
            eventQueue.Load();

            using (var server = new TcpListener(IPAddress.Any, 4000))
            {
                server.Start();
                thread = new Thread(ThreadImpl);
                thread.Start();

                while (!Terminated)
                {
                    if (server.Pending())
                    {
                        var client = server.AcceptTcpClient();
                        var socket = client.Client;
                        var remoteEndPoint = (IPEndPoint)socket.RemoteEndPoint;
                        clients.Add(socket, remoteEndPoint.ToString());
                    }
                    Thread.Sleep(330);
                }
            }
        }

        private void ThreadImpl()
        {
            while (true)
            {
                semaphore.WaitOne();
                bool cleanupClients, stopEventQueue;
                lock (taskSync)
                {
                    stopEventQueue = this.stopEventQueue;
                    this.stopEventQueue = false;
                    cleanupClients = this.cleanupClients;
                    this.cleanupClients = false;
                }

                if (stopEventQueue)
                    SwitchToAuto(true, false, false);

                if (cleanupClients)
                {
                    this.cleanupClients = false;
                    clients.Cleanup();
                }

                if (Terminated && clients.IsEmpty)
                    break;
            }
        }

        public void Shutdown()
        {
            SwitchToAuto(true, true, true);
            coEvtLog.Close();
            clients.Disconnect();
            eventQueue.Stop();
            eventQueue.Save();
            thread?.Join();
        }

        public string RootDir()
        {
            return Path.Combine(Path.GetDirectoryName(args[0]), "..");
        }

        public string DataDir()
        {
            return Path.Combine(RootDir(), "data");
        }

        public void DoTask(Task task)
        {
            lock (taskSync)
            {
                if (task == Task.CleanupClients)
                    cleanupClients = true;
                else if (task == Task.StopEventQueue)
                    stopEventQueue = true;
                semaphore.Release();
            }
        }

        public bool Terminated { get; private set; }
        public Channels Channels => channels;
        public EventQueue EventQueue => eventQueue;
        public Clients Clients => clients;
        public CoEvtLog CoEvtLog => coEvtLog;

        public enum Task
        {
            CleanupClients,
            StopEventQueue
        }
    }

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

    public class EventQueue
    {
        private readonly Queue<Event> events = new Queue<Event>();
        private readonly object sync = new object();
        private readonly Semaphore semaphore = new Semaphore(0, 1);
        private Thread senderThread;
        private bool busy;
        private uint limit = uint.MaxValue;
        private bool terminated;

        public void Push(Event evt)
        {
            lock (sync)
            {
                events.Enqueue(evt);
                if (events.Count == 1)
                    semaphore.Release();
                else if (events.Count == limit)
                {
                    events.Enqueue(new QueueFullEvent());
                    Servcont.Instance.DoTask(Servcont.Task.StopEventQueue);
                }
            }
        }

        public void Load()
        {
            lock (sync)
            {
                using (var db = new SQLiteConnection($"Data Source={Path.Combine(Servcont.Instance.DataDir(), "coevtcue.db")}"))
                {
                    db.Open();
                    using (var cmd = new SQLiteCommand("SELECT * FROM coevtcue", db))
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var evt = new ControllerEvent(
                                reader.GetString(0),
                                (byte[])reader.GetValue(2),
                                (byte[])reader.GetValue(1)
                            );
                            evt.Used = true;
                            events.Enqueue(evt);
                        }
                    }
                }
            }
        }

        public void Save()
        {
            lock (sync)
            {
                if (events.Count == 0)
                    return;

                using (var db = new SQLiteConnection($"Data Source={Path.Combine(Servcont.Instance.DataDir(), "coevtcue.db")}"))
                {
                    db.Open();
                    using (var cmd = new SQLiteCommand("CREATE TABLE IF NOT EXISTS coevtcue(ch TEXT, t2 BLOB, evt BLOB)", db))
                    {
                        cmd.ExecuteNonQuery();
                    }

                    while (events.Count > 0)
                    {
                        var evt = events.Dequeue();
                        if (evt is ControllerEvent ce)
                        {
                            using (var cmd = new SQLiteCommand("INSERT INTO coevtcue VALUES(?,?,?)", db))
                            {
                                cmd.Parameters.AddWithValue("@ch", ce.ChannelId);
                                cmd.Parameters.AddWithValue("@t2", ce.Timestamp);
                                cmd.Parameters.AddWithValue("@evt", ce.Data);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }
        }

        public void Stop()
        {
            terminated = true;
            semaphore.Release();
        }

        public void Start()
        {
            senderThread = new Thread(SenderThreadImpl);
            senderThread.Start();
        }

        private void SenderThreadImpl()
        {
            while (!terminated)
            {
                semaphore.WaitOne();
                if (terminated)
                    break;

                while (true)
                {
                    bool forAll, coEvt;
                    var evt = Front(out forAll, out coEvt);
                    if (evt != null)
                    {
                        if (Servcont.Instance.Clients.Exec(evt, forAll, !coEvt))
                            Pop(false);
                        else
                            break;
                    }
                    else
                        break;
                }
            }
        }

        private Event Front(out bool forAll, out bool coEvt)
        {
            lock (sync)
            {
                if (events.Count > 0)
                {
                    var evt = events.Peek();
                    if (evt is ControllerEvent ce)
                    {
                        coEvt = true;
                        forAll = !ce.Used;
                        ce.Used = true;
                    }
                    else
                    {
                        forAll = true;
                        coEvt = false;
                    }
                    return evt;
                }
                forAll = false;
                coEvt = false;
                return null;
            }
        }

        private void Pop(bool isSet)
        {
            lock (sync)
            {
                if (events.Count > 0)
                    events.Dequeue();
                if (isSet)
                {
                    busy = false;
                    if (events.Count > 0)
                        semaphore.Release();
                }
            }
        }
    }

    public class Clients
    {
        private readonly List<Client> clients = new List<Client>();
        private readonly object sync = new object();
        private Client mainClient;

        public void Add(Socket socket, string connInfo)
        {
            lock (sync)
            {
                var client = new Client(connInfo);
                client.Open(socket);
                clients.Add(client);
            }
        }

        public void Cleanup()
        {
            lock (sync)
            {
                clients.RemoveAll(c => !c.Ready);
            }
        }

        public void Disconnect()
        {
            lock (sync)
            {
                foreach (var client in clients)
                {
                    client.Disconnect(true);
                }
            }
        }

        public bool Exec(SendableEvent evt, bool forAll, bool noAck)
        {
            lock (sync)
            {
                bool ret = noAck;

                if (mainClient != null)
                {
                    try
                    {
                        evt.Exec(mainClient, noAck);
                    }
                    catch (Exception ex)
                    {
                        ret = false;
                        Sys.HandleException(ex);
                    }
                }

                if (forAll)
                {
                    foreach (var client in clients)
                    {
                        try
                        {
                            if (client != mainClient && client.Ready)
                            {
                                evt.Exec(client, true);
                            }
                        }
                        catch (Exception ex)
                        {
                            Sys.HandleException(ex);
                        }
                    }
                }

                return ret;
            }
        }

        public void SetMainClient(Client client)
        {
            lock (sync)
            {
                if (mainClient != null && !client.Handle.SequenceEqual(mainClient.Handle))
                    throw new Exception("Main client already exists");
                if (mainClient != client)
                {
                    mainClient = client;
                    Servcont.Instance.EventQueue.Signal();
                }
            }
        }

        public void OnDisconnect(Client client)
        {
            lock (sync)
            {
                if (mainClient == client)
                {
                    mainClient = null;
                    SwitchToAuto(true, true, true);
                }
                Servcont.Instance.DoTask(Servcont.Task.CleanupClients);
                if (clients.Count > 1)
                    Servcont.Instance.EventQueue.Push(new ClientsChangedEvent());
            }
        }

        public bool IsMainClient(Client testee)
        {
            lock (sync)
            {
                return mainClient == testee;
            }
        }

        public bool IsEmpty
        {
            get
            {
                lock (sync)
                {
                    return clients.Count == 0;
                }
            }
        }
    }

    public class CoEvtLog
    {
        private SQLiteConnection db;
        private readonly object sync = new object();
        private bool logging;

        public void Open(bool log)
        {
            lock (sync)
            {
                if (db == null)
                    OpenDb();
                logging = log;
            }
        }

        private void OpenDb()
        {
            var path = Servcont.Instance.DataDir();
            Directory.CreateDirectory(path);
            var filename = Path.Combine(path, "coevtlog.db");
            db = new SQLiteConnection($"Data Source={filename}");
            db.Open();
            using (var cmd = new SQLiteCommand("CREATE TABLE IF NOT EXISTS coevtlog(ch TEXT, t1 BLOB, t2 BLOB, addr INTEGER, evt BLOB)", db))
            {
                cmd.ExecuteNonQuery();
            }
        }

        public void Close()
        {
            lock (sync)
            {
                try
                {
                    if (db != null)
                    {
                        db.Close();
                        db.Dispose();
                        db = null;
                    }
                }
                catch (Exception ex)
                {
                    Sys.HandleException(ex);
                }
            }
        }

        public void Add(ControllerEvent evt)
        {
            lock (sync)
            {
                using (var cmd = new SQLiteCommand("INSERT INTO coevtlog VALUES(?,?,?,?,?)", db))
                {
                    cmd.Parameters.AddWithValue("@ch", evt.ChannelId);
                    cmd.Parameters.AddWithValue("@t1", evt.ControllerTimestamp);
                    cmd.Parameters.AddWithValue("@t2", evt.Timestamp);
                    cmd.Parameters.AddWithValue("@addr", evt.Address);
                    cmd.Parameters.AddWithValue("@evt", evt.Data);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public bool IsLogging => logging;
    }

    // Event classes
    public abstract class Event
    {
        public enum Type
        {
            None,
            Controller,
            ChannelError,
            ControllerError,
            ChannelState,
            ChannelPollSpeed,
            ControllerState,
            ChannelsChanged,
            ControllersChanged,
            ClientsChanged,
            QueueFull,
            WriteAllKeysAsync
        }

        public Type EventType { get; }
        public byte[] Timestamp { get; }

        protected Event(Type type)
        {
            EventType = type;
            Timestamp = new byte[6];
        }

        protected Event(Type type, byte[] timestamp)
        {
            EventType = type;
            Timestamp = timestamp;
        }
    }

    public class QueueFullEvent : Event
    {
        public QueueFullEvent() : base(Type.QueueFull) { }
    }

    public class ClientsChangedEvent : Event
    {
        public ClientsChangedEvent() : base(Type.ClientsChanged) { }
    }

    public class ChannelsChangedEvent : Event
    {
        public ChannelsChangedEvent() : base(Type.ChannelsChanged) { }
    }

    public class ChannelEvent : Event
    {
        public string ChannelId { get; }

        protected ChannelEvent(Type type, string channelId) : base(type)
        {
            ChannelId = channelId;
        }

        protected ChannelEvent(Type type, string channelId, byte[] timestamp) : base(type, timestamp)
        {
            ChannelId = channelId;
        }
    }

    public class ControllersChangedEvent : ChannelEvent
    {
        public ControllersChangedEvent(string channelId) : base(Type.ControllersChanged, channelId) { }
    }

    public class WriteAllKeysAsyncEvent : ChannelEvent
    {
        public byte Address { get; }
        public string Error { get; }

        public WriteAllKeysAsyncEvent(string channelId, byte address, string error)
            : base(Type.WriteAllKeysAsync, channelId)
        {
            Address = address;
            Error = error;
        }
    }

    public class ControllerEvent : ChannelEvent
    {
        public enum Kind
        {
            None,
            Key,
            Button,
            DoorOpen,
            DoorClose,
            Power220V,
            Case,
            Timer,
            AutoTimeout,
            Restart,
            Start,
            StaticSensor
        }

        public const int Size = 16;
        public byte[] Data { get; }
        public bool Used { get; set; }
        public byte[] ControllerTimestamp { get; }

        public ControllerEvent(string channelId, byte[] data) : base(Type.Controller, channelId)
        {
            Data = data;
            ControllerTimestamp = new byte[6];
            InitializeControllerTimestamp();
        }

        public ControllerEvent(string channelId, byte[] data, byte[] timestamp)
            : base(Type.Controller, channelId, timestamp)
        {
            Data = data;
            ControllerTimestamp = new byte[6];
            InitializeControllerTimestamp();
        }

        public byte Address() => Data[0];
        public ushort No() => (ushort)((Data[9] << 8) | Data[8]);
        public bool IsAuto() => (Data[12] & 128) != 0;
        public bool IsLast() => (Data[1] & 128) == 0;
        public bool HasYear() => (Data[11] & 128) != 0;
        public bool HasDate() => Data[10] != 0 || Data[11] != 0;

        public Kind GetKind()
        {
            byte x = (byte)(Data[1] & 7);
            if (x == 6 || x == 7)
                return Kind.Key;
            if (x == 4 || x == 5)
                return Kind.Button;
            if ((Data[1] & 15) == 3)
                return Kind.DoorOpen;
            if ((Data[1] & 15) == 11)
                return Kind.DoorClose;
            if (x == 1)
            {
                switch ((Data[1] >> 4) & 7)
                {
                    case 0: return Kind.Power220V;
                    case 1: return Kind.Case;
                    case 2: return Kind.Timer;
                    case 3: return Kind.AutoTimeout;
                    case 6: return Kind.Restart;
                    case 7: return Kind.Start;
                    default: return Kind.None;
                }
            }
            if (x == 2)
                return Kind.StaticSensor;
            return Kind.None;
        }

        private void InitializeControllerTimestamp()
        {
            if (HasYear())
            {
                ushort x = (ushort)((Data[10] << 8) | Data[11]);
                ControllerTimestamp[0] = (byte)((x >> 9) & 63);
                ControllerTimestamp[1] = (byte)((x >> 5) & 15);
                ControllerTimestamp[2] = (byte)(x & 31);
            }
            else
            {
                ControllerTimestamp[0] = 0;
                if (HasDate())
                {
                    ControllerTimestamp[1] = BcdToBin(Data[11]);
                    ControllerTimestamp[2] = BcdToBin(Data[10]);
                }
                else
                {
                    ControllerTimestamp[1] = 1;
                    ControllerTimestamp[2] = 1;
                }
            }
            ControllerTimestamp[3] = BcdToBin(Data[15]);
            ControllerTimestamp[4] = BcdToBin(Data[14]);
            ControllerTimestamp[5] = BcdToBin(Data[13]);
        }

        private byte BcdToBin(byte bcd)
        {
            return (byte)(((bcd >> 4) * 10) + (bcd & 0x0F));
        }
    }

    public class ChannelStateEvent : ChannelEvent
    {
        public bool Ready { get; }

        public ChannelStateEvent(string channelId, bool ready)
            : base(Type.ChannelState, channelId)
        {
            Ready = ready;
        }
    }

    public class ChannelPollSpeedEvent : ChannelEvent
    {
        public int Value { get; }

        public ChannelPollSpeedEvent(string channelId, int value)
            : base(Type.ChannelPollSpeed, channelId)
        {
            Value = value;
        }
    }

    public class ChannelErrorEvent : ChannelEvent
    {
        public string Class { get; }
        public string Message { get; }

        public ChannelErrorEvent(string channelId, string cls, string message)
            : base(Type.ChannelError, channelId)
        {
            Class = cls;
            Message = message;
        }
    }

    public class ControllerErrorEvent : ChannelErrorEvent
    {
        public byte Controller { get; }

        public ControllerErrorEvent(string channelId, string cls, string message, byte controller)
            : base(channelId, cls, message)
        {
            Controller = controller;
        }
    }

    public class ControllerStateEvent : ChannelEvent
    {
        public byte Controller { get; }
        public byte State { get; }

        public ControllerStateEvent(string channelId, byte controller, byte state)
            : base(Type.ControllerState, channelId)
        {
            Controller = controller;
            State = state;
        }
    }

    public abstract class SendableEvent
    {
        public RpcProc Proc { get; }

        protected SendableEvent(string name)
        {
            Proc = new RpcProc(name);
        }

        public abstract void Exec(Client client, bool noAck);
    }

    public class RpcProc
    {
        public string Name { get; }
        public Dictionary<string, object> Parameters { get; } = new Dictionary<string, object>();

        public RpcProc(string name)
        {
            Name = name;
        }

        public void AddParameter(string name, object value)
        {
            Parameters[name] = value;
        }
    }

    public class Client
    {
        public string ConnectionInfo { get; }
        public Socket Socket { get; private set; }
        public byte[] Handle { get; private set; }
        public bool Ready { get; private set; }

        public Client(string connectionInfo)
        {
            ConnectionInfo = connectionInfo;
            Handle = new byte[16];
        }

        public void Open(Socket socket)
        {
            Socket = socket;
            Ready = true;
        }

        public void Disconnect(bool force)
        {
            if (Socket != null)
            {
                Socket.Close();
                Socket = null;
                Ready = false;
            }
        }

        public void ExecNoAck(RpcProc proc)
        {
            // Implementation for sending RPC without acknowledgment
        }

        public void ExecNoWait(RpcProc proc, int timeout)
        {
            // Implementation for sending RPC without waiting for response
        }
    }

    public class Channel
    {
        public string Id { get; protected set; }
        public bool Active { get; protected set; }
        public Dictionary<byte, Controller> Controllers { get; } = new Dictionary<byte, Controller>();

        public virtual void Activate() { }
        public virtual void Deactivate() { }
    }

    public class SerialChannel : Channel
    {
        public string DeviceString { get; }
        public uint Speed { get; }

        public SerialChannel(ChannelEvents events, ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout, string devStr, uint speed)
        {
            DeviceString = devStr;
            Speed = speed;
        }
    }

    public class IPChannel : Channel
    {
        public string Host { get; }
        public ushort Port { get; }

        public IPChannel(ChannelEvents events, ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout, string host, ushort port)
        {
            Host = host;
            Port = port;
        }
    }

    public class Controller
    {
        public byte Address { get; }
        public Channel Channel { get; }

        public Controller(byte address, Channel channel)
        {
            Address = address;
            Channel = channel;
        }

        public byte State() => 0; // Implementation needed
    }

    public static class Sys
    {
        public static void Log(string message)
        {
            Console.WriteLine($"{DateTime.Now:yyyy-MM-dd_HH:mm:ss} {message}");
        }

        public static void HandleException(Exception ex)
        {
            Log($"Error: {ex.Message}");
        }
    }
} 