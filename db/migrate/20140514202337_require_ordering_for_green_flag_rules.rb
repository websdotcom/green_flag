class RequireOrderingForGreenFlagRules < ActiveRecord::Migration
  def up
    change_column :green_flag_rules, :order_by, :integer, null: false
    remove_index :green_flag_rules, [:feature_id, :order_by]
    add_index :green_flag_rules, [:feature_id, :order_by], :unique => true
  end

  def down
    remove_index :green_flag_rules, [:feature_id, :order_by]
    add_index :green_flag_rules, [:feature_id, :order_by]
    change_column :green_flag_rules, :order_by, :integer, null: true
  end
end
