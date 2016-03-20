require_relative '../rails_helper'

describe Commands do
  context 'with empty command class' do
    let(:cmd_class) do
      Class.new do
        include Commands::Dsl
      end
    end
    it 'fails with exception' do
      expect { cmd_class.execute :anything }.to raise_exception NotImplementedError
    end
  end

  context 'with default only' do
    let(:cmd_class) do
      Class.new do
        include Commands::Dsl
        def default(cmd, *rest)
          [cmd, *rest]
        end
      end
    end
    it 'calls default with single arg' do
      expect(cmd_class.execute :anything).to eq [:anything]
    end
    it 'calls default with all args' do
      expect(cmd_class.execute :a, :b, :c).to eq %i(a b c)
    end
  end

  context 'with subcommands as a block' do
    let(:cmd_class) do
      Class.new do
        include Commands::Dsl
        command :one do |*args|
          [:one, *args]
        end
        command :two do |*args|
          [:two, *args]
        end
      end
      it 'calls registered command with arguments' do
        expect(cmd_class.execute :one, :a, :b).to eq %i(one a b)
        expect(cmd_class.execute :two, :c, :d).to eq %i(two c d)
      end
    end
  end

  context 'with subcommands as a class' do
    let(:subcmd_class) do
      Class.new do
        include Commands::Dsl
        command :one do |*args|
          [:one, *args]
        end
        def default(cmd, *rest)
          [:default, cmd, *rest]
        end
      end
    end
    let(:subcmd_empty_class) do
      Class.new do
        include Commands::Dsl
      end
    end
    let(:cmd_class) do
      sub = subcmd_class
      sub_empty = subcmd_empty_class
      Class.new do
        include Commands::Dsl
        command :subcmd, sub
        command :subcmd_empty, sub_empty
      end
    end
    it 'calls subcommand class with defined command' do
      expect(cmd_class.execute :subcmd, :one, :a).to eq %i(one a)
    end
    it 'calls subcommand class with default handler' do
      expect(cmd_class.execute :subcmd, :sth, :a).to eq %i(default sth a)
    end
    it 'calls subcommand class with no default handler defined' do
      expect { cmd_class.execute :subcmd_empty, :sth }.to raise_exception NotImplementedError
    end
  end
end
