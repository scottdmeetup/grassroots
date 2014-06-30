class Comment < ActiveRecord::Base
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'
  belongs_to :commentable, polymorphic: :true
  has_many :votes, as: :voteable

  validates_presence_of :content

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