require 'spec_helper'

describe GreenFlag::Admin::FeatureDecisionSummariesController do

  let(:feature) { GreenFlag::Feature.create(code: 'asdf') }

  describe '#show' do
    subject { get :show, feature_id: feature.id, format: 'js' }
    it { should be_successful }
  end

  describe '#update' do
    subject { post :update, feature_id: feature.id, format: 'js' }
    it { should be_successful }
  end

end
