class Answer < ActiveRecord::Base
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'
  belongs_to :question
  has_many :comments, as: :commentable
  has_many :newsfeed_items, as: :newsfeedable
  has_many :votes, as: :voteable

  validates_presence_of :description

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