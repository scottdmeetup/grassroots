class Badge < ActiveRecord::Base
  has_many :accomplishments
  has_many :users, through: :accomplishments
end