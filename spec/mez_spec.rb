require_relative '../lib/mez'

describe Mez do
  it 'makes human-readable numbers' do
    expect(Mez.humanise(450)).to eq('450')
    expect(Mez.humanise(4500)).to eq('4,500')
    expect(Mez.humanise(-4500)).to eq('-4,500')
    expect(Mez.humanise(-40_500)).to eq('-40,500')
    expect(Mez.humanise(100_000)).to eq('100,000')
    expect(Mez.humanise(-4_201_241_000)).to eq('-4,201,241,000')
    expect(Mez.humanise(4_201_241_000)).to eq('4,201,241,000')
    expect(Mez.humanise(24_201_241_000)).to eq('24,201,241,000')
    expect(Mez.humanise(48_150_100_000_000)).to eq('48,150,100,000,000')
    expect(Mez.humanise(480_150_100_000_000)).to eq('480,150,100,000,000')
    expect(Mez.humanise(-480_150_100_000_000)).to eq('-480,150,100,000,000')
  end

  it 'formats the change figures consistently' do
    expect(Mez.difference_report(0)).to eq('')
    expect(Mez.difference_report(1_000_000)).to eq('+1')
    expect(Mez.difference_report(5_000_000)).to eq('+5')
    expect(Mez.difference_report(500_000_000)).to eq('+500')
    expect(Mez.difference_report(8_500_000_000)).to eq('+8,500')
    expect(Mez.difference_report(4_188_500_000_000)).to eq('+4,188,500')
    expect(Mez.difference_report(-4_188_500_000_000)).to eq('-4,188,500')
    expect(Mez.difference_report(-1_000_000)).to eq('-1')
  end

  it 'gives numbers their correct prefix' do
    expect(Mez.prefix(5)).to eq('+')
    expect(Mez.prefix(0)).to eq('+')
    expect(Mez.prefix(-8)).to eq('-')
  end
end
