class AddUserRefrenceToTapEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :tap_events, :user, foreign_key: true
  end
end
