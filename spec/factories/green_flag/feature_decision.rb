FactoryGirl.define do
  factory :green_flag_feature_decision, class: GreenFlag::FeatureDecision do
    sequence(:site_visitor_id) { |n| 1 + n }
  end
end
