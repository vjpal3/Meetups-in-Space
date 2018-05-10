class CreateMeetups < ActiveRecord::Migration[5.2]
  def change
    create_table :meetups do |t|
      t.string :title, null: false
      t.integer :creator_id, null: false
      t.string :category
      t.string :description
      t.string :location
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false

      t.timestamps null: false
    end
  end
end
