require 'spec_helper'

describe GreenFlag::FeatureEvent do
  it { should validate_presence_of :event_type_code }
  it { should validate_presence_of :feature_id }

  it 'defines constants for each event type code' do
  	expect(GreenFlag::FeatureEvent::ENABLED_DECISIONS_FORGOTTEN).to  be_a_kind_of(Integer)
  	expect(GreenFlag::FeatureEvent::DISABLED_DECISIONS_FORGOTTEN).to be_a_kind_of(Integer)
  end
end
