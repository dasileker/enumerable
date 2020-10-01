# bin/enumerable_methods.rb

module Enumerable
  def my_each
    return to_enum unless block_given?

    length.times { |n| yield(self[n]) }
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    new_array = []
    length.times { |n| yield(new_array.push(self[n], n)) }
    new_array
  end

  def my_select
    return to_enum unless block_given?

    new_array = []
    to_a.length.times { |n| new_array.push(self.to_a[n]) if yield(self.to_a[n]) }
    new_array
  end

  def my_all?(arg = nil)
    if arg.is_a?(Class)
      to_a.length.times { |n| return false unless to_a[n].is_a?(arg) }
    elsif arg.is_a?(String) || arg.is_a?(Integer)
      to_a.length.times { |n| return false unless to_a[n] == arg }
    elsif !arg.nil?
      to_a.length.times { |n| return false unless to_a[n].match(arg) }
    elsif !block_given?
      to_a.length.times { |n| return false if to_a[n] == false || to_a[n].nil? }
    else
      to_a.length.times { |n| return false unless yield(to_a[n]) }
    end
    true
  end

  def my_any?(arg = nil)
    if arg.is_a?(Class)
      to_a.length.times { |n| return true if to_a[n].is_a?(arg) }
    elsif arg.is_a?(String) || arg.is_a?(Integer)
      to_a.length.times { |n| return true if to_a[n] == arg }
    elsif !arg.nil?
      to_a.length.times { |n| return true if to_a[n].match(arg) }
    elsif !block_given?
      to_a.length.times { |n| return true unless to_a[n] == false || to_a[n].nil? }
    else
      to_a.length.times { |n| return true if yield(to_a[n]) }
    end
    false
  end

  def my_none?(arg = nil)
    if arg.is_a?(Class)
      to_a.length.times { |n| return false if to_a[n].is_a?(arg) }
    elsif arg.is_a?(String) || arg.is_a?(Integer)
      to_a.length.times { |n| return false if to_a[n] == arg }
    elsif !arg.nil?
      to_a.length.times { |n| return false if to_a[n].match(arg) }
    elsif !block_given?
      to_a.length.times { |n| return false unless to_a[n] == false || to_a[n].nil? }
    else
      to_a.length.times { |n| return false if yield(to_a[n]) }
    end
    true
  end

  def my_count(arg = nil)
    unless block_given?
      counter = 0
      length.times { |n| counter += 1 if self[n] == arg }
      return counter unless arg.nil?

      return length
    end
    counter = 0
    length.times { |n| counter += 1 if yield(self[n]) }
    counter
  end

  def my_map(proc = nil)
    return to_enum unless block_given?

    new_array = []
    if proc.nil?
      to_a.length.times { |n| new_array.push(yield(to_a[n])) }
    else
      to_a.length.times { |n| new_array.push(proc.call(to_a[n])) }
    end
    new_array
  end

  def my_inject(result = 0, symbol = nil)
    symbol, result = result, symbol if result.is_a?(Symbol) and symbol.is_a?(Integer)
    symbol, result = result, 0 if result.is_a?(Symbol)
    new_array = to_a
    result = '' if new_array[0].is_a?(String)
    if !block_given?
      case symbol
      when :+
        new_array.length.times { |n| result += new_array[n] }
      when :*
        new_array.length.times { |n| result *= new_array[n] }
      when :/
        new_array.length.times { |n| result /= new_array[n] }
      when :-
        new_array.length.times { |n| result -= new_array[n] }
      when :**
        new_array.length.times { |n| result **= new_array[n] }
      when :%
        new_array.length.times { |n| result %= new_array[n] }
      end
      result
    else
      new_array.length.times { |n| result = yield(result, new_array[n]) }
    end
    result
  end
end

def multiply_els(arr)
  arr.my_inject { |x, y| x * y }
end