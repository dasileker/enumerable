# rubocop: disable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Lint/InterpolationCheck, Style/FrozenStringLiteralComment, Metrics/AbcSize

# !/usr/bin/env ruby
# frozen_string_literal: true

# This module contains an implementation of some of the methods found in the
# Enumerable module
module Enumerable
  def my_each
    # An enumerator is returned if no block is given
    return to_enum unless block_given?

    i = 0
    self_class = self.class
    array = if self_class == Array
              self
            elsif self_class == Range
              to_a
            else
              flatten
            end
    while i < array.length
      if self_class == Hash
        yield(array[i], array[i + 1])
        i += 2
      else
        yield(array[i])
        i += 1
      end
    end
  end

  def my_each_with_index
    # If no block is given, an enumerator is returned instead.
    return to_enum unless block_given?

    array = self.class == Array ? self : to_a
    i = 0
    while i < length
      yield(array[i], i)
      i += 1
    end
  end

  def my_select
    # If no block is given, an Enumerator is returned instead.
    return to_enum unless block_given?

    enumerable = self.class == Array ? [] : {}
    if enumerable.class == Array
      my_each do |n|
        enumerable.push(n) if yield(n)
      end
    else
      my_each do |key, value|
        enumerable[key] = value if yield(key, value)
      end
    end
    enumerable
  end

  def my_all?(parameter = nil)
    return true if (self.class == Array && count.zero?) || (!block_given? &&
        parameter.nil? && !include?(nil))
    return false unless block_given? || !parameter.nil?

    boolean = true
    if self.class == Array
      my_each do |n|
        if block_given?
          boolean = false unless yield(n)
        elsif parameter.class == Regexp
          boolean = false unless n.match(parameter)
        elsif parameter.class <= Numeric
          boolean = false unless n == parameter
        else
          boolean = false unless n.class <= parameter
        end
        break unless boolean
      end
    else
      my_each do |key, value|
        boolean = false unless yield(key, value)
      end
    end
    boolean
  end

  def my_any?(argument = nil)
    return false if (self.class == Array && count.zero?) || (!block_given? &&
        argument.nil? && !include?(true))
    return true unless block_given? || !argument.nil?

    boolean = false
    if self.class == Array
      my_each do |n|
        if block_given?
          boolean = true if yield(n)
        elsif argument.class == Regexp
          boolean = true if n.match(argument)
        elsif argument.class == String
          boolean = true if n == argument
        elsif n.class <= argument
          boolean = true
        end
      end
    else
      my_each do |key, value|
        boolean = true if yield(key, value)
      end
    end

    boolean
  end

  def my_none?(argument = nil)
    return true if count.zero? || (self[0].nil? && !include?(true))
    return false unless block_given? || !argument.nil?

    boolean = true
    if self.class == Array
      my_each do |n|
        if block_given?
          boolean = false if yield(n)
        elsif argument.class == Regexp
          boolean = false if n.match(argument)
        elsif argument.class <= Numeric
          boolean = false if n == argument
        elsif n.class <= argument
          boolean = false
        end
        break unless boolean
      end
    else
      my_each do |key, value|
        boolean = false if yield(key, value)
        break unless boolean
      end
    end
    boolean
  end

  def my_count(element = nil)
    counter = 0
    if block_given?
      if self.class == Array
        my_each do |n|
          counter += 1 if yield(n)
        end
      else
        my_each do |key, value|
          counter += 1 if yield(key, value)
        end
      end
    elsif !block_given? && element.nil?
      return length
    elsif !block_given? && !element.nil?
      my_each do |n|
        counter += 1 if n == element
      end
    end
    counter
  end

  def my_map
    # If no block is given, an enumerator is returned instead.
    return to_enum unless block_given?

    array = []
    if self.class == Array
      my_each do |n|
        array << yield(n)
      end
    else
      my_each do |key, value|
        array << yield(key, value)
      end
    end
    array
  end

  def my_inject(symbol = nil, initial_value = nil)
    if symbol.class != Symbol
      temp = symbol
      symbol = initial_value
      initial_value = temp
    end
    value_provided = false
    value_provided = true unless initial_value.nil?
    memo = initial_value || first
    case symbol
    when :+
      if !value_provided
        drop(1).my_each do |n|
          memo += n
        end
      else
        my_each do |n|
          memo += n
        end
      end
    when :*
      if !value_provided
        drop(1).my_each do |n|
          memo *= n
        end
      else
        my_each do |n|
          memo *= n
        end
      end
    when :/
      if !value_provided
        drop(1).my_each do |n|
          memo /= n
        end
      else
        my_each do |n|
          memo /= n
        end
      end
    when :-
      if !value_provided
        drop(1).my_each do |n|
          memo -= n
        end
      else
        my_each do |n|
          memo -= n
        end
      end
    when :**
      if !value_provided
        drop(1).my_each do |n|
          memo **= n
        end
      else
        my_each do |n|
          memo **= n
        end
      end
    else
      if !value_provided
        drop(1).my_each do |n|
          memo = yield(memo, n)
        end
      else
        my_each do |n|
          memo = yield(memo, n)
        end
      end
    end
    memo
  end
