class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.string          :space_type
      t.text            :description
      t.string          :unit_number
      t.string          :rate
      t.string          :rate_units
      t.string          :floor_number
      t.string          :api_uuid
      t.string          :api_building_uuid
      t.timestamps
    end
  end
end
