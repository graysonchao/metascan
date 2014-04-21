require 'rspec'
require 'spec_helper'
require_relative '../metascan'

describe Metascan::Batch do
  before :all do
    @client = Metascan::Client.new(API_KEY)
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
      it 'does nothing' do
        @batch.add "Not a Metascan::Scan object"
        @batch.scans.length.should eq(0)
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
      end
    end
  end
end
