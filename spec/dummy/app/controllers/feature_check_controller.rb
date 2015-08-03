class FeatureChecksController < ApplicationController

  def index
    if(feature_enabled?(:test_feature))
      render text: 'IS ENABLED'
    else
      render text: 'NOT ENABLED'      
    end
  end
end