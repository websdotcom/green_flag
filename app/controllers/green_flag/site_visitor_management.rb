module GreenFlag::SiteVisitorManagement
  COOKIE_NAME = 'green_flag_site_visitor'

  def self.included(base)
    base.before_filter :set_site_visitor
    base.helper_method :feature_enabled?
  end

  # Ensure we have a cookie
  def set_site_visitor
    ensure_code_cookie
    record_login(current_user) if current_user
  end

  # Make sure the current SiteVisitor is the correct visitor for this user
  def record_login(user)
    self.current_site_visitor = GreenFlag::SiteVisitor.for_user!(user, current_site_visitor)
  end

  # Finds or creates a GreenFlag::SiteVisitor
  def current_site_visitor
    @current_site_visitor ||= begin
      code = ensure_code_cookie
      GreenFlag::SiteVisitor.for_visitor_code!(code)
    end
  end

  def feature_enabled?(feature_code)
    @features_enabled ||= {}
    if @features_enabled[feature_code].nil?
      visitor_id = current_site_visitor.id
      @features_enabled[feature_code] = GreenFlag::FeatureDecision.feature_enabled?(feature_code, visitor_id)
    end
    @features_enabled[feature_code]
  end

private

  def current_site_visitor=(visitor)
    @current_site_visitor = visitor
    cookies.permanent[COOKIE_NAME] = current_site_visitor.visitor_code
  end

  def ensure_code_cookie
    unless cookies[COOKIE_NAME]
      cookies.permanent[COOKIE_NAME] = GreenFlag::SiteVisitor.new_code
    end
    cookies[COOKIE_NAME]
  end

end