end

# Code used to test the methods compared with the original ones
puts "\nBelow you will find the results of applying the original method vs. the
custom implementation."
puts
array = [1, 2, 3]
hash = { a: 1, b: 2, c: 3 }
words = %w[dog door rod blade]
false_array = [nil, false, nil, false]
long_array = [8, 4, 5, 0, 0, 1, 2, 3, 8, 3, 4, 6, 2, 1, 0, 2, 8, 8, 5, 0, 4, 8,
              4, 8, 1, 2, 6, 0, 0, 6, 8, 7, 1, 0, 5, 7, 5, 8, 5, 6, 3, 4, 1, 3,
              5, 4, 5, 8, 8, 5, 3, 1, 2, 7, 0, 2, 0, 0, 3, 1, 0, 8, 3, 7, 2, 3,
              6, 1, 0, 4, 0, 3, 7, 6, 4, 6, 3, 1, 0, 5, 4, 4, 7, 3, 3, 2, 2, 4,
              1, 2, 5, 4, 0, 3, 3, 3, 0, 1, 4, 2]
true_array = [1, true, 'hi', []]

puts 'We will use the following objects to check the outputs:'
puts
puts 'array = [1, 2, 3]'
puts 'hash = {a: 1, b: 2, c: 3}'
puts 'words = %w[dog door rod blade]'
puts 'false_array = [nil, false, nil, false]'
puts 'long_array = [8, 4, 5, 0, 0, 1, 2, 3, 8, 3, 4, 6, 2, 1, 0, 2, 8, 8, 5,
0, 4, 8, 4, 8, 1, 2, 6, 0, 0, 6, 8, 7, 1, 0, 5, 7, 5, 8, 5, 6, 3, 4, 1, 3, 5,
 4, 5, 8, 8, 5, 3, 1, 2, 7, 0, 2, 0, 0, 3, 1, 0, 8, 3, 7, 2, 3, 6, 1, 0, 4,
0, 3, 7, 6, 4, 6, 3, 1, 0, 5, 4, 4, 7, 3, 3, 2, 2, 4, 1, 2, 5, 4, 0, 3, 3, 3,
 0, 1, 4, 2]'
puts 'true_array = [1, true, \'hi\', []]'
puts

# "Tests"  for #my_each
puts '-' * 80
puts 'each vs. my_each'
puts '-' * 80
puts
puts 'array.each output: ' + array.each.to_s
puts 'array.my_each output: ' + array.my_each.to_s
puts
print 'array.each { |n| p n } output: '
array.each { |n| print n }
puts
print 'array.my_each { |n| n } output: '
array.my_each { |n| print n }
puts
puts
puts 'hash.each { |key, value| puts "Key: #{key}, Value: #{value}" } output:
'
hash.each { |key, value| puts "Key: #{key}, Value: #{value}" }
puts 'hash.my_each { |key, value| puts "Key: #{key}, Value: #{value}" } output:
'
hash.my_each { |key, value| puts "Key: #{key}, Value: #{value}" }
puts

# "Tests" for #my_each_with_index
puts '-' * 80
puts 'each_with_index vs. my_each_with_index'
puts '-' * 80
puts

puts 'array.each_with_index output: ' + array.each_with_index.to_s
puts 'array.my_each_with_index output: ' + array.my_each_with_index.to_s
puts
puts 'array.each_with_index do |element, index|
  puts "Index: #{index}, Element:#{element}"
end output: '
array.each_with_index do |element, index|
  puts "Index: #{index}, Element:#{element}"
end
puts 'array.my_each_with_index do |element, index|
  puts "Index: #{index}, Element:#{element}"
end output: '
array.my_each_with_index do |element, index|
  puts "Index: #{index}, Element:#{element}"
end
puts
puts 'hash.each_with_index do |element, index|
  puts "Index: #{index}, Element: #{element}"
end output: '
hash.each_with_index do |element, index|
  puts "Index: #{index}, Element: #{element}"
end
puts 'hash.my_each_with_index do |element, index|
  puts "Index: #{index}, Element: #{element}"
end output: '
hash.my_each_with_index do |element, index|
  puts "Index: #{index}, Element: #{element}"
end
puts

