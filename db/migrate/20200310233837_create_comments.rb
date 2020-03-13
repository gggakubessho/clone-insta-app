class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :image, foreign_key: true
      t.integer :from_user_id,null: false
      t.text :content

      t.timestamps
    end
    add_index :comments, [:image_id, :created_at]
  end
end
