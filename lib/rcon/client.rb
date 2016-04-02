require 'timeout'

module Rcon
  class Client
    PROTO_PREFIX = "\xff\xff\xff\xff".freeze
    attr_reader :host, :port, :challenge

    def self.finalize(socket)
      proc { socket&.close }
    end

    def initialize(host, port, password)
      @host = host
      @port = port
      @password = password
      @count = 0
      @socket = UDPSocket.new
      ObjectSpace.define_finalizer(self, self.class.finalize(socket))
    end

    def send_cmd(cmd_string)
      prepare_challenge if challenge.nil?
      send_packet "rcon #{challenge} #{password} #{cmd_string}"
    end

    def last_response(size = 64, wait:)
      retries = 0
      begin
        socket.recvfrom_nonblock(size).first
      rescue IO::EAGAINWaitReadable
        retries += 1
        if wait && retries <= 1
          sleep 1 # wait 1 second before retry
          retry
        end
      end
    end

    private

    attr_reader :socket, :password

    def prepare_challenge
      send_packet 'challenge rcon'
      # Give the server some time to respond
      response = last_response(wait: true)
      if response&.length.to_i > 0
        @challenge = response[4..-2].chomp.split.last
      end
    end

    def send_packet(cmd_string)
      socket.send("#{PROTO_PREFIX}#{cmd_string}", 0, host, port)
    end
  end
end
