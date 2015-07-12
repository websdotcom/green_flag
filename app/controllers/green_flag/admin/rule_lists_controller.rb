class GreenFlag::Admin::RuleListsController < ApplicationController

  def show
    feature_id = params[:feature_id]
    feature = GreenFlag::Feature.find(feature_id)
    rules = feature.rules

    render :json => rules.to_json(methods: :group_description)
  end

  def update
    feature_id = params[:feature_id].to_i
    rule_array = params['_json'] || []

    filter_rules(rule_array)

    rules = GreenFlag::Rule.set_rules!(feature_id, rule_array)
    render :json => rules.to_json(methods: :group_description)
  end

private

  def filter_rules(rule_array)
    rule_array.each do |rule|
      rule.delete('group_description')
    end
  end
end
