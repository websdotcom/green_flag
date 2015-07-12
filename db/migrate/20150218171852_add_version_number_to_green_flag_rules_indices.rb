require 'activerecord-concurrent-index'

class AddVersionNumberToGreenFlagRulesIndices < ActiveRecord::Migration
  def up
    remove_index :green_flag_rules, [:feature_id, :group_key]
    remove_index :green_flag_rules, [:feature_id, :order_by]

    add_index_concurrently :green_flag_rules, [:feature_id, :group_key, :version_number], :unique => true, :name => 'index_green_flag_rules_on_feature_version_and_group_key'
    add_index_concurrently :green_flag_rules, [:feature_id, :order_by,  :version_number], :unique => true, :name => 'index_green_flag_rules_on_feature_version_and_order_by'
  end

  def down
    add_index_concurrently :green_flag_rules, [:feature_id, :group_key], :unique => true
    add_index_concurrently :green_flag_rules, [:feature_id, :order_by],  :unique => true

    remove_index :green_flag_rules, [:feature_id, :group_key, :version_number]
    remove_index :green_flag_rules, [:feature_id, :order_by,  :version_number]
  end
end
