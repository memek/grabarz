require_relative '../rails_helper'

describe CsCommand do
  context 'executed on instance' do
    after { subject.execute :some, :args }
    subject { described_class.new }
    it 'executes default handler' do
      is_expected.to receive(:default).with(:some, :args)
    end
  end
end
