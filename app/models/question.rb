class Question < ActiveRecord::Base
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'
  has_many :answers
  has_many :comments
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :newsfeed_items, as: :newsfeedable
  has_many :votes, as: :voteable

  validates_presence_of :title, :description

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