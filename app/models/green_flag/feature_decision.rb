class GreenFlag::FeatureDecision < ActiveRecord::Base

  attr_protected #none

  validates_presence_of :feature_id, :site_visitor_id

  belongs_to :feature
  belongs_to :site_visitor
  belongs_to :rule 
  
  has_one :user, through: :site_visitor

  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }
  scope :whitelisted, ->(feature_id) { 
    for_feature(feature_id).enabled.where(manual: true).order(:created_at)
  }
  scope :for_user, ->(user_id) {
    joins(:site_visitor).where('green_flag_site_visitors.user_id = ?', user_id)
  }
  scope :for_feature, ->(feature_id) {
    where(feature_id: feature_id)
  }
  scope :non_manual, -> { where('manual is not true') }

  # Check if the feature is enabled, AND store the result as a FeatureDecision
  def self.feature_enabled?(feature_code, site_visitor_id)
    feature = GreenFlag::Feature.for_code!(feature_code)
    fd      = feature.decide_if_enabled_for_visitor(site_visitor_id)

    fd.enabled
  end

  def self.feature_enabled_for_user?(feature_code, user)
    feature_enabled? feature_code, GreenFlag::SiteVisitor.for_user!(user).id
  end

  # Force the given user to have the feature enabled
  def self.whitelist_user!(feature_code, user)
    ensure_feature_enabled(feature_code, user, true)
  end

  def self.ensure_feature_enabled(feature_code, user, manual=false)
    feature = GreenFlag::Feature.for_code!(feature_code)
    visitor = GreenFlag::SiteVisitor.for_user!(user)

    fd = GreenFlag::FeatureDecision.where(feature_id: feature.id, 
      site_visitor_id: visitor.id).first_or_initialize

    unless fd.enabled? && fd.manual == manual
      fd.enabled = true
      fd.manual = manual
      fd.save!
    end
    fd
  end

  def self.whitelisted_users(feature_id)
    # inefficient, but shouldn't matter.
    feature_decisions = whitelisted(feature_id).joins(:site_visitor => :user).all
    users = feature_decisions.map(&:user)
  end

  def undecided?
    self.enabled.nil?
  end

  def safe_save!
    begin
      save!
      true
    rescue ActiveRecord::RecordNotUnique, PG::Error => ex
      # Race condition
      self.class.where(feature_id: feature_id, site_visitor_id: site_visitor_id).first || raise
    end
  end
end
