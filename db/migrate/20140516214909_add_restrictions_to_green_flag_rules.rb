class AddRestrictionsToGreenFlagRules < ActiveRecord::Migration
  def up
    change_column :green_flag_rules, :group_key, :string, null: false
    change_column :green_flag_rules, :feature_id, :integer, null: false
    add_index :green_flag_rules, [:feature_id, :group_key], :unique => true
  end

  def down
    remove_index :green_flag_rules, [:feature_id, :group_key]
    change_column :green_flag_rules, :group_key, :string, null: true
    change_column :green_flag_rules, :feature_id, :integer, null: true
  end
end
