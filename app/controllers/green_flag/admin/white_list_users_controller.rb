class GreenFlag::Admin::WhiteListUsersController < ApplicationController

  def index
    feature_id = params[:feature_id]
    users = GreenFlag::FeatureDecision.whitelisted_users(feature_id)

    users.each { |u| u.include_root_in_json = false }

    respond_to do |format|
      format.js { render :json => users.to_json }
    end
  end

  def create
    feature_id = params[:feature_id]
    feature = GreenFlag::Feature.find(feature_id)

    user = User.where(email: params[:email]).first
    GreenFlag::FeatureDecision.whitelist_user!(feature.code, user)

    user.include_root_in_json = false

    respond_to do |format|
      format.js { render :json => user.to_json }
    end
  end

  def destroy
    feature_id = params[:feature_id]
    user_id = params[:id]

    fd = GreenFlag::FeatureDecision.for_user(user_id).for_feature(feature_id).first
    fd.destroy

    respond_to do |format|
      format.js { render :json => '' }
    end
  end
end
