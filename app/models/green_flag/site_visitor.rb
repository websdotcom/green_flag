# A SiteVisitor is a unique visitor to the site.
class GreenFlag::SiteVisitor < ActiveRecord::Base

  attr_protected # none

  belongs_to :user
  has_many :feature_decisions

  # Finds, updates, or creates a SiteVisitor for the given user.
  # If the user has an existing SiteVisitor, return that
  # Otherwise, check if the given SiteVisitor can be assigned to the user.
  # Otherwise, create a brand new SiteVisitor
  def self.for_user!(user, visitor_to_check=nil)
    where(user_id: user.id).first ||
      assign_visitor_if_available(visitor_to_check, user) ||
      create!(user_id: user.id, visitor_code: new_code)
  rescue ActiveRecord::RecordNotUnique, PG::Error => ex
    # Race condition - some other request created/updated a SiteVisitor with our user's id
    where(user_id: user.id).first || raise
  end

  def self.for_visitor_code!(code)
    where(visitor_code: code).first_or_create!
  rescue ActiveRecord::RecordNotUnique, PG::Error => ex
    # Race condition
    where(visitor_code: code).first || raise
  end

  def self.new_code
    SecureRandom.uuid
  end

  # If GreenFlag is added to an existing app, 
  # then some users might be older than their corresponding SiteVisitors
  def first_visited_at
    [created_at, user.try(:created_at), DateTime.now].compact.min
  end

private

  def self.assign_visitor_if_available(visitor, user)
    if visitor && visitor.user_id.nil?
      visitor.update_attribute(:user_id, user.id)
      return visitor
    end
    nil
  end

end
