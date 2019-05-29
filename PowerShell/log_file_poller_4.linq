<Query Kind="Program">
  <Connection>
    <ID>2f793749-cbb8-4e26-bd1d-9e8e9979ca95</ID>
    <Persist>true</Persist>
    <Server>nlgpnbasql56</Server>
    <IsProduction>true</IsProduction>
    <Database>NEWBFAST</Database>
    <ShowServer>true</ShowServer>
  </Connection>
  <Reference>&lt;RuntimeDirectory&gt;\System.Windows.Forms.dll</Reference>
</Query>

/*
 * 20140318:
 * This is a copy of log_file_poller_3.linq, for the purpose of adding 
 *    GetModifyBacklog monitoring.
 *    Appears to work.  Need to handle a bad result from the getModifyBacklog query, 
 *    to indicate the server's state is Down or Unknown.
 *  N. B.:  You must set the Connection for this to work!
 *
 * 20140313: Comment out OnBase monitor for PRC06 -- only runs at night.
 *
 * 20140303: Merge changes from Log_File_Poller_2 made on this date.
 * 
 * 20140228:  Log_File_Poller_3.linq
 *    Added monitoring of SendMail log.   
 *    Added code to LogFilePoller.Poll to replace individual ^M (13) 
 *    characters with ' ' (32).
 *
 *    Appears to be working, although have not seen it behave when SendMail is interrupted.
 *    - We could probably monitor SendMail merely by keeping track of the log file timestamp,
 *      but it is probably handy having the last log entry visible.
 */

private const bool ShowFullDetails = false;
private const int OnBasePollSeconds = 60;
private const int SqlPollSeconds = 10;

private static List<ServerMonitor> _servers = new List<ServerMonitor>();
private static List<IHolisticMonitor> _monitors = new List<IHolisticMonitor>();

private void InitializeServers(TypedDataContext context)
{
  _servers.Add(new ServerMonitor(
        "Proc 01",
        "NLGPNBAPRC01",
        new IServiceMonitor[]
        {
        new OnBaseMonitor(OnBasePollSeconds, "NLGPNBAPRC01")
        }));

  _servers.Add(new ServerMonitor(
        "Proc 02",
        "NLGPNBAPRC02",
        new IServiceMonitor[]
        {
        new OnBaseMonitor(OnBasePollSeconds, "NLGPNBAPRC02"),
        new MailWatcherMonitor(
          new LogFileConfiguration
          {
            FullPath = @"\\corp\hdq\data\iss\Installs\NBA Releases\NBAPRC\Mailwatcher.2013\MailWatcher.log",
            MaxPollingBytes = 0x2000, // 8192
            PollingInterval = TimeSpan.FromSeconds(5.0)
          } ),
        new SendMailMonitor(
          new LogFileConfiguration
          {
            FullPath = @"\\corp\hdq\data\iss\installs\NBA Releases\NBAPRC\SendMail\SendMail.log",
            MaxPollingBytes = 0x1000, // 4096
            PollingInterval = TimeSpan.FromSeconds(5.0)
          } )
        }));

  _servers.Add(new ServerMonitor(
        "Proc 03",
        "NLGPNBAPRC03",
        new IServiceMonitor[]
        {
        new OnBaseMonitor(OnBasePollSeconds, "NLGPNBAPRC03")
        }));

	_servers.Add(new ServerMonitor(
		"nlgpnbasql56",
		"",
		new IServiceMonitor[]
			{
				new SQLMonitor(SqlPollSeconds, context)
			}));
	

  _servers.Add(new ServerMonitor(
        "Proc 05", 
        "NLGPNBAPRC05",
        new IServiceMonitor[]
        {
        new RequesterMonitor(
          new LogFileConfiguration
          {
          FullPath = @"\\nlgpnbaprc05\c$\Fast_Legacy_Requestor\FL_MBox.log",
          //FullPath = @"\\corp\hdq\users\iss\HXCHSN\logs\research\05\FL_MBox.log",
          MaxPollingBytes = 0x10000, // 64k
          PollingInterval = TimeSpan.FromSeconds(5.0)
          }, 
          new LogFileConfiguration
          {
          FullPath = @"\\nlgpnbaprc05\c$\Fast_Legacy\FastLeg.log",
          //FullPath = @"\\corp\hdq\users\iss\HXCHSN\logs\research\05\FastLeg.log",
          MaxPollingBytes = 0x8000, // 32k
          PollingInterval = TimeSpan.FromSeconds(5.0)
          }),
				new OnBaseMonitor(OnBasePollSeconds, "NLGPNBAPRC05")
        }));

  _servers.Add(new ServerMonitor(
        "Proc 06", 
        "NLGPNBAPRC06",
        new IServiceMonitor[]
        {
        new RequesterMonitor(
          new LogFileConfiguration
          {
          FullPath = @"\\nlgpnbaprc06\c$\Fast_Legacy_Requestor\FL_MBox.log",
          //FullPath = @"\\corp\hdq\users\iss\HXCHSN\logs\research\06\FL_MBox.log",
          MaxPollingBytes = 0x10000, // 64k
          PollingInterval = TimeSpan.FromSeconds(5.0)
          }, 
          new LogFileConfiguration
          {
          FullPath = @"\\nlgpnbaprc06\c$\Fast_Legacy\FastLeg.log",
          //FullPath = @"\\corp\hdq\users\iss\HXCHSN\logs\research\06\FastLeg.log",
          MaxPollingBytes = 0x8000, // 32k
          PollingInterval = TimeSpan.FromSeconds(5.0)
          }),

          // new OnBaseMonitor(OnBasePollSeconds, "NLGPNBAPRC06", "nbaprc06", "nbaprc06")
        }));

  _servers.Add(new ServerMonitor(
        "Proc 07", 
        "NLGPNBAPRC07",
        new IServiceMonitor[]
        {
        new RequesterMonitor(
          new LogFileConfiguration
          {
          FullPath = @"\\nlgpnbaprc07\c$\Fast_Legacy_Requestor\FL_MBox.log",
          //FullPath = @"\\corp\hdq\users\iss\HXCHSN\logs\research\07\FL_MBox.log",
          MaxPollingBytes = 0x10000, // 64k
          PollingInterval = TimeSpan.FromSeconds(5.0)
          }, 
          new LogFileConfiguration
          {
          FullPath = @"\\nlgpnbaprc07\c$\Fast_Legacy\FastLeg.log",
          //FullPath = @"\\corp\hdq\users\iss\HXCHSN\logs\research\07\FastLeg.log",
          MaxPollingBytes = 0x8000, // 32k
          PollingInterval = TimeSpan.FromSeconds(5.0)
          }),
        }));

  _servers.Add(new ServerMonitor(
        "Proc 08",
        "NLGPNBAPRC08",
        new IServiceMonitor[]
        {
        new OnBaseMonitor(OnBasePollSeconds, "NLGPNBAPRC08", "nbaprc08", "nbaprc08")
        }));


  //	_servers.Add(new ServerMonitor(
  //		"nationallifegroup.com",
  //		"nlg.com",
  //		new[]
  //			{
  //				new InforceMonitor(99223321)
  //			}));
}

