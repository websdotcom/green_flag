class CreateGreenFlagFeatureDecisions < ActiveRecord::Migration
  def change
    create_table :green_flag_feature_decisions do |t|
      t.integer :feature_id, null: false
      t.integer :site_visitor_id, null: false
      t.boolean :enabled
      t.boolean :manual
      t.timestamps
    end
    add_index :green_flag_feature_decisions, [:site_visitor_id, :feature_id], 
      {unique: true, name: 'index_gf_feature_decisions_on_site_visitor_id_feature_id'}
  end
end
