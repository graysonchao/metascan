require 'rspec'
require './lib/metascan'
require 'spec_helper'

describe Metascan::Client do
  before :each do
    @client = Metascan::Client.new(API_KEY)
  end

  describe "#scan_file" do
    it "returns a Metascan::Scan object" do
      @client.scan_file('./spec/DKlol.png').should be_a(Metascan::Scan)
    end
  end

  describe "#api_key" do
    it "returns the client's API key" do
      @client.api_key.should eq(API_KEY)
    end
  end

  describe "#hydra" do
    it "does not reinstantiate the hydra" do
      @client.hydra.should equal(@client.hydra)
    end

    it "returns a Typhoeus::Hydra object" do
      @client.hydra.should be_a(Typhoeus::Hydra)
    end
  end
end
