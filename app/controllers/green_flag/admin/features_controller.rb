require 'pp'

class GreenFlag::Admin::FeaturesController < ApplicationController
  layout 'green_flag/application'
  helper_method :flash_class

  before_filter :find_feature, only: [:show, :destroy]

  def index
    @features = GreenFlag::Feature.order(:created_at).all
  end

  def show
    @visitor_groups = GreenFlag::VisitorGroup.all.map { |group| { key: group.key, description: group.description } }
  end

  def destroy
    if @feature.present?
      feature_code = @feature.code

      if @feature.require_manual_deletion?
        message = "Feature \"#{feature_code}\" requires manual deletion due to its large number of associated feature decisions."
      else
        @feature.delete_associated_data
        @feature.destroy

        message = "Feature \"#{feature_code}\" has been successfully deleted."
      end
    end

    flash[:notice] = message

    redirect_to action: :index
  end

  def current_visitor_status
    @feature = GreenFlag::Feature.find(params[:id])
    fd = GreenFlag::FeatureDecision.for_feature(@feature.id).where(site_visitor_id: current_site_visitor.id).first
    render :json => { status: status_text(fd) }
  end

private

  def find_feature
    @feature = GreenFlag::Feature.where(id: params[:id]).first
  end

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
