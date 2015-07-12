class AddRuleIdToGreenFlagFeatureDecisions < ActiveRecord::Migration
  def change
    add_column :green_flag_feature_decisions, :rule_id, :integer
  end
end
