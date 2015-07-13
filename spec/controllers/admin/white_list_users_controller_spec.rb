require 'spec_helper'

describe GreenFlag::Admin::WhiteListUsersController do

  describe '#index' do
    subject { get :index, feature_id: 1, format: 'js' }
    context 'with no whitelisted users' do
      before(:each) do
        allow(GreenFlag::FeatureDecision).to receive(:whitelisted_users) { [] }
      end
      it { should be_successful }
    end
  end

end
