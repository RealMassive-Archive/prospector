class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string        :name
      t.string        :size
      t.string        :size_units
      t.string        :street
      t.string        :city
      t.string        :state
      t.string        :zipcode
      t.string        :api_uuid
      t.timestamps
    end

    add_index :buildings, :street
    add_index :buildings, :city
    add_index :buildings, :state
    add_index :buildings, :zipcode
    add_index :buildings, :api_uuid
  end
end
