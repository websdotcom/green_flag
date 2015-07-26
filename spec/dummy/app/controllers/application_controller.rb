class ApplicationController < ActionController::Base
  include GreenFlag::SiteVisitorManagement
  protect_from_forgery

  def current_user
    nil
  end
end
