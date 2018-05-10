class CreateMeetupParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :meetup_participants do |t|
      t.integer :meetup_id, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end 
  end
end
