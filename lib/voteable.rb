module Voteable
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.extend ClassMethods
  end

  module InstanceMethods
    def total_votes
      up_votes - down_votes
    end

    def up_votes
      self.votes.where(vote: true).size
    end

    def down_votes
      self.votes.where(vote: false).size
    end
  end

  module ClassMethods
  end
end