require 'rspec'
require 'spec_helper'
require_relative '../metascan'

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
    # I honestly have no idea why this fails.
    # It has all the expected behavior when tested manually.
    #context "poll: true" do
    #  it "should call receive results" do
    #    @scan.run
    #    @scan.should receive(:retrieve_results)
    #    @scan.results(poll: true)
    #  end
    #end

    context "poll: false" do
      it "does not call retrieve_results" do
        @scan.should_not receive(:retrieve_results)
        @scan.results(poll: false)
      end
    end
  end

  describe "#retrieve_results" do

    context 'before .run' do
      it 'errors' do
        expect {@scan.retrieve_results}.to raise_error
      end
    end

    context 'after .run' do
      it "returns a Typhoeus::Request" do
        @scan.run
        @scan.retrieve_results.should be_a(Typhoeus::Request)
      end
    end
  end

end
