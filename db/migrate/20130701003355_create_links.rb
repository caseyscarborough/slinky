class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :short_url
      t.string :long_url
      t.integer :user_id
      t.integer :total_clicks
      t.datetime :last_visited

      t.timestamps
    end
    add_index :links, [:user_id, :short_url]
  end
end
