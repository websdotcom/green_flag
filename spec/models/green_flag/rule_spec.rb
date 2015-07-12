require 'spec_helper'

describe GreenFlag::Rule do
  describe '.set_rules!' do
    let(:feature) { FactoryGirl.create(:green_flag_feature, version_number: 1) }

    subject { GreenFlag::Rule.set_rules!(feature.id, rules_array) }

    context 'with no rules in rules_array' do
      let(:rules_array) { [] } 

      it { should be_empty }
    end

    context 'with rules in rules_array' do
      let(:rules_array) { [{"created_at"=>"2015-02-18T18:30:56Z",
        "feature_id"=>2,
        "group_key"=>"Pre-existing Visitors",
        "id"=>14,
        "order_by"=>0,
        "percentage"=>22,
        "updated_at"=>"2015-02-18T18:30:56Z",
        "version_number"=>7},
        {"group_key"=>"Everyone", "percentage"=>"40", "order_by"=>1}]
      }

      it 'increments the feature version' do
        subject

        expect(feature.reload.version_number).to eq 2
      end

      it 'creates the correct number of new rules' do
        expect { subject }.to change { GreenFlag::Rule.count }.by(2)
      end

      it 'creates new rules with the correct attributes' do
        subject
        feature.reload

        rule1 = feature.rules.first
        rule2 = feature.rules.last

        expect(rule1.group_key).to      eq 'Pre-existing Visitors'
        expect(rule1.order_by).to       eq 0
        expect(rule1.percentage).to     eq 22
        expect(rule1.version_number).to eq feature.version_number

        expect(rule2.group_key).to      eq 'Everyone'
        expect(rule2.order_by).to       eq 1
        expect(rule2.percentage).to     eq 40
        expect(rule2.version_number).to eq feature.version_number
      end

      it 'returns the newly-created rules' do
        actual_return_value   = subject
        feature.reload

        expected_return_value = [feature.rules.first, feature.rules.last]
      
        expect(actual_return_value).to eq expected_return_value
      end
    end

    context 'when the feature is not on the current version due to it having been reverted' do
      let(:rules_array) { [{"created_at"=>"2015-02-18T18:30:56Z",
        "feature_id"=>2,
        "group_key"=>"Pre-existing Visitors",
        "id"=>14,
        "order_by"=>0,
        "percentage"=>22,
        "updated_at"=>"2015-02-18T18:30:56Z",
        "version_number"=>7},
        {"group_key"=>"Everyone", "percentage"=>"40", "order_by"=>1}]
      }

      before(:each) do
        @latest_feature_version = 10

        FactoryGirl.create(:green_flag_rule, feature_id: feature.id, version_number: @latest_feature_version)
      end

      it 'increments the feature version to a higher number than the latest version' do
        GreenFlag::Rule.set_rules!(feature.id, rules_array)

        expect(feature.reload.version_number).to eq @latest_feature_version + 1
      end
    end
  end

  describe '#decision?' do
    it 'is always false when percentage is 0' do
      rule = GreenFlag::Rule.new(percentage: 0)
      10000.times do
        expect(rule.decision?).to be_false
      end
    end

    it 'is always true when percentage is 100' do
      rule = GreenFlag::Rule.new(percentage: 100)
      10000.times do
        expect(rule.decision?).to be_true
      end
    end
  end

end
