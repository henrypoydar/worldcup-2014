require 'spec_helper'

describe WorldCup::Results do

  let(:wcr) { WorldCup::Results.new({}) }
  let(:api_response) {
    File.open(File.expand_path(File.dirname(__FILE__)) + '/../fixtures/sfg-api-20140618.json', "rb").read }

  describe "#render" do

    context "today's matches in progress (default)" do
      it "shows only today's matches"
    end

    context "yesterday's results selected" do
      it "shows only yesterday's results"
    end

    context "tomorrow's matches selected" do
      it "shows only tomorrow's results"
    end

    context "all matches selected" do
      it "shows all matches with results for the ones played"
    end

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
      wcr.raw_response.should =~ /^\[\{\"match_number\":1,\"location\":\"Arena Corinthians\"/
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
