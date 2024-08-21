class PatchNotePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user.present?

      return scope.all if user.is_a?(AllCasaAdmin)

      scope.notes_available_for_user(user)
    end
  end

  def index?
    user.present?
  end
end
