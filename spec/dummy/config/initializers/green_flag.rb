GreenFlag::VisitorGroup.define do

  # Basic Groups
  group "Everyone", "This is everyone!" do
    true
  end
  group "New visitors", "These are visitors who have never logged in.  (This does not include users who have signed out)" do |site_visitor|
    !site_visitor.user
  end
  group "Pre-existing Visitors", "Visitors that were created before this feature was deployed.  They might have seen the old version." do |visitor, rule|
    visitor.first_visited_at < rule.created_at
  end

end