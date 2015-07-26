class GreenFlag::Admin::FeaturesController < ApplicationController

  layout 'green_flag/application'

  def index
    @features = GreenFlag::Feature.all
  end

  def show
    @feature = GreenFlag::Feature.find(params[:id])
    @visitor_groups = GreenFlag::VisitorGroup.all.map { |group| { key: group.key, description: group.description } }
  end

  def current_visitor_status
    @feature = GreenFlag::Feature.find(params[:id])
    fd = GreenFlag::FeatureDecision.for_feature(@feature.id).where(site_visitor_id: current_site_visitor.id).first
    render :json => { status: status_text(fd) }
  end

private

  def status_text(feature_decison)
    if feature_decison.nil? || feature_decison.undecided?
      "Undecided"
    elsif feature_decison.enabled?
      "Enabled"
    else
      "Disabled"
    end
  end

end
