class ComplaintsController < ApplicationController
  layout 'blanco'
  before_action :authenticate_business!
  before_action :business_profile_complete!
  before_action :set_cities
  before_action :complaint_params, only: [:create, :update]

  def new
    @complaint = Complaint.new
    authorize @complaint
  end

  def create
   @complaint = Complaint.new(
                  user: current_user,
                  city: @city,
                  reason: complaint_params[:reason],
                  custom_reason: complaint_params[:custom_reason],
                  description: complaint_params[:description]
                 )
    authorize @complaint
    if @complaint.save
      redirect_to city_inspections_path(@city),
        notice: I18n.t('complaints.created_successfully')
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  private

  def set_cities
    @city = City.find(params[:city_id])
    @cities = City.all
  end

  def complaint_params
    params.require(:complaint).permit(
      :reason,
      :custom_reason,
      :description
    )
  end
end
