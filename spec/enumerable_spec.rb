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
      expect(test_array_string.my_all? { |word| word.length >= 3}).to eq(true)
    end
    it 'Returns false if all numbers in an array are smaller than 2' do
      expect(test_array_numbers.my_all? { |i| i > 2 }).to eql(false)
    end
    it 'Return false if all numbers of range are smaller than 5' do
      expect(test_range.my_all? { |i| i < 5 }).to eq(true)
    end
    it 'Return false if one of the items of the array is false or nill' do
      expect(test_array_bool.my_all?).to eq(false)
    end
  end

  describe '#my_any?' do
    it 'Return true if one of the items of the array is true' do
      expect(test_array_bool.my_any?).to eq(true)
    end
    it 'Returns false if no value is given' do
      expect([].my_any?).to eq(false)
    end
    it 'Return true if any item of the array is equal to argument' do
      expect(test_array_numbers.my_any?(11)).to eq(true)
    end
    it 'Returns true if all items length in an array is bigger or equal than 4' do
      expect(test_array_string.my_any? { |word| word.length >= 4} ).to eq(true)
    end
  end

  describe '#my_none?' do
    it 'Returns false if none of the items returns false in iven test' do
      expect([1, 3.14, 42].my_none?(Float)).to eq(false)
    end
    it 'Return true if all items in the array are a string' do
      expect(test_array_numbers.my_none?(String)).to eql(true)
    end
    it 'Returns false in none of the items of the range plus two are bigger than 5' do
      expect(test_range.my_none? { |i| (i + 2) > 5 }).to eq(false)
    end
    it 'Returns true if none of the items is equal to argument' do
      expect(test_array_string.my_none?('bee')).to eq(true)
    end
    it 'Return false if one if the items of the array is false or nill' do
      expect(test_array_bool.my_none?).to eq(false)
    end
  end

  describe '#my_count' do
    it 'Return the number of items that return true for a given test' do
      expect(test_array_numbers.my_count { |x| x > 10 }).to eq(2)
    end
    it 'Returns the number of items that are equal to the argument' do
      expect(test_array_string.my_count('ant')).to eq(1)
    end
  end

  describe '#my_map' do
    it 'Returns an array of results of running a block with each item' do
      expect(test_range.my_map { |i| i * i }).to eq([1, 4, 9, 16])
    end
    it 'Returns an array of results of running a block with each item 2' do
      expect(test_array_numbers.my_map { |i| i * 2 }).to eq([22, 4, 6, 112])
    end
    it 'Returns an array of the length of each item in the array' do
      expect(test_array_string.my_map { |i| i.length }).to eq([3, 4, 3])
    end
    it 'Expect enumerator when no block is given' do
      expect(test_array_numbers.my_map).to be_kind_of(Enumerator)
    end
  end

  describe '#my_inject' do
    it 'Combines all items by applying binary operation' do
      expect(test_range.inject { |sum, n| sum + n }).to eql(10)
    end
    it 'Combines all items by the argument operator' do
      expect(test_array_numbers.inject(:*)).to eql(3696)
    end
    it 'Combines all items including the number of the argumetn applying the argument operator' do
      expect(test_array_numbers.inject(2, :+)).to eql(74)
    end
  end

end