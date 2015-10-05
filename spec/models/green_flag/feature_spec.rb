require "spec_helper"

describe GreenFlag::Feature do
  describe ".for_code!" do
    subject { GreenFlag::Feature.for_code!("foo") }

    it "when feature does not exist, creates a feature" do
      expect{ subject }.to change { GreenFlag::Feature.count }.by(1)
    end
    it "when feature does exists, does not create a feature" do
      FactoryGirl.create(:green_flag_feature, code: "foo")
      expect{ subject }.to_not change { GreenFlag::Feature.count }
    end
  end

  describe "#decide_if_enabled_for_visitor" do
    let(:feature)          { GreenFlag::Feature.create(code: "big_font") }
    let(:site_visitor_id)  { 1 }

    let(:non_applying_rule) { double(id: 1, applies_to?: false, decision?: true)  }
    let(:true_rule)         { double(id: 2, applies_to?: true,  decision?: true)  }
    let(:false_rule)        { double(id: 3, applies_to?: true,  decision?: false) }

    context "there are no rules" do
      it "returns a feature decision with the correct attributes" do
        feature_decision = feature.decide_if_enabled_for_visitor(site_visitor_id)

        expect(feature_decision.rule_id).to be_nil
        expect(feature_decision.enabled).to be_nil
      end
    end

    context "the first applying rule is true" do
      it "returns a feature decision with the correct attributes" do
        feature.stub(rules: [non_applying_rule, true_rule])

        feature_decision = feature.decide_if_enabled_for_visitor(site_visitor_id)

        expect(feature_decision.rule_id).to eq true_rule.id
        expect(feature_decision.enabled).to eq true
      end
    end

    context "the first applying rule is false" do
      it "returns a feature decision with the correct attributes" do
        feature.stub(rules: [false_rule, true_rule])

        feature_decision = feature.decide_if_enabled_for_visitor(site_visitor_id)

        expect(feature_decision.rule_id).to eq false_rule.id
        expect(feature_decision.enabled).to eq false
      end
    end
  end

  describe "#forget_non_manual_decisions!" do
    let(:feature) { GreenFlag::Feature.create(code: "big_font") }
    let(:enabled) { true }

    context "when there are no decisions" do
      subject { feature.forget_non_manual_decisions!(enabled) }

      it "should not attempt to delete non-manual decisions" do
        expect(GreenFlag::FeatureDecision.non_manual).to receive(:delete_all).never
      end

      it "should not create a feature event" do
        expect(GreenFlag::FeatureEvent.count).to eq 0
      end
    end

    context "when there are manual decisions" do
      subject { feature.forget_non_manual_decisions!(enabled) }

      before(:each) do
        @manual_fd = GreenFlag::FeatureDecision.create!(feature_id: feature.id, manual: true, site_visitor_id: 1)
      end

      it "should not delete the manual decisions" do
        expect(GreenFlag::FeatureDecision.find_by_id(@manual_fd.id)).to be_present
      end

      it "should not create a feature event" do
        expect(GreenFlag::FeatureEvent.count).to eq 0
      end
    end

    context "when there are automatic decisions" do
      before(:each) do
        @feature2 = GreenFlag::Feature.create!(code: "huge_banner_ad")
        @auto_fd = GreenFlag::FeatureDecision.create!(feature_id: @feature2.id, manual: false, enabled: true, site_visitor_id: 1)

        @feature2.forget_non_manual_decisions!(enabled)
      end

      it "should delete the automatic decisions" do
        @feature2.forget_non_manual_decisions!(enabled)
        expect(GreenFlag::FeatureDecision.find_by_id(@auto_fd)).to be_nil
      end

      it "should create a feature event with the correct attributes" do
        feature_event = GreenFlag::FeatureEvent.last
        expect(feature_event).to be_present
        expect(feature_event.feature_id).to eq @feature2.id
        expect(feature_event.event_type_code).to eq GreenFlag::FeatureEvent::ENABLED_DECISIONS_FORGOTTEN
        expect(feature_event.count).to eq 1
      end
    end
  end

  describe "#latest_version" do
    let(:feature) { FactoryGirl.create(:green_flag_feature, version_number: 1) }

    subject { feature.latest_version }

    context "when there are rules" do
      before(:each) do
        @latest_version_number = 15

        (0...3).each do |i|
          FactoryGirl.create(:green_flag_rule, feature_id: feature.id, version_number: @latest_version_number - i) 
        end
      end

      it "returns the version number of the last rule" do
        expect(subject).to eq @latest_version_number
      end
    end

    context "when there are no rules" do
      it "returns the current version number of the feature" do
        expect(subject).to eq feature.version_number
      end
    end
  end

  describe "#requires_manual_deletion?" do
    let(:feature)           { GreenFlag::Feature.create(code: "big_font") }
    let(:feature_decisions) { [] }

    context "with more than 1,000,000 feature decisions" do
      it "returns true" do
        expect(feature_decisions).to receive(:count).and_return(2_000_000)
        expect(feature).to receive(:feature_decisions).
          and_return(feature_decisions)

        expect(feature.requires_manual_deletion?).to be_true
      end
    end

    context "with fewer than 1,000,000 feature decisions" do
      it "returns false" do
        expect(feature_decisions).to receive(:count).and_return(500_000)
        expect(feature).to receive(:feature_decisions).
          and_return(feature_decisions)

        expect(feature.requires_manual_deletion?).to be_false
      end
    end
  end

  describe "delete_associated_data" do
    let(:feature) { GreenFlag::Feature.create(code: "big_font") }

    before(:each) do
      5.times do
        FactoryGirl.create(:green_flag_rule, feature_id: feature.id)
        FactoryGirl.create(:green_flag_feature_event, feature_id: feature.id)
        FactoryGirl.create(:green_flag_feature_decision, feature_id: feature.id)
      end

      feature.delete_associated_data
    end

    it "deletes all associated rules" do
      expect(feature.rules.count).to eq 0
    end

    it "deletes all associated events" do
      expect(feature.feature_events.count).to eq 0
    end

    it "deletes all associated feature decisions" do
      expect(feature.feature_decisions.count).to eq 0
    end
  end
end
