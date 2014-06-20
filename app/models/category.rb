class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :questions, through: :categorizations
end