# select vs. my_select
puts '-' * 80
puts 'select vs. my_select'
puts '-' * 80
puts
puts 'array.select output: ' + array.select.to_s
puts 'array.my_select output: ' + array.my_select.to_s
puts
puts 'array.select(&:odd?) output: '
p array.select(&:odd?)
puts 'array.my_select(&:odd?) output: '
p array.my_select(&:odd?)
puts
puts 'hash.select { |key, value| value == 2 } output: '
p(hash.select { |_key, value| value == 2 })
puts 'hash.my_select { |key, value| value == 2 } output: '
p(hash.my_select { |_key, value| value == 2 })
puts

#  all? vs. my_all?
puts '-' * 80
puts 'all? vs. my_all?'
puts '-' * 80
puts
puts '%w[ant bear cat].all? { |word| word.length >= 3 } output: '
p(%w[ant bear cat].all? { |word| word.length >= 3 })
puts '%w[ant bear cat].my_all? { |word| word.length >= 3 } output: '
p(%w[ant bear cat].my_all? { |word| word.length >= 3 })
puts '%w[ant bear cat].all? { |word| word.length >= 4 } output: '
p(%w[ant bear cat].all? { |word| word.length >= 4 })
puts '%w[ant bear cat].my_all? { |word| word.length >= 4 } output: '
p(%w[ant bear cat].my_all? { |word| word.length >= 4 })
puts '%w[ant bear cat].all?(/t/) output: '
p(%w[ant bear cat].all?(/t/))
puts '%w[ant bear cat].my_all?(/t/) output: '
p(%w[ant bear cat].my_all?(/t/))
puts '[1, 2i, 3.14].all?(Numeric) output: '
p([1, 2i, 3.14].all?(Numeric))
puts '[1, 2i, 3.14].my_all?(Numeric) output: '
p([1, 2i, 3.14].my_all?(Numeric))
puts '[nil, true, 99].all? output: '
p([nil, true, 99].all?)
puts '[nil, true, 99].my_all? output: '
p([nil, true, 99].my_all?)
puts '[].all? output: '
p([].all?)
puts '[].my_all? output: '
p([].my_all?)
puts 'long_array.all?(3) output: '
p(long_array.all?(3))
puts 'long_array.my_all?(3) output: '
p(long_array.my_all?(3))
puts 'true_array.all? output: '
p(true_array.all?)
puts 'true_array.my_all? output: '
p(true_array.my_all?)
puts

# any? vs. my_any?
puts '-' * 80
puts 'any? vs. my_any?'
puts '-' * 80
puts
puts '%w[ant bear cat].any? { |word| word.length >= 3 } output: '
p(%w[ant bear cat].any? { |word| word.length >= 3 })
puts '%w[ant bear cat].my_any? { |word| word.length >= 3 } output: '
p(%w[ant bear cat].my_any? { |word| word.length >= 3 })
puts '%w[ant bear cat].any? { |word| word.length >= 4 } output: '
p(%w[ant bear cat].any? { |word| word.length >= 4 })
puts '%w[ant bear cat].my_any? { |word| word.length >= 4 } output: '
p(%w[ant bear cat].my_any? { |word| word.length >= 4 })
puts '%w[ant bear cat].any?(/d/) output: '
p(%w[ant bear cat].any?(/d/))
puts '%w[ant bear cat].my_any?(/d/) output: '
p(%w[ant bear cat].my_any?(/d/))
puts '[nil, true, 99].any?(Integer) output: '
p([nil, true, 99].any?(Integer))
puts '[nil, true, 99].my_any?(Integer) output: '
p([nil, true, 99].my_any?(Integer))
puts '[nil, true, 99].any? output: '
p([nil, true, 99].any?)
puts '[nil, true, 99].my_any? output: '
p([nil, true, 99].my_any?)
puts '[].any? output: '
p([].any?)
puts '[].my_any? output: '
p([].my_any?)
puts "words.any?(\'cat\') output: "
p(words.any?('cat'))
puts "words.my_any?(\'cat\') output: "
p(words.my_any?('cat'))
puts 'false_array.any? output: '
p(false_array.any?)
puts 'false_array.my_any? output: '
p(false_array.my_any?)
puts

