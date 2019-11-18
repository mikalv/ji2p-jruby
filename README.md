# Ji2p - JRuby library

## Installation

**Note:** This is a JRuby only gem, it depends on java.

Gemfile:
```
gem 'ji2p', '~> 0.0.1'
```

CLI:
```
jgem install ji2p
```

## Examples

### Generate / Load destination and private key

```ruby
require 'ji2p'
# Generate new
kp = Ji2p::Control::Keypair.generate!
# Read private key(s) to serializable string
pkey_string = kp.private_key_format
# Load destination from private key stream
stream = StringIO.new pkey_string
kp = Ji2p::Control::Keypair.load_from_stream! stream

```

### Rack HTTP Proxy

```ruby
require 'ji2p'

app = Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }

kp = Ji2p::Control::Keypair.generate!
ssmgr = Ji2p::Control::SocketManager.defineManager! "testing", kp
ssmgr.connectTunnel
socket = ssmgr.getServerSocket
server = Ji2p::Server::HttpServer.new(app, socket)

puts "Your destination: #{kp.dest.base32}"

server.run
```

## TODOs?

* Consider splitting up database code to a sub-gem
* Complete clustering support

