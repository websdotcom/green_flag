class CreateGreenFlagSiteVisitors < ActiveRecord::Migration
  def change
    create_table :green_flag_site_visitors do |t|
      t.integer :user_id
      t.timestamps
    end
    add_index :green_flag_site_visitors, :user_id, unique: true
  end
end
