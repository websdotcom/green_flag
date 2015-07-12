require 'spec_helper'

describe GreenFlag::Admin::WhiteListUsersController do

  let(:user) { FactoryGirl.create(:user) }

  let(:feature) { GreenFlag::Feature.create(code: 'asdf') }
  let(:site_visitor) { GreenFlag::SiteVisitor.create!(user_id: user.id, visitor_code: '123') }
  let(:whitelist_feature_decision) { GreenFlag::FeatureDecision.create!(feature: feature, site_visitor: site_visitor, enabled: true, manual: true) }

  describe '#index' do
    subject { get :index, feature_id: feature.id, format: 'js' }
    it { should be_successful }
  end

end
