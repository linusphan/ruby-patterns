=begin

Rails code for modules - setting up instance methods and class methods
- code example relates to postit Rails application
  (https://github.com/linusphan/postit)
- this is the traditional metaprogramming way
- Rails has thing called Concerns that allows us to clean up the syntax a bit

=end

module Voteable
  def self.included(base)
    # getting into some metaprogramming a bit
    base.send(:include, InstanceMethods)
    base.extend ClassMethods
    base.class_eval do
      my_class_method
    end
  end

  module InstanceMethods
    def total_votes
      self.up_votes - self.down_votes
    end

    def up_votes
      self.votes.where(vote: true).size
    end

    def down_votes
      self.votes.where(vote: false).size
    end
  end

  module ClassMethods
    def my_class_method
      has_many :votes, as: :voteable
    end
  end
end


=begin

Using Concerns which encapsulates above pattern with cleaner syntax
- this is a Rails thing

=end

module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable
  end

  def total_votes
    self.up_votes - self.down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end
end
