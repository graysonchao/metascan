require 'rspec'
require './lib/metascan'
require 'spec_helper'

describe Metascan::Scan do
  before :each do
    @client = Metascan::Client.new(API_KEY)
    @scan = Metascan::Scan.new("./spec/DKlol.png", @client)
  end

  describe "#run" do
    it "sets @data_id" do
      @scan.run
      @scan.data_id.should_not be(nil)
    end
  end
  
  describe "#clean?" do
    context "when scan_all_result_i is 0" do
      it "returns true" do
        @scan.results = { 
          "scan_results" => {
            "scan_all_result_i" => 0,
            "progress_percentage" => 100
          }
        }
        @scan.clean?.should eq(true)
      end
    end

    context "when scan_all_result_i is not 0" do
      it "returns false" do
        @scan.results = { 
          "scan_results" => {
            "scan_all_result_i" => 1,
            "progress_percentage" => 100
          }
        }
        @scan.clean?.should eq(false)
      end
    end
  end

  describe "#results" do
    # TODO: set up dependency injection to test whether the request is made
    context "poll: true" do
    end

    context "poll: false" do
      it "does not call retrieve_results" do
        @scan.should_not receive(:retrieve_results)
        @scan.results(poll: false)
      end
    end
  end

  describe "#retrieve_results" do
    it "returns a hash" do
      @scan.run
      @scan.retrieve_results.should be_a(Hash)
    end
  end

end