private void InitializeHolisticMonitors()
{
  _monitors.Add(new HolisticRequesterMonitor());
}


void Main()
{
  InitializeServers(this );
  InitializeHolisticMonitors();
  var lastDownServers = string.Empty;

  _servers.ForEach(server =>
      {
      server.StatusChanged += (sender, e) =>
      {
      lock (_servers)
      {
      try
      {	        
        _monitors.ForEach(monitor => monitor.AnalyzeServers(_servers));
        Util.ClearResults();
        string.Format("reported at {0:HH:mm:ss}", DateTime.Now).Dump();
        _monitors.Select(monitor => monitor.State).Dump();

        var downServers = string.Join(
          "\r\n",
          _servers
          .SelectMany(s => s.ServiceMonitors
            .Select (m => new{Server = s, Service = m})
            .Where(m => m.Service.State == ServiceState.Down))
          .Select(s => string.Format("{0}.{1} is down.", s.Server.Name, s.Service.Name)));

        if(lastDownServers != downServers)
        {
          lastDownServers = downServers;

          if(!string.IsNullOrWhiteSpace(downServers))
            ShowError(downServers);
        }
      }
  catch (Exception ex)
  {
    ex.Dump();
  }

  if(!ShowFullDetails) return;

  _servers.ForEach(s => 
      {
      new
      {
      s.Name,
      s.MachineName,
      s.State,
      Services = s.ServiceMonitors
      .Select(service => new{service.Name, service.State, service.Status})
      }.Dump();
      });
      }
      };

  new
  {
    server.Name,
      server.MachineName,
      server.State,
      Services = server.ServiceMonitors
        .Select(service => new{service.Name, service.State, service.Status})
  }.Dump();

  server.Start();
      });

  while(true)	Thread.Sleep(int.MaxValue);
}

private void ShowError(string message)
{
  new Thread(() => {
      /*
      System.Windows.Forms.MessageBox.Show(
        message, 
        string.Format("Down Services, {0}", DateTime.Now.ToString()), 
        System.Windows.Forms.MessageBoxButtons.OK, 
        System.Windows.Forms.MessageBoxIcon.Error);
        */
      Util.ReadLine(message);
      }){ IsBackground = true }.Start();
}

/// <summary>
/// Monitors a server and its associated services.
/// </summary>
public class ServerMonitor : ServiceMonitorBase
{
  private List<IServiceMonitor> _serviceMonitors;

  public ServerMonitor(
      string name, 
      string machineName, 
      IEnumerable<IServiceMonitor> serviceMonitors)
  {
    Name = name;
    Status = string.Empty;
    MachineName = machineName;
    _serviceMonitors = serviceMonitors.ToList();

    _serviceMonitors.ForEach(monitor => 
        {
        monitor.StatusChanged += (sender, e) => 
        {
        State = monitor.State == ServiceState.Unknown 
        ? ServiceState.Down
        : ServiceState.Up;

        OnStatusChanged();
        };

        monitor.Stop();
        });
  }

  /// <summary>
  /// The low-level machine name.
  /// </summary>
  public string MachineName { get; protected set; }

  /// <summary>
  /// The services which are being monitored on this machine.
  /// </summary>
  public IEnumerable<IServiceMonitor> ServiceMonitors { get { return _serviceMonitors; } }

  /// <inheritdoc/>
  public override void Start()
  {
    _serviceMonitors.ForEach(monitor => monitor.Start());
  }

  /// <inheritdoc/>
  public override void Stop()
  {
    _serviceMonitors.ForEach(monitor => monitor.Stop());
    State = ServiceState.Unknown;
  }
}

public interface IHolisticMonitor
{
  void AnalyzeServers(IEnumerable<ServerMonitor> servers);

  object State { get; }
}

public class HolisticRequesterMonitor : IHolisticMonitor
{
  public object State { get; private set; }

  public void AnalyzeServers(IEnumerable<ServerMonitor> servers)
  {
    State = servers
      .Select(server => new {
          Server = server.Name, 
          State = server.State,
          Services = server.ServiceMonitors.Select (service => new{
            Name = service.Name.PadRight(25),
            State = service.State.ToString().PadRight(10),
            Messages = GetMessages(service)
            })
          })
    .ToList();
  }

