#!/usr/bin/env ruby
# Copyright (c) 2009, Zhon Johansen
# All Rights Reserved.
#
# This is free software, covered under either the Ruby's license or the
# LGPL. See the COPYRIGHT file for more information.
#
# usage:
#   ruby session_reviews.rb --help
#

require 'optparse'
require 'yaml'


class ReviewAssigner
  def initialize(reviewers, sessions, eliminated_sessions)
    @reviewers = reviewers
    @sessions = sessions
    @eliminated_sessions = eliminated_sessions

    @matchups = ReviewerMatchups.new(reviewers)
  end

  def assign_reviewers
    session_reviewers = {}
    @sessions.each do |key, value|
      next if @eliminated_sessions.include?(key)
      reviewers = @matchups.next

      while conflict? reviewers, key
        reviewers = @matchups.next_previous_rejected
      end

      session_reviewers[key] = reviewers
    end
    return session_reviewers
  end

  def conflict? reviewers, session
    not (reviewers & @sessions[session]).empty?
  end
end

class ReviewerMatchups
  def initialize(reviewers, group_size = 2)
    @reviewers = reviewers
    @group_size = group_size
    @size = @reviewers.size

    # TODO group_size must be a positive int
    @reviewer_indexes = []

    (0..(group_size-1)).each do |i|
      #@reviewer_indexes.push((@size * i.to_f / group_size).to_i)
      @reviewer_indexes.push(i)
    end

    @previous = nil
    @stack = []
  end

  def next
    unless @stack.empty?
      @previous = @stack.pop
      return @previous
    end
    _next
  end

  def next_previous_rejected
    @stack.push @previous
    _next
  end

  def _next
    @previous = []
    @reviewer_indexes.each do |i|
      @previous.push @reviewers[i]
    end
    increment_indexes
    @previous.uniq!
    return _next unless @previous.size == @group_size
    return @previous
  end

  def increment_indexes
    if @reviewer_indexes[0] == @size-1
      (1..@group_size-1).each do |i|
        @reviewer_indexes[i] += i
      end
    end
    (0..@group_size-1).each do |i|
      @reviewer_indexes[i] = (1 + @reviewer_indexes[i]) % @size
    end
    increment_indexes unless all_indexes_increment?(@reviewer_indexes)
  end

  def all_indexes_increment?(indexes)
    indexes.inject(0) {|l,i| return false if l >= i; i}
    true
  end
end

class CommandLine
  def initialize(session_reviewers, args=ARGV)
    @args = args
    @session_reviewers = session_reviewers
    @reviewer_sessions = true
    parse
    show_author_reviews unless @reviewer_sessions == false
  end

  def usage(usage, error_message=nil)
    output = ''
    output << "\n#{error_message}" if error_message
    output << "\n#{usage}\n"
    puts output
    exit(error_message.nil? ? -1 : 0)
  end

  def parse
    opts = OptionParser.new do |opts|
      script_name = File.basename($0)
      opts.banner = <<-end_usage

Match up a list of sessions with a list of reviewers

  usage: ruby #{script_name} [options]

Create three input YAML files in the current directory
  - "sessions.yaml"
  - "reviewers.yaml"
  - "eliminated.yaml"

The program will match up a session id with a number of reviewers (default 2). The "sessions.yaml" has session IDs followed by the author(s) and looks like:

  :sessions: {
    91: [Ron Jeffries, Chet Hendrickson],
    111: [Kent Beck],
    113: [Alistair Cockburn],
    2941: [Ward Chunningham, Martin Fowler]
  }

The "reviewers.yaml" has a list of reviewers names and looks like:

  :reviewers: [
    Ken Shwaber,
    Jeff Sutherland,
    James Grenning,
    Jim Highsmith
  ]

The "eliminated.yaml" file contains a list of sessions that will not be assigned and looks like:


  :eliminated_sessions: [ 
    242,
    3059, 2257, 1673, 747, 542, 283
  ]

OPTIONS

      end_usage
      opts.on('-n', '--reviewers SIZE',
              'Number or reviewers per session(default 2)'){|n|@group_size=n.to_i}
      opts.on('-r', '--session-reviewers',
              'Show session with its reviewers') { show_session_reviewers }
      opts.on('--[no-]reviewer-sessions',
              'Show reviewer with his/her sessions') { |@reviewer_sessions| }

      opts.separator ''
      opts.on('--version', "Output version information and exit") do
        puts <<-EOF

#{script_name} 0.1

Copyright (c) 2009 Zhon Johansen

License 
  Ruby  <http://www.ruby-lang.org/en/LICENSE.txt> or 
  GPLv3 <http://www.gnu.org/licenses/gpl.html>
        EOF
        exit
      end

      opts.on('-h', '--help',
              'Show this help message.') { usage(opts) }

      begin
        @start_dirs = opts.parse! ARGV
      rescue OptionParser::ParseError => e
        usage(opts, "Error: " + e.to_s.strip)
      end
    end
  end

  def show_session_reviewers
    @session_reviewers.sort.each do |key, value|
      printf("%-4d  %-21s %-21s\n", key, value[0], value[1])
    end
  end

  def show_author_reviews
    author_reviews=convert_session_reviewers_to_author_reviews @session_reviewers
    author_reviews.sort.each do |key, value|
      printf("%-21s #{"%-5d" * value.size}\n", key, *value)
    end
  end

  def convert_session_reviewers_to_author_reviews(session_reviewers)
    author_reviews = {}
    session_reviewers.each do |key,value|
      value.each do |item|
        author_reviews[item] ||= []
        author_reviews[item].push(key)
      end
    end
    author_reviews
  end
end

if $0 == __FILE__
  sessions = YAML.load(File.open('sessions.yaml'))
  reviewers = YAML.load(File.open('reviewers.yaml'))
  eliminated = YAML.load(File.open('eliminated.yaml'))

  assigner = ReviewAssigner.new(reviewers[:reviewers],
                                sessions[:sessions],
                                eliminated[:eliminated_sessions])
  session_reviewers = assigner.assign_reviewers

  CommandLine.new(session_reviewers)
end
