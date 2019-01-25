describe Ticker::Analyzer do
  let(:retriever) { double(stock_data: enumerator) }
  let(:enumerator) do
    [
      ['2018-01-01', 10, 15],
      ['2018-01-02', 15, 20],
      ['2018-01-03', 20, 25],
      ['2018-01-04', 26, 10],
      ['2018-01-05', 11, 30],
      ['2018-01-06', 32, 20]
    ].each
  end

  describe '#history' do
    subject { described_class.new(retriever).history }
    let(:first) { subject.first }
    let(:last) { subject.last }

    it { expect(subject).to be_kind_of(Array) }
    it { expect(first).to be_kind_of(Ticker::Analyzer::Result) }
    it { expect(first.day).to eq(Date.new(2018, 1, 1)) }
    it { expect(first.start_price).to eq(10) }
  end

  describe '#top_drawdowns' do
    subject { described_class.new(retriever).top_drawdowns }

    it { expect(subject).to be_kind_of(Array) }
    it { expect(subject.first).to be_kind_of(Ticker::Analyzer::Result) }
    it { expect(subject.size).to eq(2) }
    it { expect(subject).to all(be_negative) }
  end

  describe '#highest_drawdown' do
    subject { described_class.new(retriever).highest_drawdown }

    it { expect(subject).to be_kind_of(Ticker::Analyzer::Result) }
    it { expect(subject).to be_negative }
    it { expect(subject.day).to eq(Date.new(2018, 1, 4)) }
  end

  describe '#return' do
    subject { described_class.new(retriever).return }

    it { expect(subject).to be_kind_of(Ticker::Analyzer::Return) }
  end

  describe '#empty?' do
    subject { described_class.new(retriever).empty? }

    it { expect(subject).to be_falsey }

    context 'has no data' do
      let(:enumerator) { [].each }

      it { expect(subject).to be_truthy }
    end
  end
end
