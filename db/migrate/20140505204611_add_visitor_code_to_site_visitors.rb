class AddVisitorCodeToSiteVisitors < ActiveRecord::Migration
  def change
    add_column :green_flag_site_visitors, :visitor_code, :string
    execute 'update green_flag_site_visitors set visitor_code = id'
    change_column :green_flag_site_visitors, :visitor_code, :string, null: false
    add_index :green_flag_site_visitors, :visitor_code, unique: true
  end
end
