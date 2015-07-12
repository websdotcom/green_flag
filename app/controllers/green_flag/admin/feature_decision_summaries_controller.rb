class GreenFlag::Admin::FeatureDecisionSummariesController < ApplicationController

  def show
    feature_id = params[:feature_id]
    feature = GreenFlag::Feature.find(feature_id)

    render :json => summary(feature)
  end

  def update
    feature_id = params[:feature_id]
    feature = GreenFlag::Feature.find(feature_id)

    if params[:forget_enabled]
      feature.forget_non_manual_decisions!(true)
    end
    if params[:forget_disabled]
      feature.forget_non_manual_decisions!(false)
    end

    render :json => summary(feature)
  end

private

  def summary(feature)
    {
      enabled: feature.enabled_count,
      disabled: feature.disabled_count,
    }
  end

end
