class GreenFlag::Feature < ActiveRecord::Base
  attr_protected #none

  has_many :rules, :conditions => proc { "version_number = #{self.version_number}" }, order: 'order_by'
  has_many :feature_decisions
  has_many :feature_events

  validates_presence_of :code

  self.include_root_in_json = false

  #DELETION_MAX_FEATURE_DECISIONS = 1000000
   DELETION_MAX_FEATURE_DECISIONS = 0

  def self.for_code!(code)
    feature = where(code: code.to_s).first
    unless feature
      feature = create!(code: code.to_s)
    end
    feature
  rescue ActiveRecord::RecordNotUnique, PG::Error => ex
    # Race condition
    where(code: code.to_s).first || raise
  end

  def decide_if_enabled_for_visitor(site_visitor_id)
    fd_query         = GreenFlag::FeatureDecision.where(feature_id: id, site_visitor_id: site_visitor_id)
    feature_decision = fd_query.first_or_initialize

    if feature_decision.undecided?
      decide_feature_decision(feature_decision)
    end

    feature_decision
  end

  def enabled_count
    feature_decisions.enabled.count
  end

  def disabled_count
    feature_decisions.disabled.count
  end

  def forget_non_manual_decisions!(enabled)
    non_manual_fds = feature_decisions.non_manual.where(enabled: enabled)

    if non_manual_fds.count > 0
      create_feature_event(enabled, non_manual_fds.count)
      non_manual_fds.delete_all
    end
  end

  def latest_version
    last_rule = GreenFlag::Rule.order('version_number DESC').where(feature_id: id).first

    last_rule.present? ? last_rule.version_number : version_number
  end

  def fully_enabled?
    rules.count > 0 && rules.all? { |rule| rule.percentage == 100 }
  end

  def fully_disabled?
    rules.count == 0 || rules.all? { |rule| rule.percentage == 0 }
  end

  def require_manual_deletion?
    feature_decisions.count >= DELETION_MAX_FEATURE_DECISIONS
  end

  def delete_associated_data
    GreenFlag::Rule.where(feature_id: id).delete_all
    GreenFlag::FeatureDecision.where(feature_id: id).delete_all
    GreenFlag::FeatureEvent.where(feature_id: id).delete_all
  end

  private

  def decide_feature_decision(feature_decision)
    matched_rule = rules.find { |rule| rule.applies_to?(feature_decision.site_visitor) }

    if matched_rule
      feature_decision.rule_id = matched_rule.id
      feature_decision.enabled = !!matched_rule.decision?
    end

    saved_feature_decision(feature_decision)
  end

  def saved_feature_decision(feature_decision)
    save_result = feature_decision.safe_save!

    if save_result == true
      feature_decision
    else
      save_result
    end
  end

  def create_feature_event(enabled, count)
    event_type_code = (enabled == true ? GreenFlag::FeatureEvent::ENABLED_DECISIONS_FORGOTTEN : GreenFlag::FeatureEvent::DISABLED_DECISIONS_FORGOTTEN)
    GreenFlag::FeatureEvent.create!(feature_id: id, event_type_code: event_type_code, count: count)
  end
end
