require 'socket'

class SimpleUdpEchoServer
 attr_reader :thread, :port, :challenge

 def initialize(port = 65530, challenge = nil)
   @port = port
   @challenge = challenge || (rand*1_000_000_000).to_i.to_s
 end

  def run
    @thread = Thread.new do
      Socket.udp_server_loop(port) do |msg, src|
        if msg =~ /challenge rcon/
          src.reply "\xff\xff\xff\xffchallenge rcon #{challenge}\n\x00"
        else
          src.reply msg
        end
      end
    end
  end

  def stop
    thread&.terminate
  end
end
