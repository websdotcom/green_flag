require 'spec_helper'

describe GreenFlag::FeatureDecision do

  let(:feature) { GreenFlag::Feature.create(code: 'test_feature_code') }
  let(:site_visitor) { GreenFlag::SiteVisitor.create(visitor_code: '123') }

  describe '.feature_enabled?' do
    subject { GreenFlag::FeatureDecision.feature_enabled?(:test_feature_code, site_visitor.id) }

    it "creates the Feature when it doesn't exist" do
      expect { subject }.to change { GreenFlag::Feature.count }.by(1)
    end

    context 'when the FeatureDecision does not exist' do
      it 'is false by default' do
        expect(subject).to be_false
      end
      it 'creates a new FeatureDecision' do
        expect { subject }.to change { GreenFlag::FeatureDecision.count }.by(1)
      end
    end

    context 'when the FeatureDecision exists' do
      let!(:feature_decision) {
        GreenFlag::FeatureDecision.create(
          feature_id: feature.id,
          site_visitor_id: site_visitor.id,
          enabled: false)
      }

      it 'is false when FeatureDecision is not enabled' do
        feature_decision.update_attribute(:enabled, false)
        expect(subject).to be_false
      end

      it 'is true when FeatureDecision is enabled' do
        feature_decision.update_attribute(:enabled, true)
        expect(subject).to be_true
      end
    end
  end

  describe '.ensure_feature_enabled' do
    let(:user) { double(id: 1) }
    subject { GreenFlag::FeatureDecision.ensure_feature_enabled(feature.code, user) }

    context 'when the user has no SiteVisitor' do
      it 'creates a SiteVisitor for the user' do
        expect { subject }.to change { GreenFlag::SiteVisitor.count }.by(1)
      end
    end

    context 'when the FeatureDecision does not exist' do
      it 'creates a new FeatureDecision' do
        expect { subject }.to change { GreenFlag::FeatureDecision.count }.by(1)
      end
      it { should be_enabled }
      it { should_not be_manual }
    end

    context 'when the FeatureDecision already exits' do
      let!(:site_visitor) { GreenFlag::SiteVisitor.create(visitor_code: '123', user_id: user.id) }
      let!(:feature_decision) { GreenFlag::FeatureDecision.create(feature: feature, site_visitor: site_visitor) }

      it 'does not creates a new FeatureDecision' do
        expect { subject }.to_not change { GreenFlag::FeatureDecision.count }
      end
      it { should be_enabled }
      it { should_not be_manual }
    end
  end

  describe 'safe_save!' do
    let(:feature_id)      { 1 }
    let(:site_visitor_id) { 1 }

    context 'when the database already contains a feature decision with the site visitor ID and feature ID' do
      before(:each) do
        @existing_fd = GreenFlag::FeatureDecision.create!(feature_id: feature.id, site_visitor_id: site_visitor_id, enabled: false)
        @new_fd      = GreenFlag::FeatureDecision.new(feature_id: feature.id, site_visitor_id: site_visitor_id, enabled: false)
      end

      it 'returns the matching feature decision that was already stored' do
        expect(@new_fd.safe_save!).to eq @existing_fd
      end
    end

    context 'when the database not already contain a feature decision with the site visitor ID and feature ID' do
      let(:feature_decision) { GreenFlag::FeatureDecision.new(feature_id: 2, site_visitor_id: 2, enabled: false) }

      it 'saves the record' do
        expect(feature_decision).to receive(:save!)
        feature_decision.safe_save!
      end

      it 'returns true' do
        expect(feature_decision.safe_save!).to eq true
      end
    end
  end
end
