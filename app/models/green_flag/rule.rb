class GreenFlag::Rule < ActiveRecord::Base
  attr_protected # none

  validates :feature_id, presence: true
  validates :group_key, presence: true
  validates :order_by, presence: true
  validates :percentage, presence: true, 
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  self.include_root_in_json = false

  class << self
    public

    def set_rules!(feature_id, rules_array)
      return [] if rules_array.empty?

      rules = create_new_rules(feature_id, rules_array)

      transaction { rules.each(&:save!) } 

      rules
    end

    private

    def create_new_rules(feature_id, rules_array)
      new_version_number = increment_feature_version(feature_id)

      rules_array.map do |rule_attributes|
        rule_attributes[:feature_id] = feature_id
        create_new_rule_version(new_version_number, rule_attributes)
      end
    end

    def increment_feature_version(feature_id)
      feature = GreenFlag::Feature.find(feature_id)

      feature.update_attributes(version_number: feature.latest_version + 1)
      feature.version_number
    end

    def create_new_rule_version(new_version_number, rule_attributes)
      GreenFlag::Rule.new(rule_attributes.except(:id).merge(version_number: new_version_number))
    end
  end

  def applies_to?(visitor)
    visitor_group.includes_visitor?(visitor, self)
  end

  def decision?
    r = Random.rand(100)
    r < percentage
  end

  def group_description
    visitor_group.description
  end

private

  def visitor_group
    GreenFlag::VisitorGroup.for_key(group_key)
  end
end
