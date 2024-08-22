class ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError
    end
  end

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    is_admin?
  end

  def show?
    admin_same_org?
  end

  def create?
    admin_same_org?
  end

  def new?
    is_admin? # same_org?
  end

  def update?
    admin_same_org?
  end

  def edit?
    admin_same_org?
  end

  def destroy?
    admin_same_org?
  end

  def is_admin?
    user&.casa_admin?
  end
  alias_method :admin?, :is_admin?

  def same_org?
    user_org? && user.casa_org == record&.casa_org
  end

  def is_admin_same_org?
    admin? && same_org?
  end
  alias_method :admin_same_org?, :is_admin_same_org?

  def is_supervisor?
    user&.supervisor?
  end
  alias_method :supervisor?, :is_supervisor?

  def is_supervisor_same_org?
    supervisor? && same_org?
  end
  alias_method :supervisor_same_org?, :is_supervisor_same_org?

  def is_volunteer?
    user&.volunteer?
  end
  alias_method :volunteer?, :is_volunteer?

  def is_volunteer_same_org?
    volunteer? && same_org?
  end
  alias_method :volunteer_same_org?, :is_volunteer_same_org?

  def admin_or_supervisor?
    is_admin? || is_supervisor?
  end

  def admin_or_supervisor_same_org?
    admin_or_supervisor? && same_org?
  end

  def admin_or_supervisor_or_volunteer?
    admin? || supervisor? || volunteer?
  end

  def admin_or_supervisor_or_volunteer_same_org?
    admin_or_supervisor_or_volunteer? && same_org?
  end

  def see_reports_page?
    # ModelPolicy#view_reports? - currently used for multiple models
    is_supervisor? || is_admin?
  end

  def see_emancipation_checklist?
    # Emancipation Policy?
    is_volunteer?
  end

  def see_court_reports_page?
    # Report Policy?  or ModelPolicy#reports?
    is_volunteer? || is_supervisor? || is_admin?
  end

  def see_mileage_rate?
    # ORG policy? MileageRatePolicy?
    admin? && reimbursement_enabled?
  end

  def reimbursement_enabled?
    # ORG policy? ReimbursementPolicy?
    current_organization&.show_driving_reimbursement
  end

  def current_organization
    user&.casa_org
  end

  def user_org?
    user&.casa_org.present?
  end

  # Application Policies (as in layout sidebar)
  alias_method :modify_organization?, :is_admin?
  alias_method :see_banner_page?, :admin_or_supervisor?
end
