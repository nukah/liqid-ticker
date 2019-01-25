describe Ticker::Analyzer::Return do
  describe '#to_s' do
    subject { described_class.new(start_result, end_result).to_s }

    let(:start_result) { Ticker::Analyzer::Result.new('2018-01-01', 10, 15) }
    let(:end_result) { Ticker::Analyzer::Result.new('2018-01-03', 16, 12) }

    it { expect(subject).to eq('Return: 2.0 [20.0%] (10.0 on 2018-01-01 -> 12.0 on 2018-01-03)') }
  end
end
