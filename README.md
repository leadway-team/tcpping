# TcpPing v0.1.4

A simple utility for sending requests to a TCP server.

## Compiling and Running the Application

First, clone the repository:  
`git clone https://github.com/leadway-team/tcpping.git`

If you want to compile and run immediately:  
`dub run --build=release`  
If you only want to compile:  
`dub build --build=release`

The compiled version will be placed in the root folder.  

## Application Usage

TcpPing has two usage modes:  
1. "Quick" mode (introduced in v0.1.1, expanded in v0.1.2)  
2. TcpPing Console (introduced in v0.1.2)

### Using "Quick" Mode

The `-q` flag enables "Quick" mode.  
Immediately after it, specify either `-a [TCP server address]` or `--address [TCP server address]`.  
After the address, provide either `-s [message]` or `--send [message]`.

This will send your message to the specified TCP server.  
Example:  
`tcpping -q -a 127.0.0.1:1234 -s Hello`

### Using TcpPing Console

To enter TcpPing Console, simply run without arguments.

Inside the console, the following commands are available:  
- `help` – displays help information  
- `ver` – shows version  
- `connect [address]` – connects to a TCP server. If no address is provided, the program will prompt you.  
- `send [message]` – sends a message to the TCP server. If no message is provided, the program will prompt you.  
- `sendw [message]` - does the same as send, but also waits for a response from the server.  

Note: Use `connect` before `send` and `sendw`, otherwise the message will not be sent.

### TcpPing Peculiarities

ArduCat had two options:  
1. Reconnect every time a message is sent, allowing the TCP server to be changed.  
2. Not allow changing the TCP server.  

As you can see, ArduCat chose the first option. Every time TcpPing sends a message, it reconnects to the server.  
Please take this into account.

## Acknowledgments
1. Thanks to Grisshink  
2. Thanks to the disbanded FTeam
