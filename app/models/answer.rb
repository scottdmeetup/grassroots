class Answer < ActiveRecord::Base
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'
  belongs_to :question
  has_many :comments

  validates_presence_of :description
end