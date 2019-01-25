describe Ticker::Analyzer::Result do
  let(:date) { '2018-01-01' }
  let(:start) { 10 }
  let(:fin) { 12 }

  describe '#negative?' do
    subject { described_class.new(date, start, fin).negative? }

    it { expect(subject).to be_falsey }

    context 'with downfall' do
      let(:fin) { 8 }

      it { expect(subject).to be_truthy }
    end
  end

  describe '#day' do
    subject { described_class.new(date, start, fin).day }

    it { expect(subject).to eq(Date.new(2018, 1, 1)) }

    context 'invalid form' do
      let(:date) { 'test' }

      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end

  describe 'comparison operator' do
    let(:one) { described_class.new('2018-01-01', 10, 12) }
    let(:other) { described_class.new('2018-02-03', 13, 15) }
    subject { (one <=> other) }

    it { expect(subject).to eq(1) }

    context 'reversed' do
      let(:one) { described_class.new('2018-02-03', 13, 15) }
      let(:other) { described_class.new('2018-01-01', 10, 12) }

      it { expect(subject).to eq(-1) }
    end
  end

  describe '#to_s' do
    subject { described_class.new(date, start, fin).to_s }

    it { expect(subject).to eq("#{Date.parse(date)}: Closed at #{fin.to_f} (#{start.to_f} ~ #{fin.to_f})")}
  end
end
