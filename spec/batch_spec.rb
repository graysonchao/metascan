require 'rspec'
require 'spec_helper'
require_relative '../metascan'

describe Metascan::Batch do
  before :all do
    @client = Metascan::Client.new("apikey")
  end

  before :each do
    @batch = Metascan::Batch.new(@client.hydra)
  end

  describe '#add' do
    context 'with valid scan' do
      it 'adds the scan to my scans hash' do
        s = Metascan::Scan.new("./spec/DKlol.png", @client)
        @batch.add s
        @batch.scans.should have_key("./spec/DKlol.png")
      end
    end

    context 'without valid scan' do
      it 'raises error' do
        expect {
          @batch.add "Not a Metascan::Scan object"
        }.to raise_error
      end
    end
  end

  describe '#clean?' do
    context 'when all scans are clean' do
      it 'returns true' do
        2.times do
          s = Metascan::Scan.new("./spec/DKlol.png", @client)
          @batch.add s
        end
        @batch.run
        @batch.clean?.should eq(true)
      end
    end

    context 'when some scans are not clean' do
      it 'returns false' do
        dirty_response = JSON.dump({
          "file_id" => "sample_file_id",
          "scan_results" => {
            "scan_all_result_i" => 1
          }
        })
        stub_request(:get, "#{Metascan::PATHS[:results_by_data_id]}sample_data_id").
          to_return(status: 200, body: dirty_response, headers: {})
        2.times do
          s = Metascan::Scan.new("./spec/DKlol.png", @client)
          @batch.add s
        end
        @batch.run
        @batch.clean?.should eq(false)
      end
    end
  end
end
