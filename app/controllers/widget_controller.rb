class WidgetController < ApplicationController
  before_action :require_organization!
  before_action :set_widget, only: %i[ show edit update destroy ]

  def index
    # authorize :widget # use if limiting view to admin/supervisor
    # @case_groups = policy_scope(Widget) # if current_organization not applicable
    @widgets = policy_scope(current_organization.widgets)
      # .includes(:association) # includes to avoid n+1 as needed
  end

  def new
    # authorize :widget # if action on collection (use policy_scope)
    authorize @widget # if action on record/instance
  end

  def create
    # authorize :widget # if action on collection (use policy_scope)
    authorize @widget # if action on record/instance
  end

  def show
    # authorize :widget # if action on collection (use policy_scope)
    authorize @widget # if action on record/instance
  end

  private

  def set_widget
    @widget = policy_scope(Widget).find(params[:id])
  end

  def widget_params
    # add allowed attributes
    params.require(:widget).permit()
  end
end
