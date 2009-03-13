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

  def another_pairing(list)
    result = []
    list.each do |i|
      ((i.max+1)...@n).each do |j|
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
    result = combine_indexes

    solved = false
    100.times do
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
=begin
unless back_index
hash = off_by_1_hash
(result[0...i]).flatten.each do |i|
  hash[i] ||= 0
  hash[i] += 1
end
ph hash
p result
p "No back_index found in #{@n}C#@k at #{i}" 
end
=end
=begin
          unless back_index
            hash = off_by_1_hash
            (result[0...i]).flatten.each do |j|
              hash[j] += 1
            end
            puts
            ph hash
            print "#{i}=>"
            p result[i]
            p result[0...i]
            puts
            p result[i...result.size]
            raise "Impossible backup for #{@n}C#@k at #{i}"
          end
          raise "Impossible backup for #{@n}C#@k at #{i}" unless back_index
          # look for a replace ment for back_index
          (i...result.size).each do |j|
            if only_off_by_1(result[0...back_index], 
                             result[(back_index+1)...i],
                             result[j])
              back_index = j
              swap result, back_index, j
p "swapping back #{back_index},#{j}"
              throw :continue
            end
          end
=end
          
=begin
hash = {}
(result[0...i]).flatten.each do |i|
  hash[i] ||= 0
  hash[i] += 1
end
p hash
#p result[i]
#p result
p "boom for #@n" 
return result
=end
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

=begin
groupings = all_groups(people, group_size)
print_groups groupings

puts '-----------'

p combine(groupings, people)
print_groups(combine(groupings, people))
=end




=begin
def combine(groupings, people)
  results = []

  working = groupings.dup
  scratch = []


  back_track = false
  while not working.empty?
    line = working.shift
    if only_off_by_1(results, line, people)
      results.push(line)
      back_track = false
    else
      scratch.push line
      if working.empty?
        if back_track
          scratch.push results.pop
          back_track = false
        else
          back_track = true
        end
      end
    end
    if working.empty?
      if back_track
        scratch.push results.pop
        back_track = false
      else
        back_track = true
      end
      working = scratch
      scratch = []
    end

    raise "unable to solve" if results.empty?
    sleep 0.5
print 'R: '
p results
print 's: '
p scratch
print 'w: '
p working
 =begin
 =end
  end
  results

end
=end

=begin
def combine(g, all)
  results = nil
  while 1
    results = []
    #scratch = g.sort { rand * 3 - 2 }
    scratch = g.sort {|a,b|  b[0] <=> a[0]+1}
p scratch
    count = 1
    while not scratch.empty?
      line = scratch.shift
      if only_off_by_1(results, line, all)
        results.push(line)
      else
        scratch.push line
        count += 1
        if count == 10
          break
        end
      end
    #  puts 'line'
    #  p line
    #  puts "scratch"
    #  print_groups scratch
    #  puts "results"
    #  print_groups results
    #  sleep 0.5
    end
    break if scratch.empty?
  end
  results
end
=end
=begin
  def binom(n, k)
    return 1 if ( k ==0 ) || (n== k)

 puts "(#{n}, #{k})"

    n1 = binom( n - 1, k)
    n2 = binom( n - 1, k - 1)
    return n1 + n2
  end
=end

