require 'spec_helper'

describe GreenFlag::Admin::RuleListsController do

  let(:feature) { GreenFlag::Feature.create(code: 'asdf') }

  describe '#show' do
    subject { get :show, feature_id: feature.id, format: 'js' }
    it { should be_successful }
  end

  describe '#update' do
    let(:empty_rules_json) { [] }
    subject do 
      post :update, feature_id: feature.id, format: 'js',
        '_json' =>  empty_rules_json
    end
    it { should be_successful }
    it 'sends the rules to a model' do
      expect(GreenFlag::Rule).to receive(:set_rules!).with(feature.id, [])
      subject
    end
  end

end
