require 'test/unit'

require 'session_reviews'

REVIEWERS = %w(
  Abby
  Bob
  Cat
  Doug
)

class SessionReviewsTest < Test::Unit::TestCase
  def test_this
  end
end

class ReviewAssignerTest < Test::Unit::TestCase
  SESSIONS = {
    1 => %w(Cat),
    2 => %w(Jeff Kyle),
    3 => %w(Erik),
  }

  def setup
    @assigner = ReviewAssigner.new(REVIEWERS, SESSIONS, [])
  end

  def test_resolve_conflict_when_reviewing_own_session
    session = 1
    reviewers = %w(Cat Jeff)
    assert @assigner.conflict?(reviewers, session)
  end
end

class ReviewerMatchupsTest < Test::Unit::TestCase
  def xxxtest_next_should_return_next_list_of_reviewers
    reviewers = %w( Abby Bob Cat Doug Eddy )
    matchups = ReviewerMatchups.new(reviewers)
    assert_equal %w(Abby Cat), matchups.next
    assert_equal %w(Bob Doug), matchups.next
    assert_equal %w(Cat Eddy), matchups.next
=begin
    assert_equal %w(Doug Abby), matchups.next
    assert_equal %w(Eddy Bob), matchups.next
    assert_equal %w(Abby Doug), matchups.next
    assert_equal %w(Bob Eddy), matchups.next
    assert_equal %w(Cat Abby), matchups.next
    assert_equal %w(Doug Bob), matchups.next
    assert_equal %w(Eddy Cat), matchups.next
    assert_equal %w(Abby Eddy), matchups.next
    assert_equal %w(Bob Abby), matchups.next
    assert_equal %w(Cat Bob), matchups.next
    assert_equal %w(Doug Cat), matchups.next
    assert_equal %w(Eddy Doug), matchups.next
    assert_equal %w(Abby Bob), matchups.next
=end
  end

  def xxxtest_next_previous_rejected_should_push_previous_next_and_return_next
    reviewers = %w( Abby Bob Cat Doug Eddy )
    matchups = ReviewerMatchups.new(reviewers)

    matchups.next
    assert_equal %w(Bob Doug), matchups.next_previous_rejected
    assert_equal %w(Abby Cat), matchups.next
  end

  def xxxtest_match_up_with_3_in_a_group
    reviewers = %w( Abby Bob Cat Doug Eddy Fred Gia Hal Ike)
    matchups = ReviewerMatchups.new(reviewers, 3)
    assert_equal %w(Abby Doug Gia), matchups.next
    assert_equal %w(Bob Eddy Hal), matchups.next
  end

  def xxxtest_match_up_with_3_in_a_group_reviewer_are_paired_up
    reviewers = %w( Abby Bob Cat Doug Eddy Fred Gia Hal Ike)
    matchups = ReviewerMatchups.new(reviewers, 3)
    assert_equal %w(Abby Doug Gia), matchups.next
    assert_equal %w(Bob Eddy Hal), matchups.next
    assert_equal %w(Cat Fred Ike), matchups.next
    #assert_equal %w(Doug Gia Abby), matchups.next
  end

  def test_match_up_with_3_in_a_group_reviewer_are_paired_up
puts
    reviewers = [1, 2, 3, 4, 5]
    matchups = ReviewerMatchups.new(reviewers, 3)
p    matchups.next
p    matchups.next
p    matchups.next
p    matchups.next
p    matchups.next
p    matchups.next
p    matchups.next
p    matchups.next
p    matchups.next
p    matchups.next
p    matchups.next
    #assert_equal [2, 3, 5], matchups.next
    #assert_equal [2, 3, 5], matchups.next
puts
  end
end

