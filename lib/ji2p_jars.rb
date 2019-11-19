# this is a generated file, to avoid over-writing it just delete this comment
begin
  require 'jar_dependencies'
rescue LoadError
  require 'net/i2p/router/0.9.43/router-0.9.43.jar'
  require 'net/i2p/client/mstreaming/0.9.43/mstreaming-0.9.43.jar'
  require 'net/i2p/client/streaming/0.9.43/streaming-0.9.43.jar'
  require 'net/i2p/i2p/0.9.43/i2p-0.9.43.jar'
end

if defined? Jars
  require_jar 'net.i2p', 'router', '0.9.43'
  require_jar 'net.i2p.client', 'mstreaming', '0.9.43'
  require_jar 'net.i2p.client', 'streaming', '0.9.43'
  require_jar 'net.i2p', 'i2p', '0.9.43'
end
