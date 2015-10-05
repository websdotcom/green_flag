class GreenFlag::Admin::FeaturesController < ApplicationController
  layout 'green_flag/application'
  helper_method :flash_class

  def index
    @features = GreenFlag::Feature.order(:created_at).all
  end

  def show
    @feature = GreenFlag::Feature.where(id: params[:id]).first

    @visitor_groups = GreenFlag::VisitorGroup.all.map { |group| { key: group.key, description: group.description } }
  end

  def destroy
    @feature = GreenFlag::Feature.where(id: params[:id]).first

    if @feature.present?
      destroy_feature_or_set_manual_deletion_notice
    else
      flash[:error] = "The feature could not be found."
    end

    redirect_to action: :index
  end

  def current_visitor_status
    @feature = GreenFlag::Feature.find(params[:id])
    fd = GreenFlag::FeatureDecision.for_feature(@feature.id).where(site_visitor_id: current_site_visitor.id).first
    render :json => { status: status_text(fd) }
  end

private

  def destroy_feature
    flash[:notice] = "Feature \"#{@feature.code}\" has been successfully deleted."

    @feature.delete_associated_data
    @feature.destroy
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
