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
end
