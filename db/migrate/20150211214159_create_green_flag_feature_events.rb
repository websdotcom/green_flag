class CreateGreenFlagFeatureEvents < ActiveRecord::Migration
  def change
    create_table :green_flag_feature_events do |t|
      t.integer :feature_id, :null => false
      t.integer :event_type_code, :null => false
      t.integer :count, :null => false
      t.timestamps
    end

    add_index :green_flag_feature_events, :feature_id
    add_index :green_flag_feature_events, :event_type_code
  end
end