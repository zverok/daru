describe Daru::Core::RowProxy do
  xcontext 'interface' do
    subject(:proxy_methods) { described_class.instance_methods - Object.methods }
    let(:vector_methods) { Daru::Vector.instance_methods - Object.methods }
    let(:skip_methods) { [] }
    it { is_expected.to match_array vector_methods }
  end

  let(:data_frame) { Daru::DataFrame.new({
    a: [1,2,3],
    b: [4,5,6],
    c: [7,8,9],
    }, index: [:x, :y, :z]
  )}

  subject(:proxy) { described_class.new(data_frame) }

  context '#initialize' do
    its(:index) { is_expected.to eq data_frame.vectors }
  end

  context 'Index shifting' do
    context 'default index' do
      its(:current_pos) { should == 0 }
      its(:to_a) { should == [1, 4, 7] }
    end

    context 'next index' do
      before { proxy.current_pos = 1 }
      its(:current_pos) { should == 1 }
      its(:to_a) { should == [2, 5, 8] }
    end

    xit 'raises on non-existent index' do
      expect { proxy.current_pos = :w }.to raise_error IndexError
    end
  end

  context '#[]' do
    its([:a]) { is_expected.to eq 1 }
    context 'after shift' do
      before { proxy.current_pos = 1 }
      its([:a]) { is_expected.to eq 2 }
    end
  end

  context '#to_h' do
    its(:to_h) { is_expected.to eq({a: 1, b: 4, c: 7}) }
  end

  context '#map' do
    it 'should be mappable!' do
      expect(proxy.map(&:to_s)).to eq %w[1 4 7]
    end
  end
end
