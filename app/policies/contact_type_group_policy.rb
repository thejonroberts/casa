class ContactTypeGroupPolicy < ApplicationPolicy
  alias_method :index?, :admin?
  # TODO: below: :admin_same_org?
  alias_method :new?, :admin?
  alias_method :create?, :admin?
  alias_method :show?, :admin?
  alias_method :edit?, :admin?
  alias_method :update?, :admin?
  alias_method :destroy?, :admin?
end
