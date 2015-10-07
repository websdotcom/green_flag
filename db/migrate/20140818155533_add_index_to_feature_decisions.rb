require 'activerecord-concurrent-index'

class AddIndexToFeatureDecisions < ActiveRecord::Migration
  def change
    add_index_concurrently :green_flag_feature_decisions, :feature_id
  end
end
