class Question < ActiveRecord::Base
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'
  has_many :answers
  has_many :comments
  has_many :categorizations
  has_many :categories, through: :categorizations
end