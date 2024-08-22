class HearingTypePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      case @user
      when CasaAdmin
        scope.where(casa_org_id: @user.casa_org.id)
      else
        scope.none
      end
    end
  end

  alias_method :index?, :admin?
  # TODO: below: :admin_same_org?
  alias_method :new?, :admin?
  alias_method :create?, :admin?
  alias_method :show?, :admin?
  alias_method :edit?, :admin?
  alias_method :update?, :admin?
  alias_method :destroy?, :admin?
end
