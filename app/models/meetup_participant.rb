class MeetupParticipant < ActiveRecord::Base
  belongs_to :meetup
  belongs_to :user

  validates :meetup_id, :user_id, presence: true

end
