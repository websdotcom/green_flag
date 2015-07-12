class CreateGreenFlagFeatures < ActiveRecord::Migration
  def change
    create_table :green_flag_features do |t|
      t.string :code, null: false
      t.string :description
      t.timestamps
    end
    add_index :green_flag_features, :code, :unique => true
  end
end