# none? vs. my_none?
puts '-' * 80
puts 'none? vs. my_none?'
puts '-' * 80
puts
puts '%w[ant bear cat].none? { |word| word.length == 5} output: '
p(%w[ant bear cat].none? { |word| word.length == 5 })
puts '%w[ant bear cat].my_none? { |word| word.length == 5} output: '
p(%w[ant bear cat].my_none? { |word| word.length == 5 })
puts '%w[ant bear cat].none? { |word| word.length >= 4 } output: '
p(%w[ant bear cat].none? { |word| word.length >= 4 })
puts '%w[ant bear cat].my_none? { |word| word.length >= 4 } output: '
p(%w[ant bear cat].my_none? { |word| word.length >= 4 })
puts '%w[ant bear cat].none?(/d/)) output: '
p(%w[ant bear cat].none?(/d/))
puts '%w[ant bear cat].my_none?(/d/) output: '
p(%w[ant bear cat].my_none?(/d/))
puts '([1, 3.14, 42].none?(Float)) output: '
p([1, 3.14, 42].none?(Float))
puts '([1, 3.14, 42].my_none?(Float)) output: '
p([1, 3.14, 42].my_none?(Float))
puts '[].none? output: '
p([].none?)
puts '[].my_none? output: '
p([].my_none?)
puts '[nil].none? output: '
p([nil].none?)
puts '[nil].my_none? output: '
p([nil].my_none?)
puts '[nil, false].none? output: '
p([nil, false].none?)
puts '[nil, false].my_none? output: '
p([nil, false].my_none?)
puts '[nil, false, true].none? output: '
p([nil, false, true].none?)
puts '[nil, false, true].my_none? output: '
p([nil, false, true].my_none?)
puts 'words.none?(5) output: '
p(words.none?(5))
puts 'words.my_none?(5) output: '
p(words.my_none?(5))
puts

# count? vs. my_count?
puts '-' * 80
puts 'count? vs. my_count?'
puts '-' * 80
puts
puts 'array.count output: ' + array.count.to_s
puts 'array.count output: ' + array.my_count.to_s
puts
puts 'array.count(1) output: '
p array.count(1)
puts 'array.my_count(1) output: '
p array.my_count(1)
puts
puts 'array.count { |n| n > 1 } output: '
p(array.count { |n| n > 1 })
puts 'array.my_count { |n| n > 1 }'
p(array.my_count { |n| n > 1 })
puts
puts 'hash.count { |key, value| value.odd? } output: '
p(hash.count { |_key, value| value.odd? })
puts 'hash.my_count { |key, value| value.odd? } output: '
p(hash.my_count { |_key, value| value.odd? })

# map vs. my_map
puts '-' * 80
puts 'map vs. my_map'
puts '-' * 80
puts
puts 'array.map output: ' + array.map.to_s
puts 'array.my_map output: ' + array.my_map.to_s
puts
puts 'array.map { |n| n * 10 } output: '
p(array.map { |n| n * 10 })
puts 'array.my_map { |n| n * 10 } output: '
p(array.my_map { |n| n * 10 })
puts
puts 'hash.map { |key, value| [key, value] } output: '
p(hash.map { |key, value| [key, value] })
puts 'hash.my_map { |key, value| [key, value] } output: '
p(hash.my_map { |key, value| [key, value] })
puts

# inject vs. my_inject
puts '-' * 80
puts 'inject vs. my_inject'
puts '-' * 80
puts
puts '(5..10).inject { |sum, n| sum + n } output: '
p((5..10).inject { |sum, n| sum + n })
puts '(5..10).my_inject { |sum, n| sum + n } output: '
p((5..10).my_inject { |sum, n| sum + n })
puts '(5..10).inject(1) { |product, n| product * n } output: '
p((5..10).inject(1) { |product, n| product * n })
puts '(5..10).my_inject(1) { |product, n| product * n } output: '
p((5..10).my_inject(1) { |product, n| product * n })
puts 'longest = %w[cat sheep bear].inject do |memo, word|
  memo.length > word.length ? memo : word
end output: '
longest = %w[cat sheep bear].inject do |memo, word|
  memo.length > word.length ? memo : word
end
p longest
puts 'longest = %w[cat sheep bear].my_inject do |memo, word|
  memo.length > word.length ? memo : word
end output: '
longest = %w[cat sheep bear].my_inject do |memo, word|
  memo.length > word.length ? memo : word
end
p longest
puts

# multiply_els method created to test my_inject method
puts '-' * 80
puts 'multiply_els method'
puts '-' * 80
puts
puts 'def multiply_els(array)
  array.my_inject do |memo, n|
    memo * n
  end
end'

def multiply_els(array)
  array.my_inject do |memo, n|
    memo * n
  end
end

puts
puts 'multiply_els([2, 4, 5]) output: ' + multiply_els([2, 4, 5]).to_s
puts

# Proc to test the implementation of the my_map method
puts '-' * 80
puts 'Proc to test the implementation of my_map method'
puts '-' * 80
puts
puts 'test_proc = proc { |n| n * 7 }'
test_proc = proc { |n| n * 7 }
puts 'array.map { |n| n * 7 } output: ' + array.map { |n| n * 7 }.to_s
puts 'array.my_map(&test_proc) output: ' + array.my_map(&test_proc).to_s
puts
puts

# rubocop: enable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Lint/InterpolationCheck, Style/FrozenStringLiteralComment, Metrics/AbcSize
