class LanguagePolicy < ApplicationPolicy
  alias_method :add_language?, :is_volunteer?
  alias_method :remove_from_volunteer?, :is_volunteer?

  # TODO: these should all check :admin_same_org?
  alias_method :new?, :admin?
  alias_method :create?, :admin?
  alias_method :edit?, :admin?
  alias_method :update?, :admin?
end
