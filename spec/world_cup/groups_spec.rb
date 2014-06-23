require 'spec_helper'

describe WorldCup::Groups do

  let(:wcr) { WorldCup::Groups.new({}) }
  let(:api_response) {
    File.open(File.expand_path(File.dirname(__FILE__)) + '/../fixtures/groups.json', "rb").read }

  describe "#render" do

    context "problems" do

      it "displays an error message if the API can't be reached" do
        wcr.should_receive(:puts).with(/^Sorry/)
        wcr.should_receive(:open).and_raise(StandardError)
        wcr.render
      end

      it "displays an error message if the API can't be reached" do
        wcr.should_receive(:puts).with(/^Sorry/)
        JSON.should_receive(:parse).and_raise(JSON::JSONError)
        wcr.stub_chain(:open, :read) { api_response }
        wcr.render
      end

    end

  end

  describe "#convert" do

    it "converts the raw JSON response to an array of hashes" do
      wcr.stub_chain(:open, :read) { api_response }
      wcr.send(:retrieve)
      wcr.send(:convert)
      wcr.response.is_a?(Array).should eq true
    end
  end

  describe "#retrieve" do

    it "retrieves a JSON response from the SFG API" do
      wcr.stub_chain(:open, :read) { api_response }
      wcr.send(:retrieve)
      wcr.raw_response.should =~ /^\[\{\"country\":"Mexico"/
    end

    it "returns true" do
      wcr.stub_chain(:open, :read) { api_response }
      wcr.send(:retrieve).should eq true
    end

    context "with connectivity problems" do

      it "returns false" do
        wcr.should_receive(:open).and_raise(StandardError)
        wcr.stub(:puts)
        wcr.send(:retrieve).should eq false
      end
    end

  end

end