  private string GetMessages(IServiceMonitor service)
  {
    var requester = service as RequesterMonitor;
    if(requester != null) return GetRequesterMessages(requester);

    var mailwatcher = service as MailWatcherMonitor;
    if(mailwatcher != null) return GetMailWatcherMessages(mailwatcher);

    var sendmail= service as SendMailMonitor;
    if(sendmail != null) return GetSendMailWatcherMessages(sendmail);

    var sqlMon= service as SQLMonitor;
    if(sqlMon != null) return GetSqlMonitorMessages(sqlMon);

    return string.Empty;
  }

  private string GetRequesterMessages(RequesterMonitor service)
  {
    return string.Join(
        ", ",
        service.Connections
        .GroupBy(connection => connection.Status)
        .Select(connections => string.Format("{0} {1}", connections.Count(), connections.Key)));
  }

  private string GetMailWatcherMessages(MailWatcherMonitor monitor)
  {
    return monitor.GetMessage();
  }

  private string GetSendMailWatcherMessages(SendMailMonitor monitor)
  {
    return monitor.GetMessage();
  }

	private string GetSqlMonitorMessages(SQLMonitor monitor)
    {
        return monitor.GetMessage();
    }


}

#region Inforce

public class InforceMonitor : ServiceMonitorBase
{
  private readonly int _documentId;
  private readonly Poller _poller;

  public InforceMonitor(int documentId)
  {
    _documentId = documentId;
    _poller = new Poller();
  }

  public override void Start()
  {
    _poller.Start(
        TimeSpan.FromMinutes(5.0), 
        Poll, 
        ex =>
        {
        State = ServiceState.Down;
        });
  }

  public override void Stop()
  {
    _poller.Stop();
  }

  private void Poll()
  {
    var url = string.Format("https://ics.nationallifegroup.com/ICS/PDFFiles/{0}.pdf", _documentId);
    var request = System.Net.HttpWebRequest.Create(url);
    var response = request.GetResponse();

    if(((System.Net.HttpWebResponse)response).StatusCode != System.Net.HttpStatusCode.OK)
    {
      throw new Exception("Inforce is unavailable.");
    }

    State = ServiceState.Up;
  }
}

#endregion

#region Requester/Dispatcher

public class RequesterMonitor : ServiceMonitorBase
{
  private LogFilePoller _requester;
  private LogFilePoller _dispatcher;
  private readonly List<string> _errors = new List<string>();

  public RequesterMonitor(
      LogFileConfiguration requesterConfiguration,
      LogFileConfiguration dispatcherConfiguration)
  {
    _requester = new LogFilePoller(requesterConfiguration);
    _dispatcher = new LogFilePoller(dispatcherConfiguration);
    Name = "Requester/Dispatcher";
    Packages = new List<Package>();
    Connections = new List<Connection>();
  }

  public List<Package> Packages { get; private set; }

  public List<Connection> Connections { get; private set; }

  public int MaxConnections { get; private set; }

  public override void Start()
  {
    _requester.Start(RequesterLogReceived, ex => State = ServiceState.Unknown);
    _dispatcher.Start(DispatcherLogReceived, ex => State = ServiceState.Unknown);
  }

  public override void Stop()
  {
    _requester.Stop();
    _dispatcher.Stop();
  }

  private void RequesterLogReceived(string log)
  {
    var entries = GetLogEntries(log);
    var count = entries.Count - 8; // must have at least 8 lines of package information

    lock (Packages)
    {
      for(var i = 0; i < count; i++)
      {
        var entry = entries[i];

        if(entry.Message.StartsWith("Package["))
        {
          AnalyzeRequesterPackage(entries.Skip(i).Take(8).ToList());
          i += 8;
        }
      }

      PurgePackages();
      UpdateStatus();
    }
  }

  private void AnalyzeRequesterPackage(List<LogEntry> entries)
  {
    var id = 0;

    try
    {	        
      var entry = entries[0].Message;
      var offset = entry.IndexOf(']');
      if(offset < 0) return;
      id = int.Parse(entry.Substring(8, offset - 8));
      var package = GetPackage(id);
      package.Requested = entries[1].Stamp;
      entry = entries[2].Message;
      offset = entry.IndexOf(':') + 1;
      if(offset > 0 && offset < entry.Length) package.Completed = DateTime.Parse(entry.Substring(offset));
      entry = entries[5].Message;
      offset = entry.IndexOf(':') + 1;
      if(offset > 0 && offset < entry.Length) package.User = entry.Substring(offset).Trim();
      entry = entries[7].Message;
      var parts = entry.Split(' ');
      if(parts.Length > 1) package.Policy = parts[parts.Length - 2];
    }
    catch (Exception ex)
    {
      var builder = new StringBuilder();
      builder.Append("Error parsing package");

      if(id > 0) 
        builder.Append(' ').Append(id);

      builder.Append(": ");
      builder.AppendLine(ex.Message);
      builder.AppendLine(string.Join("\r\n", entries.Select(entry => entry.Message)));
      AddError(builder.ToString());
    }
  }

  private Package GetPackage(int id)
  {
    return Packages.FirstOrDefault(package => package.Id == id) 
      ?? CreatePackage(id);
  }

  private Package CreatePackage(int id)
  {
    var package = new Package{Id = id};
    Packages.Add(package);
    return package;
  }

  private Connection GetConnection(int id)
  {
    return Connections.FirstOrDefault(connection => connection.Id == id) 
      ?? CreateConnection(id);
  }

  private void RemoveConnection(int id)
  {
    var connection = Connections.FirstOrDefault(c => c.Id == id);
    if(connection == null) return;
    Connections.Remove(connection);
  }

