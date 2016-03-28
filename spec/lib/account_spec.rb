require 'spec_helper'

describe Totango::Client do
  it 'can have a new instance without paramaters' do
    t=Totango::Client.new(sid: 'test')
    expect(t).to be_a(Totango::Client)
  end

  it 'can have a new instance with paramaters' do
    t=Totango::Client.new({:sid => 'test', account: {id: "test"}})
    expect(t.account.id).to eql("test")
  end

  it 'a new instance can be created with a custom attribute' do
    t=Totango::Client.new({:sid => 'test', account: {id: "test", custom: "test"}})
    expect(t.account.custom).to eql("test")
  end

  it 'validates account id before saving' do
    t=Totango::Client.new({:sid=>'test'})
    expect{t.save}.to raise_error(Totango::Error::InvalidEvent)
  end

  it 'validates user id if user action' do
    t=Totango::Client.new({sid: 'test',
      account: {id: 100},
      user: {test: "Joe"}
      })
    expect{t.save}.to raise_error(Totango::Error::InvalidEvent)
  end

  it 'has events saved with #create' do
    expect{Totango::Client.create(
      {sid: "test",
       account: {id: 100}
      }
      )}.not_to raise_error
  end

  it 'calls on_error proc when timeout occurs' do
    Totango.timeout=1
    Totango.on_error do
      raise "Timeout"
    end
    stub_request(:get, /sdr.totango.com\/pixel.gif/).to_return { sleep 10; return { status: 200, body: "Stubbed"}}
    expect{Totango::Client.create({sid: 'test', account: {id: 0}})}.to raise_error("Timeout")
  end

  it 'can load SID from config file' do
    pending("No ./config/totango.yml file. Skipping test.") unless File.exist? "./config/totango.yml"
    expected_sid = YAML.load_file("./config/totango.yml")['sid']
    expect(Totango::Client.new.sid).to eql(expected_sid)
  end
end
