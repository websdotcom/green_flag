require 'spec_helper'

describe GreenFlag::Admin::FeaturesController do
  let(:feature) { GreenFlag::Feature.create(code: 'foo') }

  describe '#index' do
    it 'is successful' do
      get :index
      expect(response).to be_success
    end
  end  

  describe '#show' do
    it 'is successful' do
      get :show, :id => feature.id
      expect(response).to be_success
    end
  end

  describe '#destroy' do
    subject { delete :destroy, id: feature.id }

    it 'redirects to the index action' do
      expect(subject).to redirect_to action: :index
    end

    context 'when the feature can be deleted' do
      before(:each) do
        5.times do
          FactoryGirl.create(:green_flag_rule, feature_id: feature.id)
          FactoryGirl.create(:green_flag_feature_event, feature_id: feature.id)
          FactoryGirl.create(:green_flag_feature_decision, feature_id: feature.id)
        end

        subject
      end

      it 'deletes the feature' do
       expect(GreenFlag::Feature.find_by_id(feature.id)).to be_nil
      end

      it "deletes the feature's rules" do
        expect(GreenFlag::Rule.where(feature_id: feature.id)).to eq []
      end

      it "deletes the feature's events" do
        expect(GreenFlag::FeatureEvent.where(feature_id: feature.id)).to eq []
      end

      it "deletes the feature's feature decisions" do
        expect(GreenFlag::FeatureDecision.where(feature_id: feature.id)).to eq []
      end

      it 'sets a successful flash notice' do
        expect(flash[:notice]).to eq "Feature \"#{feature.code}\" has been successfully deleted."
      end
    end

    context 'when the feature cannot be deleted' do
      it 'sets a flash notice indicating that manual deletion is required' do
        allow_any_instance_of(GreenFlag::Feature).to receive(:requires_manual_deletion?).and_return(true)

        subject

        expect(flash[:notice]).to eq "Feature \"#{feature.code}\" requires manual deletion due to its large number of associated feature decisions."
      end
    end

    context 'when the feature cannot be found' do
      it 'sets a flash error indicating the error' do
        feature.destroy

        subject

        expect(flash[:error]).to eq 'The feature could not be found.'
      end
    end
  end
end