  private Connection CreateConnection(int id)
  {
    var connection = new Connection{Id = id};
    Connections.Add(connection);
    MaxConnections = Connections.Count;
    return connection;
  }

  private void PurgePackages()
  {
    // remove packages finished more than a minute ago

    var now = DateTime.Now;
    var cutoff = TimeSpan.FromMinutes(1.0);

    Packages
      .Where(package => package.Completed.HasValue)
      .Where(package => now.Subtract(package.Completed.Value) > cutoff)
      .ToList()
      .ForEach(package => Packages.Remove(package));
  }

  private void UpdateStatus()
  {
    // first remove incomplete packages which are not referenced by any connection
    Packages
      .Where(package => !package.Completed.HasValue && Connections.All(connection => connection.Package != package))
      .ToList()
      .ForEach(package => Packages.Remove(package));

    var workingCount = Packages.Where(package => !package.Completed.HasValue).Count();
    var completedCount = Packages.Where(package => package.Completed.HasValue).Count();

    Status = string.Join(
        "\r\n", 
        Connections
        .OrderBy(connection => connection.Id)
        .Select(connection => connection.ToString())
        //				// show packages which are working or were completed in the past minute
        //				.Union(
        //					Packages
        //						.Where(package => !string.IsNullOrEmpty(package.Policy))
        //						.OrderByDescending(package => package.Id)
        //						.Select(package => package.ToString()))
        .Union(new[]
          {
          string.Format("\r\nworking: {0}", workingCount),
          string.Format("completed in last 60 seconds: {0}\r\n", completedCount)
          })
        .Union(_errors));

    State = Connections.Count == MaxConnections ? ServiceState.Up : ServiceState.Down;
    var name = _servers.First(server => server.ServiceMonitors.Contains(this)).Name;
    var message = string.Format("DISPATCHER IS DOWN ON {0}", name);

    if(State != ServiceState.Up)
      AddError(message);
    else
      _errors.Remove(message);
  }

  private void DispatcherLogReceived(string log)
  {
    var entries = GetLogEntries(log);

    Func<string, string> untilParenthesis = value => 
    {
      if(string.IsNullOrWhiteSpace(value)) return string.Empty;
      var offset = value.IndexOf('(');
      return offset > 0 ? value.Substring(0, offset) : value;
    };

    Func<string, int?> parsePackageId = id => 
    {
      decimal value;

      return decimal.TryParse(id, out value) 
        ? (int?) Math.Truncate(value)
        : null;
    };

    Func<string[], int> parseConnectionId = entry => 
    {
      var id = entry[1];
      var value = 0;
      if(id.Equals("index", StringComparison.OrdinalIgnoreCase)) id = entry[2];

      if(!int.TryParse(id, out value)) 
        AddError(string.Format("The value '{0}' is not a valid integer.", id));

      return value;
    };

    lock(Packages)
    {
      try
      {
        entries
          .Select(entry => entry.Message.Split(
                new[]{' ', '[', ']'}, 
                StringSplitOptions.RemoveEmptyEntries))
          .Where(entry => entry[0].Equals("GroupManager"))
          .Select(entry => new
              {
              Id = parseConnectionId(entry),
              Status = untilParenthesis(entry[2]),
              PackageId = entry[entry.Length-2].Equals("Package")
              ? parsePackageId(entry[entry.Length-1])
              : null
              })
        .ToList()
          .ForEach(entry => 
              {
              if(entry.Status.Equals("terminated"))
              {
              RemoveConnection(entry.Id);
              return;
              }

              var connection = GetConnection(entry.Id);
              connection.Status = entry.Status;
              connection.Package = entry.Status.Equals("ready")
              ? null
              : entry.PackageId.HasValue ? GetPackage(entry.PackageId.Value) : connection.Package;
              });
      }
      catch (Exception ex)
      {
        AddError(string.Format("Error parsing package: {0}", ex.Message));
      }

      UpdateStatus();
    }
  }

  private List<LogEntry> GetLogEntries(string log)
  {
    try
    {	        
      return log.Split(new[]{'\r', '\n'}, int.MaxValue, StringSplitOptions.RemoveEmptyEntries)
        .Skip(1)
        .Select(line => new LogEntry(line))
        .Where(entry => entry.Message != null)
        .ToList();
    }
    catch (Exception ex)
    {
      AddError(string.Format("Error getting log entries: {0}", ex.Message));
      return new List<LogEntry>();
    }
  }

  private void AddError(string message)
  {
    if(!_errors.Contains(message)) _errors.Add(message);
  }
}

public class LogEntry
{
  public LogEntry(string line)
  {
    try
    {	        
      var parts = line.Split(new[]{" > "}, StringSplitOptions.None);
      TimeSpan time;
      TimeSpan.TryParse(parts[0], out time);
      Stamp = DateTime.Today.Add(time);
      Message = parts.Length > 1 ? parts[1] : string.Empty;
    }
    catch (Exception ex)
    {
      string.Format("Log line\r\n{0}\r\nfailed with the following message: {1}", line, ex.Message);
    }
  }

  public DateTime Stamp { get; private set; }

  public string Message { get; private set; }
}

public class Package
{
  public int Id { get; set; }

  public string Policy { get; set; }

  public DateTime Requested { get; set; }

  public DateTime? Completed { get; set; }

  public string User { get; set; }

  public int Connection { get; set; }

  public override string ToString()
  {
    //		var completed = Completed.HasValue 
    //			? string.Format("completed at {0:HH:mm:ss}", Completed.Value) 
    //			: "working...";

    return string.Format(
        "package {0} ({1}) requested by {2}", // at {3:HH:mm:ss}; {4}",
        Id,
        Policy,
        User);
    //			Requested,
    //			completed);
  }
}

public class Connection
{
  public int Id { get; set; }

