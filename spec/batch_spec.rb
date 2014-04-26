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
        @batch.scans.should include ({ s.filename => s })
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
        switch_scan_dirt false
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
        switch_scan_dirt true
        s = Metascan::Scan.new("./spec/DKlol.png", @client)
        @batch.add s
        @batch.run
        @batch.clean?.should eq(false)
      end
    end
  end

  describe '#dirty' do
    context 'with no dirty scans' do
      it 'returns an empty list' do
        switch_scan_dirt false
        2.times do
          s = Metascan::Scan.new("./spec/DKlol.png", @client)
          @batch.add s
        end
        @batch.run
        @batch.dirty.length.should eq(0)
      end
    end

    context 'with a dirty scan' do
      it 'returns the dirty scan' do

        s = Metascan::Scan.new("./spec/DKlol.png", @client)
        @batch.add s

        @batch.run
        switch_scan_dirt true
        @batch.retrieve_results

        @batch.dirty.should include s
      end
    end
  end
end
