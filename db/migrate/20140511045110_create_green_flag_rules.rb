class CreateGreenFlagRules < ActiveRecord::Migration
  def change
    create_table :green_flag_rules do |t|
      t.string :group_key
      t.integer :feature_id
      t.integer :order_by
      t.integer :percentage
      t.timestamps
    end
    add_index :green_flag_rules, [:feature_id, :order_by]
  end
end
