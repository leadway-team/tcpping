import std.stdio;
import std.socket;
import std.algorithm;
import std.array;
import std.string;
import std.conv;
import consolecolors;

void main(string[] args) {
    enableConsoleUTF8(); /* Required for correct operation on Windows */
    if (args.length <= 1) {
        shell();
    } else {
        if (args[1] == "-q") {
            quick(args);
        } else {
            writeln("Arguments not recognized.");
        }
    }
}

void uerr(string error, char type) {
    switch (type) {
        case 'e':
            cwritefln("tcpping: <b><red>Error:</red> %s</b>", error);
            break;
        case 'i':
            cwritefln("tcpping: <b><cyan>Hint:</cyan> %s</b>", error);
            break;
        case 's':
            cwritefln("tcpping: <b><lgreen>Success!</lgreen></b>");
            break;
        default:
            return;
    }
}

void tcpsend(string addr_s, int port, string msg) {
    auto tcps = new TcpSocket();
    auto addr = new InternetAddress(std.socket.InternetAddress.parse(addr_s), to!ushort(port));
    tcps.connect(addr);
    tcps.send(msg);
    uerr("", 's');
    tcps.close();
}

void tcpsendw(string addr_s, int port, string msg) {
    auto tcps = new TcpSocket();
    auto addr = new InternetAddress(std.socket.InternetAddress.parse(addr_s), to!ushort(port));
    tcps.connect(addr);
    tcps.send(msg);
    
    cwritef("<b>Waiting for a response...</b> ");
    stdout.flush();
    
    ubyte[1024] buf;
    long received = tcps.receive(buf[]);
    
    if (received > 0) {
        auto data = buf[0..cast(size_t)received];
        size_t nullPos = data.countUntil(cast(ubyte)0);
        
        if (nullPos != data.length) {
            data = data[0..nullPos];
        }
        
        string response = cast(string)data;
        write(response);
    } else {
    	uerr("connection closed", 'e');
    	tcps.close();
    	return;
    }
    
    uerr("", 's');
    tcps.close();
}

int quick(string[] args) {
    cwritefln("<b>Quick TcpPing</b>:<b><grey> v0.1.4</grey></b>");
    
    if (args.length < 6) {
        uerr("Not enough arguments.", 'e');
        return(-1);
    }
    
    if (!(args[2] == "-a" || args[2] == "--address")) {
        uerr("Incorrect usage.", 'e');
        uerr("The second argument must be -a [address:port] or --address [address:port]!", 'i');
        return(-1);
    }
    
    if (!(args[4] == "-s" || args[4] == "--send")) {
        uerr("Incorrect usage.", 'e');
        uerr("The third argument must be -s [message] or --send [message]!", 'i');
        return(-1);
    }
    
    string[] tmp = args[3].split(":");
    tcpsend(tmp[0], to!int(tmp[1]), args[5]);
    
    return(0);
}

void shell() {
    cwritefln("<b>TcpPing Console</b>:<b><grey> v0.1.4</grey></b>");
    bool gogo = true;
    string addr_s = "127.0.0.1";
    int port = 5555;
    while (gogo) {
        write("[tcpping] > ");
        stdout.flush();
        string[] input = (stdin.readln().strip()).split();
        switch (input[0]) {
            case "exit":
                gogo = false;
                break;
            case "connect":
                if (input.length == 2) {
                    auto tmp = input[1].findSplit(":");
                    if (tmp[2] != "") {
                        addr_s = tmp[0];
                        port = to!int(tmp[2]);
                        uerr("", 's');
                    } else {
                        uerr("Incorrect usage.", 'e');
                        uerr("Address must be in the format ip:port!", 'i');
                    }
                } else {
                    write("TCP server address: ");
                    stdout.flush();
                    auto tmp = (stdin.readln().strip()).findSplit(":");
                    if (tmp[2] != "") {
                        addr_s = tmp[0];
                        port = to!int(tmp[2]);
                        uerr("", 's');
                    } else {
                        uerr("Incorrect usage.", 'e');
                        uerr("Address must be in the format ip:port!", 'i');
                    }
                }
                break;
            case "send":
                if (input.length == 2) {
                    tcpsend(addr_s, port, input[1]);
                } else {
                    write("Message: ");
                    stdout.flush();
                    string tmp = stdin.readln().strip();
                    tcpsend(addr_s, port, tmp);
                }
                break;
            case "sendw":
                if (input.length == 2) {
                    tcpsendw(addr_s, port, input[1]);
                } else {
                    write("Message: ");
                    stdout.flush();
                    string tmp = stdin.readln().strip();
                    tcpsendw(addr_s, port, tmp);
                }
                break;
            case "help":
                cwritefln("<b>Commands:\n  connect [address:port]</b> - connects to a TCP server. If server address is not specified, you will be prompted. <b><red>USE BEFORE \"send\"!</red>\n  send [message]</b> - sends message to connected TCP server. <b><red>USE AFTER \"connect\"!</red>\n  sendw [message]</b> - does the same as send, but also waits for a response from the server. <b><red>USE AFTER \"connect\"!</red>\n  ver</b> - Displays TcpPing Console version.\n  <b>exit</b> - Exits TcpPing Console.");
                break;
            case "ver":
                cwritefln("<b>TcpPing Console</b>:<b><grey> v0.1.4</grey></b>");
                break;
            
            default:
                uerr("Unknown command: \"" ~ input[0] ~ "\"", 'e');
        }
    }
}
