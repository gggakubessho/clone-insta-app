class AddIndexToImages < ActiveRecord::Migration[5.1]
  def change
    add_index :images, [:user_id, :created_at]
  end
end