  public Package Package { get; set; }

  public string Status { get; set; }

  public override string ToString()
  {
    var package = Package == null 
      ? string.Empty 
      : Package.ToString();

    return string.Format("connection {0} ({1}) {2}", Id, Status, package);
  }
}

#endregion

#region OnBase

public class OnBaseMonitor : ServiceMonitorBase
{
  private readonly Poller _poller = new Poller();
  private readonly int _pollSeconds;
  private readonly string _machineName;
  private readonly string _userName;
  private readonly string _password;

  public OnBaseMonitor(int pollSeconds, string machineName)
    : this(pollSeconds, machineName, null, null)
  {
  }

  public OnBaseMonitor(int pollSeconds, string machineName, string userName, string password)
  {
    _pollSeconds = pollSeconds;
    _machineName = machineName;
    _userName = userName;
    _password = password;
    Name = "OnBase Client";
    Status = string.Empty;
  }

  public override void Start()
  {
    _poller.Start(TimeSpan.FromSeconds(_pollSeconds), Poll, ex => ex.Message.Dump());
  }

  public override void Stop()
  {
    _poller.Stop();
  }

  public void Poll()
  {
    // tasklist /s nlgpnbaprc05 /fi "imagename eq obclnt32.exe"
    using(var process = new Process())
    {
      process.StartInfo = new ProcessStartInfo
      {
        CreateNoWindow = true,
                       RedirectStandardOutput = true,
                       FileName = "tasklist",
                       Arguments = _userName == null 
                         ? string.Format("/s {0} /fi \"imagename eq obclnt32.exe\"", _machineName)
                         : string.Format("/u {0} /p {1} /s {2} /fi \"imagename eq obclnt32.exe\"", _userName, _password, _machineName),
                       UseShellExecute = false
      };

      process.Start();
      var result = process.StandardOutput.ReadToEnd();
      process.WaitForExit();

      var count = result.Split(new[]{'\n'},StringSplitOptions.RemoveEmptyEntries)
        .Count(line => line.StartsWith("obclnt32.exe"));

      // TODO:  Should this be:
      //  <1 : Down
      //  >1 : Unknown  - shouldn't be in this condition
      //  ?
      State = count > 1 
        ? ServiceState.Down 
        : count < 1 ? ServiceState.Unknown : ServiceState.Up;
    }
  }
}

#endregion

#region MailWatcher

public class MailWatcherMonitor : ServiceMonitorBase
{
  private LogFilePoller _mailwatcher;
  private readonly List<string> _errors = new List<string>();

  public MailWatcherMonitor(
      LogFileConfiguration mwConfiguration)
  {
    _mailwatcher = new LogFilePoller(mwConfiguration);
    Name = "MailWatcher";
  }

  public override void Start()
  {
    prevStamp = latestStamp = DateTime.Now;
    _mailwatcher.Start(MailWatcherLogReceived, ex => State = ServiceState.Unknown);
  }

  public override void Stop()
  {
    _mailwatcher.Stop();
  }

  string latestMWLogMsg;
  DateTime prevStamp;
  DateTime latestStamp;
  private void MailWatcherLogReceived(string log)
  {
    var entries = GetLogEntries(log);
    var count = entries.Count - 8; // must have at least 8 lines of package information

    MWLogEntry entry = entries[entries.Count - 1];
    latestMWLogMsg = entry.Message;

    latestStamp = entry.Stamp;

    UpdateStatus();
  }

  private string StatusMsg;
  public string GetMessage()
  {
    return StatusMsg;
  }


  private void UpdateStatus()
  {

    Status = "Who dat?";

    DateTime now = DateTime.Now;
    TimeSpan diff = latestStamp - prevStamp;
    TimeSpan nowDiff = now - latestStamp;
    if(diff.Minutes < nowDiff.Minutes) {
      diff = nowDiff;
    }

    prevStamp = latestStamp;


    if(diff.Minutes > 5) {
      State = ServiceState.Down;
    }
    else if (diff.Minutes > 3) {
      State = ServiceState.Unknown;
    }
    else {
      State = ServiceState.Up;
    }


    if(State != ServiceState.Up) {
      StatusMsg = string.Format("Time since last log entry: {0}:{1}", diff.Minutes, diff.Seconds);
      AddError(StatusMsg);
    }
    else {
      // StatusMsg = string.Format("Last diff: {0}:{1}", diff.Minutes, diff.Seconds);
      StatusMsg = string.Format("Last entry: {0} {1}{2}", 
          // latestStamp.ToLongTimeString(), 
          latestStamp.ToString("HH:mm"), 
          Environment.NewLine,
          latestMWLogMsg);

      _errors.Remove(StatusMsg);
    }
  }

  private List<MWLogEntry> GetLogEntries(string log)
  {
    try
    {	        
      return log.Split(new[]{'\r', '\n'}, int.MaxValue, StringSplitOptions.RemoveEmptyEntries)
        .Skip(1)
        .Select(line => new MWLogEntry(line))
        .Where(entry => entry.Message != null)
        .ToList();
    }
    catch (Exception ex)
    {
      AddError(string.Format("Error getting log entries: {0}", ex.Message));
      return new List<MWLogEntry>();
    }
  }

  private void AddError(string message)
  {
    if(!_errors.Contains(message)) _errors.Add(message);
  }
} // class MailWatcherMonitor

public class SendMailMonitor : ServiceMonitorBase
{
  private LogFilePoller _mailwatcher;
  private readonly List<string> _errors = new List<string>();

  public SendMailMonitor(
      LogFileConfiguration mwConfiguration)
  {
    _mailwatcher = new LogFilePoller(mwConfiguration);
    Name = "SendMail";
  }

