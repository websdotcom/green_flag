class GreenFlag::FeatureEvent < ActiveRecord::Base
  attr_accessible :event_type_code, :feature_id, :count

  validates :event_type_code, presence: true
  validates :feature_id, presence: true

  ENABLED_DECISIONS_FORGOTTEN = 0
  DISABLED_DECISIONS_FORGOTTEN = 1
end