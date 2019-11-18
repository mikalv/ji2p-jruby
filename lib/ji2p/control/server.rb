require 'java'
require 'thread'

module Ji2p::Control

  class ServerConnection
    def initialize i2pconn
      @i2pconn = i2pconn
    end

    def raw
      @i2pconn
    end

    def close
      @i2pconn.close
    end

    def is_closed?
      @i2pconn.is_closed
    end

    def write data
      @i2pconn.getOutputStream.write data.to_java_bytes
    end

    def getPeerDestination
      @i2pconn.getPeerDestination
    end

    def readstring n=nil
      String.from_java_bytes readbytes(n || readybytes)
    end

    def readline
      line = ""
      loop {
        c = String.from_java_bytes(readbytes(1))
        break if c=="\n"
        line += c
      }
      line + "\n"
    end

    def readbytes n=nil
      return nil if is_closed?
      num = n || readybytes
      @i2pconn.getInputStream.readNBytes num
    end

    def readybytes
      @i2pconn.getInputStream.totalReadySize
    end

    alias :read :readstring
    alias :gets :readline
    alias :puts :write

    def toString
      b32 = @i2pconn.getPeerDestination.toBase32
      "<ServerConnection client=#{b32} is_closed=#{@i2pconn.is_closed}>"
    end
  end

  class SocketServer

    def initialize i2psocket
      @i2psocket = i2psocket
    end

    def accept
      ServerConnection.new @i2psocket.accept
    end

    def raw
      @i2psocket
    end
  end

end
