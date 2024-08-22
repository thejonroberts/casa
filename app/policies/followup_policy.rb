class FollowupPolicy < ApplicationPolicy
  # TODO: Scope
  def create?
    admin_or_supervisor_or_volunteer?
  end

  # TODO: check org in resolve?
  alias_method :resolve?, :create?
end