  public override void Start()
  {
    prevStamp = latestStamp = DateTime.Now;
    _mailwatcher.Start(SendMailLogReceived, ex => State = ServiceState.Unknown);
  }

  public override void Stop()
  {
    _mailwatcher.Stop();
  }

  string latestMWLogMsg;
  DateTime prevStamp;
  DateTime latestStamp;
  private void SendMailLogReceived(string log)
  {
    var entries = GetLogEntries(log);
    var count = entries.Count - 8; // must have at least 8 lines of package information

    SMLogEntry entry = entries[entries.Count - 1];
    latestMWLogMsg = entry.Message;

    latestStamp = entry.Stamp;

    UpdateStatus();
  }

  private string StatusMsg;
  public string GetMessage()
  {
    return StatusMsg;
  }


  private void UpdateStatus()
  {

    Status = "Who dat?";

    DateTime now = DateTime.Now;
    TimeSpan diff = latestStamp - prevStamp;
    TimeSpan nowDiff = now - latestStamp;
    if(diff.Minutes < nowDiff.Minutes) {
      diff = nowDiff;
    }

    prevStamp = latestStamp;


    if(diff.Minutes > 10) {
      State = ServiceState.Down;
    }
    else if (diff.Minutes > 4) {
      State = ServiceState.Unknown;
    }
    else {
      State = ServiceState.Up;
    }


    if(State != ServiceState.Up) {
      StatusMsg = string.Format("Time since last log entry: {0}:{1}", diff.Minutes, diff.Seconds);
      AddError(StatusMsg);
    }
    else {
      // StatusMsg = string.Format("Last diff: {0}:{1}", diff.Minutes, diff.Seconds);
      StatusMsg = string.Format("Last entry: {0} {1}{2}", 
          // latestStamp.ToLongTimeString(), 
          latestStamp.ToString("HH:mm"), 
          Environment.NewLine,
          latestMWLogMsg);

      _errors.Remove(StatusMsg);
    }
  }

  private List<SMLogEntry> GetLogEntries(string log)
  {
    try
    {	        
      return log.Split(new[]{'\r', '\n'}, int.MaxValue, StringSplitOptions.RemoveEmptyEntries)
        .Skip(1)
        .Select(line => new SMLogEntry(line))
        .Where(entry => entry.Message != null)
        .ToList();
    }
    catch (Exception ex)
    {
      AddError(string.Format("Error getting log entries: {0}", ex.Message));
      return new List<SMLogEntry>();
    }
  }

  private void AddError(string message)
  {
    if(!_errors.Contains(message)) _errors.Add(message);
  }
} // class SendMailMonitor

/*
   Sample MailWatcher log entries:
   2014-02-19 09:50:58 BM          OnBaseDisconnect
   2014-02-19 09:50:58 BM            OnBaseCall: Disconnect
   2014-02-19 09:50:59 MW        ShowKeyValues: outArgs
   2014-02-19 09:50:59 MW        outArgs...
   2014-02-19 09:50:59 MW        : batchName = OnBase: 236/4294913
   2014-02-19 09:50:59 MW        : processed =
   2014-02-19 09:50:59 MW         :MSG: Policy # 2044659 - Lowe
   2014-02-19 09:50:59 MW         :\\corp\hdq\data\iss\installs\NBA Releases\NBAPRC\MailWatcher.2013\work\3dd32dd7-02cf-40
   0e-9d27-b2189572db5e\Policy # 2044659 - Lowe - Beneficiary Chg Request.pdf
   2014-02-19 09:50:59 MW        : BatchID = 4294913
   2014-02-19 09:50:59 MW
   2014-02-19 09:50:59 MW        insert nba_log (nlog_action, nlog_text, nlog_retention) values ('message.good', 'Matt Wal
ker : Policy # 2044659 - Lowe', 99)
2014-02-19 09:50:59 MW        MoveMessage: Processed
2014-02-19 09:50:59 MW    ProcessMailbox: Claims Department
2014-02-19 09:51:00 MW    ProcessMailbox: Address Changes
2014-02-19 09:51:00 MW    ProcessMailbox: Disbursements
2014-02-19 09:51:00 MW    ProcessMailbox: Rewrites
2014-02-19 09:51:01 MW    ProcessMailbox: Top Agents
2014-02-19 09:51:02 MW    ProcessMailbox: ACA Application Images
2014-02-19 09:51:02 MW    ProcessMailbox: Multilife
2014-02-19 09:51:03 MW    ProcessMailbox: AGY Tag Lines
*/


public class MWLogEntry
{
  StringBuilder bldr = new StringBuilder();

  public MWLogEntry(string line)
  {
    try
    {	        
      var parts = line.Split(new Char [] {' ', '\t', '\n' }, StringSplitOptions.None);
      TimeSpan time;
      TimeSpan.TryParse(parts[1], out time);
      Stamp = DateTime.Today.Add(time);

      bldr.Clear();
      int max = Math.Max(12, parts.Length);
      // Message = string.Format("Parts count: {0}", parts.Length);
      for (int i = 3; i < max; i++)
      {
        if (!string.IsNullOrWhiteSpace(parts[i]))
        {
          bldr.Append(" ");
          bldr.Append(parts[i]);
        }
      }

      Message = parts.Length >= 3 
        ?  bldr.ToString() 
        : string.Empty;
      // Message.Dump();
    }
    catch (Exception ex)
    {
      string.Format("Log line\r\n{0}\r\nfailed with the following message: {1}", line, ex.Message);
    }
  }


  public DateTime Stamp { get; private set; }

  public string Message { get; private set; }
}


public class SMLogEntry
{
  StringBuilder bldr = new StringBuilder();

