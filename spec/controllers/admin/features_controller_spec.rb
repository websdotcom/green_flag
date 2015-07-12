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

end
