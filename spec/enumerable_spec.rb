# spec/calculator_spec.rb
require '../bin/enumerable_methods.rb'

describe Enumerable do
  let(:test_array_numbers) { [11, 2, 3, 56] }
  let(:test_array_string) { %w[ant bear cat] }
  let(:test_range) { (1..4) }
  let(:test_array_bool) { [true, true, false, nil] }

  describe '#my_each' do
    it 'Iterates over each item of an array' do
      expect(test_array_numbers.my_each { |x| x }).to eq(test_array_numbers.each { |x| x })
    end
    it 'Expect enumerator when no block is given' do
      expect(test_array_numbers.my_each).to be_kind_of(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    it 'Iterates over each item and returns item with its index' do
      expect(test_array_numbers.my_each_with_index { |n, i| [n, i] }).to eq(test_array_numbers.my_each_with_index { |n, i| [n, i] })
    end
    it 'Expect enumerator when no block is given' do
      expect(test_array_numbers.my_each_with_index).to be_kind_of(Enumerator)
    end
  end

  describe '#my_select' do 
    it 'Return an array of selected items if they are even' do
      expect(test_array_numbers.my_select(&:even?)).to eq([2, 56])
    end
    it 'Return an array of selected items if they are odd' do
      expect(test_range.my_select(&:odd?)).to eq([1, 3])
    end
    it 'Expect enumerator when no block is given' do
      expect(test_array_numbers.my_select).to be_kind_of(Enumerator)
    end
  end

  describe '#my_all?' do 
    it 'Returns true if all items have a lenght bigger than 3' do
      expect(test_array_string.my_all? { |word| words.lenght })
    end
end