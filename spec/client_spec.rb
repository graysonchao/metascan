require 'rspec'
require './lib/metascan'

API_KEY = "b1aeef55cd9c4b659f8d6c09847031c6"

describe Metascan::Client do
  describe "#scan_file" do
    it "returns a Metascan::Scan object" do
      m = Metascan::Client.new(API_KEY)
      m.scan_file('./spec/DKlol.png').should be_a(Metascan::Scan)
    end
  end
end
