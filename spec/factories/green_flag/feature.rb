FactoryGirl.define do
  factory :green_flag_feature, class: GreenFlag::Feature do
    code          'feature_code'
    description   'Feature Description'
    version_number 1
  end
end
