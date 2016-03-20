module Commands
  module Dsl
    def self.included(base)
      base.extend ClassMethods
      base.prepend DefaultExecutor
    end

    module DefaultExecutor
      def default(cmd, *rest)
        if defined?(super)
          super
        else
          fail NotImplementedError
        end
      end
    end

    module ClassMethods
      def command(cmd, delegator = nil, &block)
        register_cmd(cmd, delegator || block)
      end

      def execute(*args)
        cmd, *rest = args.map(&:to_s).map(&:to_sym)
        registered_commands[cmd]&.execute(rest) || self.new.default(cmd, *rest)
      end

      private

      def registered_commands
        @registered_commands ||= {}
      end

      def register_cmd(cmd, cmd_or_block)
        registered_commands[cmd] = CommandExecutor.new(cmd_or_block)
      end
    end

    def execute(*args)
      cmd, *rest = args.map(&:to_s).map(&:to_sym)
      self.class.send(:registered_commands)[cmd]&.execute(rest) || default(cmd, *rest)
    end
  end
end
