require 'rails_helper'

describe Rcon::Client do
  before(:all) do
    @udp_server = SimpleUdpEchoServer.new
    @udp_server.run
  end

  after(:each) do
    # Clear pending, not received responses
    nil until client.last_response(128, wait: false).nil?
  end

  after(:all) do
    @udp_server.stop
  end

  let(:password) { 'pwd' }
  let(:server) { @udp_server }
  let(:client) { described_class.new 'localhost', server.port, password }
  let(:challenge_cmd) { "\xff\xff\xff\xffchallenge rcon" }
  def response(wait = false)
    client.last_response 1024, wait: wait
  end

  it { expect(client.send_cmd 'test').to be_truthy }

  context 'sends challenge before first command' do
    before { client.send_cmd 'foo' }
    let(:resp_command_prefix) { "\xff\xff\xff\xffrcon #{client.challenge} #{password}" }
    it { expect(client.challenge).to eq server.challenge }
    it do
      expect(response).to be_same_as "#{resp_command_prefix} foo"
    end

    context 'and not after second command' do
      before do
        # clear response after outer before. Give the server some time to respond.
        response(true)
        # send second command
        client.send_cmd 'boo'
      end
      it { expect(response).to be_same_as "#{resp_command_prefix} boo" }
    end
  end

end
