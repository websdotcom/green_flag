class SetDefaultPercentageInGreenFlagRules < ActiveRecord::Migration
  def up
    execute 'update green_flag_rules set percentage=0 where percentage is null'
    change_column :green_flag_rules, :percentage, :integer, default: 0, null: false
  end

  def down
    change_column :green_flag_rules, :percentage, :integer, default: nil, null: true
  end
end
