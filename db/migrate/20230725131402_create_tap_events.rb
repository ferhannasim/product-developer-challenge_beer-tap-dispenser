class CreateTapEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :tap_events do |t|
      t.references :dispenser, null: false, foreign_key: true
      t.string :status
      t.datetime :opened_at
      t.datetime :closed_at
      t.decimal :price

      t.timestamps
    end
  end
end
