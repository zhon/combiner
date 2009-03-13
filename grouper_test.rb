
require 'test/unit'

require 'grouper'

  class Array
    def swap(i, j)
      temp = self[i]
      self[i] = self[j]
      self[j] = temp
    end
  end

class GrouperTest < Test::Unit::TestCase
  def setup
    @grouper = Grouper.new(5, 3)
  end

  def test_binomials
    assert_equal 15, @grouper.binom(6, 2)
  end

  def test_combine_indexes_when_n_is_2_and_k_is_0
    assert_equal [[0],[1]], Grouper.new(2,0).combine_indexes
  end

  def test_combine_indexes_when_n_is_2_and_k_is_1
    assert_equal [[0],[1]], Grouper.new(2,1).combine_indexes
  end

  def test_combine_indexes_when_n_is_4_and_k_is_2
    assert_equal [[0, 1],
                  [0, 2],
                  [0, 3],
                  [1, 2],
                  [1, 3],
                  [2, 3]], Grouper.new(4,2).combine_indexes
  end

  def test_combine_indexes_when_n_is_5_and_k_is_3
    assert_equal [[0, 1, 2],
                  [0, 1, 3],
                  [0, 1, 4],
                  [0, 2, 3],
                  [0, 2, 4],
                  [0, 3, 4],
                  [1, 2, 3],
                  [1, 2, 4],
                  [1, 3, 4],
                  [2, 3, 4]], Grouper.new(5,3).combine_indexes
  end

  def test_permute
    assert_equal [4,0,1,2,3,5], Grouper.new(nil, 0).permute([0,1,2,3,4,5])
    assert_equal [4,0,2,1,3,5], Grouper.new(nil, 4).permute([0,1,2,3,4,5])
  end

  def test_off_by_1
    g = Grouper.new(5, 2)
    assert g.only_off_by_1([[1,2], [3,4]], [])
    assert g.only_off_by_1([1,2], [3,4])
    assert !g.only_off_by_1([[1,2]], [3,4], [2,3] )
  end

  def test_off_by_1_with_9_C_3
    g = Grouper.new(9, 3)
    assert ! g.only_off_by_1([[0,1,2]],[0,1,3])
  end

  def test_permute_with_10_C_2
    g = Grouper.new(10, 2)
    g.apply_rules
  end

  def test_permutation_of_2
    g = Grouper.new(5, 2)
    g.apply_rules
    g = Grouper.new(6, 2)
    g.apply_rules
    g = Grouper.new(7, 2)
    g.apply_rules
    g = Grouper.new(8, 2)
    g.apply_rules
    g = Grouper.new(9, 2)
    g.apply_rules
    g = Grouper.new(10, 2)
    g.apply_rules
    g = Grouper.new(11, 2)
    g.apply_rules
  end

  def test_permutation_of_3
    g = Grouper.new(5, 3)
    g.apply_rules
    g = Grouper.new(5, 2)
    g.apply_rules
    g = Grouper.new(7, 3)
    g.apply_rules
    g = Grouper.new(8, 3)
    g.apply_rules
    g = Grouper.new(9, 3)
    g.apply_rules
    g = Grouper.new(10, 3)
    g.apply_rules
    g = Grouper.new(11, 3)
    g.apply_rules
    g = Grouper.new(12, 3)
    g.apply_rules
    g = Grouper.new(13, 3)
    g.apply_rules
  end

  def test_permutation_of_4
    g = Grouper.new(5, 4)
    g.apply_rules
    g = Grouper.new(6, 4)
    g.apply_rules
    g = Grouper.new(7, 4)
    g.apply_rules
    g = Grouper.new(8, 4)
    g.apply_rules
    g = Grouper.new(9, 4)
    g.apply_rules
    g = Grouper.new(10, 4)
    g.apply_rules
  end
  # Steiner system S(t, k, v)
  def steiner_ternary(n)
    t = n*(n-1)/6
    (1..n).each do |x|

#
#    Variables: X = {Xi | i an integer in [1,t]}.
#    Domain: for all Xi in X, D(Xi) = {1,...,n}.
#    Constraints:
#    every set variable Xi has a cardinality of 3:
#    for all i in [1,t], |Xi| = 3.
#    the cardinality of the intersection of every two distinct sets must not exceed 1:
#    for all i,j in [1,t], |intersection(Xi,Xj)|<=1.
    end
    
  end

=begin
     for j = 2 to length(s) {
        swap s[(k mod j) + 1] with s[j]; // note that our array is indexed starting at 1
        k := k / j;        // integer division cuts off the remainder
     }
     return s;
 }
=end
    
end
