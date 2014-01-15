class AddIndexToNuggetState < ActiveRecord::Migration
  def change
    # At the point this migration was generated, the "state" column
    # in the Nuggets table had no index on it, so obviously queries
    # will be slow at any point of scale. A basic index should help.
    add_index :nuggets, :state
  end
end
