class AddIndexesToNuggetColumns < ActiveRecord::Migration
  def change
    # Adds indexes needed to efficiently query against the nugget table.
    # Original version of this app missed these indexes, making any form of
    # querying at even modest scale inefficient and slow. This should
    # fix that problem to some minor degree.

    add_index :nuggets, :created_at
    add_index :nuggets, :updated_at
    add_index :nuggets, :latitude
    add_index :nuggets, :longitude
    add_index :nuggets, :submitter
    add_index :nuggets, :submitted_at
    add_index :nuggets, :contact_broker_fake_name
    add_index :nuggets, :contact_broker_fake_email

  end
end
