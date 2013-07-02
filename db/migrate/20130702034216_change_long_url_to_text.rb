class ChangeLongUrlToText < ActiveRecord::Migration
  def up
    change_column :links, :long_url, :text
  end

  def down
    change_column :links, :long_url, :string
  end
end
