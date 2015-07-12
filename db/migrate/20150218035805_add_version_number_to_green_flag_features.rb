class AddVersionNumberToGreenFlagFeatures < ActiveRecord::Migration
  def self.up
    add_column :green_flag_features, :version_number, :integer, null: false, default: 1
  end

  def self.down
    remove_column :green_flag_features, :version_number
  end
end
