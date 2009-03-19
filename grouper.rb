# take a look at Steiner
# Steiner system S(t, k, v)

group_size = 2
people_count = 9 

people_count = ARGV[0].to_i if ARGV[0]


people = (1..people_count).to_a

class Grouper
  def initialize(group_size, sub_group_size)
    @n = group_size
    @k = sub_group_size 

    @or_rules = [
      method(:only_off_by_1)
    ]
  end

  def combine_indexes
    list = (0...@n).to_a.map { |i| [i] }

    (1...@k).each do
      list = another_pairing(list)
    end
    list
  end

  def another_pairing(list, n=@n)
    result = []
    list.each do |i|
      ((i.max+1)...n).each do |j|
        result.push(i.dup.push(j))
      end
    end
    result
  end

  def permutation(k, s) 
    (2...s.size).each do |j|
      s.swap(k % j, j-1)
      k /= j
    end
    s
  end

  def permute(list)
    k = @k
    (2...list.size).each do |i|
      swap(list, k % i, i-1)
      k /= i
    end
    list
  end

  def swap(list, i, j)
    list[i], list[j] = list[j], list[i]
  end

  def _permute(range, result)
    range.each do |i|
      catch :continue do
        unless only_off_by_1(result[0...i], result[i])
          (i+1...result.size).each do |j|
            if only_off_by_1(result[0...i], result[j])
              swap result, i, j

              throw :continue
            end
          end

          return false
          # look backward for a possible solution?
        end
      end
    end
    result
  end

  def apply_rules
    result_set = []
    extra_set = combine_indexes

    while result_set.size < @n
      endless_loop = true
      i = 0
      while (i < extra_set.size)
        if only_off_by_1(result_set, extra_set[i])
          result_set.push(extra_set.delete_at(i))
          endless_loop = false
        end
        i += 1
      end
      if endless_loop 
        # take out k-1 and find k to put back in
        (@k-1).times { extra_set.push result_set.shift }

        extra_set_indexes = (0...extra_set.size).to_a.map {|i| [i] }

        (1...@k).each do                # TODO remove this duplication
          extra_set_indexes = 
            another_pairing(extra_set_indexes, extra_set.size)
        end

        extra_set_indexes.each do |i|
          items = i.map {|j| extra_set[j] }

          if only_off_by_1(result_set, items)
            result_set << items
            endless_loop = false
          end
        end

puts "#@n C #@k"
p result_set
p extra_set
      end

      break if endless_loop

    end
    return result_set
  end

  def xxxapply_rules
    result = combine_indexes

    solved = false
    10.times do
      if _permute(1...result.size, result) 
        solved = true
        #puts "solved #@n P #@k by radomizing"
        break
      end
      result.sort! { rand(3) - 1 }
    end
    puts "failed to solve #@n P #@k" unless solved

  end

  def xxxapply_rules
    result = combine_indexes

    #result.sort! { rand(3) - 1 }

    @start_value = 1

puts
    catch :restart do
    (@start_value...result.size).each do |i|
      print "#{@start_value} "
      puts i
      catch :continue do
        unless only_off_by_1(result[0...i], result[i])
          (i+1...result.size).each do |j|
            if only_off_by_1(result[0...i], result[j])
              swap result, i, j
              throw :continue
            end
          end

          # look backward for a possible solution
          back_index = nil
          (i-1).downto(0) do |j|
          #i(0...i).each do |j|
print "bt: #{j} "
p result[j]
=begin
=end
            if only_off_by_1(result[0...j], result[i])
              swap result, i,j
              @start_value = j-1
p "restarting #{@start_value}"

              throw :restart
            end
          end
          raise "shouldn't be here"
        end
      end
    end
    result
  end
  end

  def only_off_by_1(*args)
    hash = off_by_1_hash
    (args).flatten.each do |i|
      hash[i] += 1
    end
    min = hash.values.min
    max = hash.values.max

    return max - min <= 1
  end

  def off_by_1_hash
    @hash = Hash[*(0...@n).collect {|i| [i, 0]}.flatten] unless @hash
    @hash.dup
  end


  def ph(h)
    print "{"
    print h.keys.sort.collect {|i| "#{i}=>#{h[i]}" }.join(", ")
    puts "}"
  end

  # evenly distribute the groupings
  def combine(groupings, people, results=[], bad_path=[])
    return results if groupings.empty?

    print "R:"
    p results
    puts
    print "b:"
    p bad_path.sort
    #print "g:"
    #p groupings
    puts

    line = nil
    groupings.each do |item|
      if only_off_by_1(results, item, people)
        line = groupings.delete item
        break
      end
    end

    if line
      if bad_path.include? [results[-1], line]
        item = results.pop
        groupings.push line 
        groupings.push item
        bad_path.push [results[-1], item] 
      else
        results.push line
      end
    else
      item = results.pop
      bad_path.push([results[-1], item])
      groupings.push item
    end

    combine groupings, people, results, bad_path
  end

=begin
  def only_off_by_1(group, item, all)
    hash = all.inject({}) { |h, i| h[i] = 0; h }
    (group + item).flatten.each do |i|
      hash[i] += 1
    end
    min = hash.values.min
    max = hash.values.max

    return max - min <= 1
  end
=end

  def binom(n, k)
    return 1 if ( k ==0 ) || (n== k)

# puts "(#{n}, #{k})"

    n1 = binom( n - 1, k)
    n2 = binom( n - 1, k - 1)
    return n1 + n2
  end

end

def all_indexes(index_count, group_size)
  result = (0...index_count).to_a.map { |i| [i] }

  (1...group_size).each do
    result = another_pairing(result, index_count)
  end
  result
end

def another_pairing(list, index_count)
  result = []
  list.each do |i|
    ((i.max+1)...index_count).each do |j|
      result.push [i, j].flatten
    end
  end
  result
end


def all_groups(people, group_size)
  all_indexes(people.size, group_size).map {|i| i.map {|j| people[j] } }
end

def print_groups(g)
  g.each {|i| p i }
end

