class CasaWidgetsController < ApplicationController
  before_action :require_organization!
  before_action :set_casa_widget, only: %i[ show edit update destroy ]

  def index
    # authorize CasaWidget # use if limiting view to admin/supervisor
    # @casa_widgets = policy_scope(CasaWidget) # if current_organization not applicable (rare)
    @casa_widgets = policy_scope(current_organization.casa_widgets)
      # .includes(:association) # includes to avoid n+1 as needed
  end

  def show
    authorize @casa_widget
  end

  def new
    @casa_widget = CasaWidget.new
    authorize @casa_widget
  end

  def edit
    authorize @casa_widget
  end

  def create
    @casa_widget = CasaWidget.new(casa_widget_params)
    authorize @casa_widget

    if @casa_widget.save
      redirect_to @casa_widget, notice: "Casa widget created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @casa_widget

    if @casa_widget.update(casa_widget_params)
      redirect_to @casa_widget, notice: "Casa widget updated!", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @casa_widget

    @casa_widget.destroy!
    redirect_to casa_widgets_url, notice: "Casa widget deleted!", status: :see_other
  end

  private

  def set_casa_widget
    @casa_widget = policy_scope(CasaWidget).find(params[:id])
  end

  def casa_widget_params
    params.require(:casa_widget).permit(:name, :body, :hidden, :amount, :tracking_id, :email, :password, :password_confirmation)
  end
end