  public SMLogEntry(string line)
  {
    try
    {	        
      var parts = line.Split(new Char [] {' ', '\t', '\n' }, StringSplitOptions.None);
      TimeSpan time;
      if (TimeSpan.TryParse(parts[1], out time)) {
        Stamp = DateTime.Today.Add(time);

        bldr.Clear();
        int max = Math.Max(12, parts.Length);
        // Message = string.Format("Parts count: {0}", parts.Length);
        for (int i = 3; i < max; i++)
        {
          if (!string.IsNullOrWhiteSpace(parts[i]))
          {
            bldr.Append(" ");
            bldr.Append(parts[i]);
          }
        }

        Message = parts.Length >= 3 
          ?  bldr.ToString() 
          : string.Empty;
        // Message.Dump();
      }
      else {
        Message = string.Empty;
      }

    }
    catch (Exception ex)
    {
      string.Format("Log line\r\n{0}\r\nfailed with the following message: {1}", line, ex.Message);
    }
  }


  public DateTime Stamp { get; private set; }

  public string Message { get; private set; }
}

#endregion MailWatcher

// SendMail log
/*
2014-02-26 14:49:27 ProcessOneCycle
2014-02-26 14:49:27 
2014-02-26 14:49:27 select * from nba_event_processing_queue
where nepq_class = 'SendMail'
and nepq_status = 'ready'
and isnull(nepq_wait_until_dt, getdate()) <= getdate()
and nepq_id not in (select nepq_id from MessageInfo where attribute = 'error' group by nepq_id having count(*) > 5)
order by nepq_id

2014-02-26 14:49:27 delete nba_event_processing_queue
where nepq_class = 'SendMail'
and nepq_status = 'done'
and datediff(day, nepq_last_processed_dt, getdate()) > 3

2014-02-26 14:49:27 
2014-02-26 14:49:27 update nba_parameters set npar_value = getdate() where npar_code = 'SendMail.Running'

2014-02-26 14:50:27 ProcessOneCycle
2014-02-26 14:50:28
2014-02-26 14:50:28 select * from nba_event_processing_queue
where nepq_class = 'SendMail'
and nepq_status = 'ready'
and isnull(nepq_wait_until_dt, getdate()) <= getdate()
and nepq_id not in (select nepq_id from MessageInfo where attribute = 'error' group by nepq_id having count(*) > 5)
order by nepq_id

2014-02-26 14:50:28 delete nba_event_processing_queue
where nepq_class = 'SendMail'
and nepq_status = 'done'
and datediff(day, nepq_last_processed_dt, getdate()) > 3

2014-02-26 14:50:28 
2014-02-26 14:50:28 update nba_parameters set npar_value = getdate() where npar_code = 'SendMail.Running'

*/



public class SQLMonitor : ServiceMonitorBase
{
	private long _pollSeconds;
	private readonly Poller _poller = new Poller();
    private TypedDataContext dbContext;
	
	public SQLMonitor(int pollSeconds, TypedDataContext context)
	{
        _pollSeconds = pollSeconds;
		dbContext = context;
		Name = "SQL Monitor";
		Status = string.Empty;
	}
	
  public string GetMessage()
  {
    return Status ;
  }
	
	public override void Start()
	{
		_poller.Start(TimeSpan.FromSeconds(_pollSeconds), Poll, ex => ex.Message.Dump());
	}
	
	public override void Stop()
	{
		_poller.Stop();
	}
	
	public void Poll()
	{
		// tasklist /s nlgpnbaprc05 /fi "imagename eq obclnt32.exe"

    var cnt = dbContext.FL_MODIFies.Select(t => t.CASE_POL_NO).Distinct().Count();
    Status = string.Format("FL_MODIFY backlog:  {0}", cnt.ToString());
    State = ServiceState.Up;
	}
}


/// <summary>
/// The state of a machine or service.
/// </summary>
public enum ServiceState
{
  /// <summary>
  /// The parent is unreachable; thus, the service state is unknown.
  /// </summary>
  Unknown = 0,

  /// <summary>
  /// The machine or service is running correctly.
  /// </summary>
  Up,

  /// <summary>
  /// The machine or service is not running.
  /// </summary>
  Down
}

/// <summary>
/// An abstract base class for implementing an <see cref="IServiceMonitor"/>.
/// </summary>
public abstract class ServiceMonitorBase : IServiceMonitor
{
  private string _status;
  private ServiceState _state;

  /// <inheritdoc/>
  public event EventHandler StatusChanged;

  /// <inheritdoc/>
  public string Name { get; protected set; }

  /// <inheritdoc/>
  public string Status 
  { 
    get { return _status; } 

    protected set
    {
      if(_status != value)
      {
        _status = value;
        OnStatusChanged();
      }
    }
  }

  /// <inheritdoc/>
  public ServiceState State
  { 
    get { return _state; } 

    protected set
    {
      if(_state != value)
      {
        _state = value;
        OnStatusChanged();
      }
    }
  }

  /// <inheritdoc/>
  public abstract void Start();

  /// <inheritdoc/>
  public abstract void Stop();

  /// <inheritdoc/>
  public void Dispose()
  {
    try
    {	        
      Stop();
    }
    catch (Exception ex)
    {
      string.Format("Error on dispose for {0}: {1}", this, ex.Message).Dump();
    }
  }

  protected void OnStatusChanged()
  {
    if(StatusChanged != null)
    {
      try
      {	        
        StatusChanged(this, EventArgs.Empty);
      }
      catch (Exception ex)
      {
        string.Format("Error on status changed for {0}: {1}", this, ex.Message).Dump();
      }
    }
  }
}

/// <summary>
/// Monitors a running service and reports state.
/// </summary>
public interface IServiceMonitor : IDisposable
{
  /// <summary>
  /// Raised when the status or state of the service has changed.
  /// </summary>
  event EventHandler StatusChanged;

