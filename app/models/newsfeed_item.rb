class NewsfeedItem < ActiveRecord::Base
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :newsfeedable, polymorphic: :true  

  def self.from_users_followed_by(a_user)
    relevent_items = a_user.following_relationships.map do |leader|
      following = User.find(leader.leader_id)
      following.newsfeed_items
    end
    relevent_items.flatten
  end

  def answers_question_id
    answer = Answer.find(self.newsfeedable_id)
    answer.question_id
  end
end