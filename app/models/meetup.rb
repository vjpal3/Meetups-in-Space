class Meetup < ActiveRecord::Base
  has_many :meetup_participants
  has_many :users, through: :meetup_participants

  validates :title, :creator_id, :description, :address, :city, :state, :zip, presence: true
  validates :description, length: { in: 20..1000 }

end
