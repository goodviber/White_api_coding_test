class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.date :start_date
      t.date :end_date
      t.integer :duration
      t.boolean :removed, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
