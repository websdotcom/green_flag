FactoryGirl.define do
  factory :green_flag_rule, class: GreenFlag::Rule do
    group_key      'Factory Test Group'
    feature_id     1 
    order_by       1
    percentage     100
    version_number 1
  end
end
