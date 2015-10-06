FactoryGirl.define do
  factory :green_flag_rule, class: GreenFlag::Rule do
    sequence(:group_key) { |n| "Factory Test Group #{n}" }
    sequence(:order_by)  { |n| 1 + n }
    feature_id     1 
    percentage     100
    version_number 1
  end
end
