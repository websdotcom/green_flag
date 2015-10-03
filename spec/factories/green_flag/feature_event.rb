FactoryGirl.define do
  factory :green_flag_feature_event, class: GreenFlag::FeatureEvent do
    event_type_code 'test_event'
    count           1
  end
end