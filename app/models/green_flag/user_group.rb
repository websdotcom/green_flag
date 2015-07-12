class GreenFlag::UserGroup < GreenFlag::VisitorGroup

  def includes_visitor?(visitor, rule=nil)
    user_exists = !!visitor.user
    user_exists && evaluator.call(visitor.user, rule)
  end

end