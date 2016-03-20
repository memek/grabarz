class CsCommand
  include Commands::Dsl

  command :stats,    StatsCommand
  command :register, RegisterCommand

  # Called iff cmd don't match the structure above.
  def default(cmd, *rest)
  end
end