  /// <summary>
  /// The name of the service.
  /// </summary>
  string Name { get; }

  /// <summary>
  /// The current status of the service, such as "loading policy NL123456".
  /// </summary>
  string Status { get; }

  /// <summary>
  /// The state of the service.
  /// </summary>
  ServiceState State { get; }

  /// <summary>
  /// Start (or re-start) the service.
  /// </summary>
  void Start();

  /// <summary>
  /// Stop the service.
  /// </summary>
  void Stop();
}

/// <summary>
/// Configuration information for a <see cref="LogFilePoller"/>.
/// </summary>
public class LogFileConfiguration
{
  /// <summary>
  /// The full path of the log file.
  /// </summary>
  public string FullPath { get; set; }

  /// <summary>
  /// The maximum number of bytes to poll from the end of the log file.
  /// </summary>
  public int MaxPollingBytes { get; set; }

  /// <summary>
  /// The amount of time to wait between polling attempts.
  /// </summary>
  public TimeSpan PollingInterval { get; set; }
}

/// <summary>
/// Implements a daemon which will repeatedly poll the end of a log file.
/// </summary>
public class LogFilePoller : IDisposable
{
  private readonly LogFileConfiguration _logFile;
  private readonly Poller _poller = new Poller();
  private DateTime _lastChanged;

  public LogFilePoller(LogFileConfiguration logFile)
  {
    _logFile = logFile;
  }

  /// <summary>
  /// Start polling. If the daemon is already started, restart it.
  /// </summary>
  /// <param name="onLogReceived">The action to execute when log data is received.</param>
  /// <param name="onError">
  /// The action to take when the polling process encounters an unhandled exception, or null 
  /// to take no action and suppress exceptions.
  /// </param>
  public void Start(Action<string> onLogReceived, Action<Exception> onError)
  {
    _poller.Start(
        _logFile.PollingInterval,
        () => 
        {
        var log = Poll();
        if(log != null) onLogReceived(log);
        },
        onError);
  }

  /// <summary>
  /// Stop polling.
  /// </summary>
  public void Stop()
  {
    _poller.Stop();
  }

  private string Poll()
  {
    var info = new FileInfo(_logFile.FullPath);
    var lastChanged = info.LastWriteTime;
    if(lastChanged <= _lastChanged) return null;
    _lastChanged = lastChanged;
    var fileSize = info.Length;

    var pollSize = (int) (fileSize > _logFile.MaxPollingBytes 
        ? _logFile.MaxPollingBytes 
        : fileSize);

    if(pollSize < 1) return string.Empty;
    var buffer = new byte[pollSize];
    //string.Format("{0:hh:mm:ss.fff} polling for {1} bytes", DateTime.Now, pollSize).Dump();

    using(
        var stream = new FileStream(
          _logFile.FullPath,
          FileMode.Open,
          FileAccess.Read,
          FileShare.ReadWrite))
    {
      stream.Position = fileSize - pollSize;
      var count = 0;

      do
      {
        count += stream.Read(buffer, count, pollSize - count);
        string.Format("got {0} bytes", count).Dump();
      } while(count < pollSize);
    }

    //
    // Deal with ^M in SendMail log - 
    // ^M is CR (ascii 13) and paired with LF (10) in Windows text files.
    // Replace a naked CR with space (32).
    for (int i = 0; i < buffer.Length - 1; i++)
    {
      if (buffer[i] == 13 && buffer[i+1] != 10)
      {
        buffer[i] = 32;
      }
    }
    //string.Format("{0:hh:mm:ss.fff} finished polling", DateTime.Now).Dump();
    return Encoding.Default.GetString(buffer);
  }

  void IDisposable.Dispose(){ Stop(); }
}

/// <summary>
/// Abstracts the logic of polling with a delay.
/// </summary>
public class Poller : IDisposable
{
  private readonly object _sync = new object();
  private Timer _timer;

  /// <summary>
  /// Start polling. If polling has already started, restart it.
  /// </summary>
  /// <param name="interval">The time to wait between poll attempts.</param>
  /// <param name="onPoll">The action to take when it is time to poll.</param>
  /// <param name="onError">
  /// The action to take when the polling process encounters an unhandled exception, or null 
  /// to take no action and suppress exceptions.
  /// </param>
  public void Start(TimeSpan interval, Action onPoll, Action<Exception> onError)
  {
    if(onPoll == null) throw new ArgumentNullException("onPoll");

    lock(_sync)
    {
      Stop();

      _timer = new Timer(
          state => 
          {
          try
          {
          onPoll();
          }
          catch (Exception ex)
          {
          if(onError == null) return;
          onError(ex);
          }
          finally
          {
          lock(_sync)
          {
          if(_timer == null)
          {
          "TIMER IS NULL!!!".Dump();
          }

          if(_timer != null)
            _timer.Change((int)interval.TotalMilliseconds, Timeout.Infinite);
          }
          }
          }, 
        null, 
        0, 
        Timeout.Infinite);
    }
  }

  /// <summary>
  /// Stop polling.
  /// </summary>
  public void Stop()
  {
    lock(_sync)
    {
      if(_timer == null) return;
      _timer.Dispose();
      _timer = null;
    }
  }

  void IDisposable.Dispose(){ Stop(); }
}

public interface IOperation
{
  void Execute();

  void BeginExecute(object context, Action<object> onComplete);
}

public abstract class Operation : IOperation
{
  public abstract void Execute();

  public void BeginExecute(object context, Action<object> onComplete)
  {
    new Thread(() => 
        {
        Execute();
        if(onComplete != null) onComplete(context);
        })
    {IsBackground = false}.Start();
  }
}