class CreateDispensers < ActiveRecord::Migration[6.1]
  def change
    create_table :dispensers do |t|
      t.float :flow_volume

      t.timestamps
    end
  end
end
