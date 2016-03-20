module Commands
  class CommandExecutor
    attr_reader :callee
    def initialize(command_or_block)
      @callee = command_or_block
    end

    def execute(args)
      case callee
        when Class
          callee.execute *args
        when Proc
          callee.call *args
        else
          fail 'Unknown callee'
      end
    end
  end
end
